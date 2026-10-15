import SwiftUI

struct GEMTimelineView: View {
    @EnvironmentObject private var library: GEMLibrary
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var selectedCategory: String?
    @State private var lastJumpedEra: Int?

    private var events: [GEMEntry] {
        library.filteredEvents(category: selectedCategory, era: nil)
    }

    private var categories: [String] {
        Array(Set(library.entries(of: .event).map(\.category))).filter { !$0.isEmpty }.sorted()
    }

    private var eras: [Int] {
        Array(Set(events.map { ($0.date.year / 10) * 10 })).sorted()
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 26) {
                    GEMExploreIntro(
                        eyebrow: "THE STORY SO FAR",
                        title: "一步一步，走進她的故事",
                        message: "從出道、作品到舞台與里程碑。點開一個時刻，看看它與哪一首歌、哪一張作品相連。"
                    )
                    .id("timeline-start")

                    Text("目前顯示 \(events.count) 件故事")
                        .font(GEMFont.body(14))
                        .foregroundStyle(GEMPalette.secondary(for: colorScheme))
                        .accessibilityLabel("目前顯示 \(events.count) 件成長事件")

                    if events.isEmpty {
                        GEMEmptyState(title: "這個分類暫無故事", message: "切換其他分類，或查看全部事件。", symbol: "clock")
                        Button("查看全部事件") {
                            selectCategory(nil, proxy: proxy)
                        }
                        .buttonStyle(.borderedProminent)
                    } else {
                        ForEach(eras, id: \.self) { era in
                            eraSection(era)
                                .id("era-\(era)")
                        }
                    }

                    Text("時間依已確認的年份或日期排列；未有精確日期的事件僅顯示年份。每則詳情可查看資料來源。")
                        .font(GEMFont.body(13))
                        .foregroundStyle(GEMPalette.secondary(for: colorScheme))
                        .lineSpacing(5)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(20)
                .frame(maxWidth: 800)
                .frame(maxWidth: .infinity)
            }
            .safeAreaInset(edge: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            GEMFilterChip(title: "全部故事", isSelected: selectedCategory == nil) {
                                selectCategory(nil, proxy: proxy)
                            }
                            ForEach(categories, id: \.self) { category in
                                GEMFilterChip(title: category, isSelected: selectedCategory == category) {
                                    selectCategory(category, proxy: proxy)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }

                    if !eras.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                Text("跳到年代")
                                    .font(GEMFont.body(13))
                                    .foregroundStyle(GEMPalette.secondary(for: colorScheme))
                                ForEach(eras, id: \.self) { era in
                                    GEMFilterChip(title: "\(era) 年代", isSelected: lastJumpedEra == era) {
                                        lastJumpedEra = era
                                        if reduceMotion {
                                            proxy.scrollTo("era-\(era)", anchor: .top)
                                        } else {
                                            withAnimation(.easeInOut(duration: 0.25)) {
                                                proxy.scrollTo("era-\(era)", anchor: .top)
                                            }
                                        }
                                    }
                                    .accessibilityHint("捲動到 \(era) 到 \(era + 9) 年的故事")
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.regularMaterial)
            }
        }
        .background { GEMScreenBackground() }
        .navigationTitle("成長時間線")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func eraSection(_ era: Int) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                Text(String(era))
                    .font(GEMFont.display(32))
                    .foregroundStyle(GEMPalette.purple)
                Text("— \(String(era + 9))")
                    .font(GEMFont.headline(18))
                    .foregroundStyle(GEMPalette.secondary(for: colorScheme))
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("\(era) 至 \(era + 9) 年")
            .accessibilityAddTraits(.isHeader)
            ForEach(events.filter { ($0.date.year / 10) * 10 == era }) { entry in
                GEMExplorationRow(entry: entry)
            }
        }
    }

    private func selectCategory(_ category: String?, proxy: ScrollViewProxy) {
        selectedCategory = category
        lastJumpedEra = nil
        // Reset only when the user changes the filter; pushing and popping details
        // leaves both the filter and the scroll view's position in place.
        proxy.scrollTo("timeline-start", anchor: .top)
    }
}

struct GEMLibraryView: View {
    @EnvironmentObject private var library: GEMLibrary
    @Environment(\.colorScheme) private var colorScheme
    private let initialKind: GEMEntryKind
    @State private var selectedKindOverride: GEMEntryKind? = nil
    @State private var selectedCategory: String?
    @State private var newestFirst = true

    private let kinds: [GEMEntryKind] = [.release, .track, .program, .stage]
    private var selectedKind: GEMEntryKind { selectedKindOverride ?? initialKind }

    init(initialKind: GEMEntryKind = .release) {
        // The initial route is immutable input. User selection is declared state,
        // so this also avoids writing State macro backing storage in Xcode 27.
        self.initialKind = initialKind == .event ? .release : initialKind
    }

    private var categories: [String] {
        Array(Set(library.entries(of: selectedKind).map(\.category))).filter { !$0.isEmpty }.sorted()
    }

    private var entries: [GEMEntry] {
        let result = library.entries(of: selectedKind).filter {
            selectedCategory == nil || $0.category == selectedCategory
        }
        return result.sorted { lhs, rhs in
            if lhs.date.sortKey == rhs.date.sortKey { return lhs.id < rhs.id }
            return newestFirst ? lhs.date.sortKey > rhs.date.sortKey : lhs.date.sortKey < rhs.date.sortKey
        }
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                GEMExploreIntro(
                    eyebrow: "MUSIC & MOMENTS",
                    title: "從作品，聽見不同時期",
                    message: "打開作品讀背景，從曲目走進歌曲，再找到它的其他版本與相關舞台。這裡收錄的是有來源的精選檔案。"
                )

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(kinds, id: \.self) { kind in
                            GEMFilterChip(title: kind.title, isSelected: selectedKind == kind) {
                                selectedKindOverride = kind
                                selectedCategory = nil
                            }
                        }
                    }
                }

                if categories.count > 1 {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            GEMFilterChip(title: "全部類型", isSelected: selectedCategory == nil) {
                                selectedCategory = nil
                            }
                            ForEach(categories, id: \.self) { category in
                                GEMFilterChip(title: category, isSelected: selectedCategory == category) {
                                    selectedCategory = category
                                }
                            }
                        }
                    }
                }

                HStack(alignment: .firstTextBaseline, spacing: 16) {
                    Text("\(entries.count) 件\(selectedKind.title)")
                        .font(GEMFont.body(14))
                        .foregroundStyle(GEMPalette.secondary(for: colorScheme))
                    Spacer(minLength: 0)
                    Menu {
                        Button {
                            newestFirst = true
                        } label: {
                            Label("最新優先", systemImage: newestFirst ? "checkmark" : "arrow.down")
                        }
                        Button {
                            newestFirst = false
                        } label: {
                            Label("從起點開始", systemImage: newestFirst ? "arrow.up" : "checkmark")
                        }
                    } label: {
                        Label(newestFirst ? "最新優先" : "從起點開始", systemImage: "arrow.up.arrow.down")
                            .font(GEMFont.body(14))
                    }
                    .accessibilityLabel("排序：\(newestFirst ? "最新優先" : "從起點開始")")
                }

                if entries.isEmpty {
                    GEMEmptyState(title: "尚無符合的內容", message: "切換類型，繼續探索其他作品與舞台。", symbol: "square.stack")
                } else {
                    ForEach(entries) { entry in
                        GEMExplorationRow(entry: entry)
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: 800)
            .frame(maxWidth: .infinity)
        }
        .background { GEMScreenBackground() }
        .navigationTitle("作品與舞台")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: GEMRoute.search) {
                    Label("搜尋內容", systemImage: "magnifyingglass")
                }
            }
        }
    }
}

struct GEMSearchView: View {
    @EnvironmentObject private var library: GEMLibrary
    @Environment(\.colorScheme) private var colorScheme
    @State private var query = ""
    @State private var selectedKind: GEMEntryKind?

    private let kinds: [GEMEntryKind] = [.event, .release, .track, .program, .stage]
    private let suggestedQueries = ["泡沫", "2014", "摩天動物園", "重錄", "啟示錄"]
    private var trimmedQuery: String { query.trimmingCharacters(in: .whitespacesAndNewlines) }
    private var results: [GEMEntry] { library.search(query: trimmedQuery, kind: selectedKind) }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                GEMExploreIntro(eyebrow: "FIND A CONNECTION", title: "想從哪裡開始？", message: "輸入歌曲、作品、節目、年份或關鍵字，找到彼此相連的故事。搜尋使用 App 內的精選資料。")

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        GEMFilterChip(title: "全部內容", isSelected: selectedKind == nil) { selectedKind = nil }
                        ForEach(kinds, id: \.self) { kind in
                            GEMFilterChip(title: kind.title, isSelected: selectedKind == kind) {
                                selectedKind = kind
                            }
                        }
                    }
                }

                if trimmedQuery.isEmpty {
                    VStack(alignment: .leading, spacing: 14) {
                        Text("試試這些關鍵字")
                            .font(GEMFont.headline(18))
                            .foregroundStyle(GEMPalette.foreground(for: colorScheme))
                            .accessibilityAddTraits(.isHeader)
                        ForEach(suggestedQueries, id: \.self) { suggestion in
                            Button {
                                query = suggestion
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: "magnifyingglass")
                                    Text(suggestion)
                                    Spacer()
                                    Image(systemName: "arrow.up.left")
                                }
                                .font(GEMFont.body(16))
                                .padding(.vertical, 11)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .foregroundStyle(GEMPalette.purple)
                            .accessibilityLabel("搜尋 \(suggestion)")
                        }
                    }
                } else {
                    HStack(alignment: .firstTextBaseline) {
                        Text("找到 \(results.count) 件內容")
                            .font(GEMFont.body(14))
                            .foregroundStyle(GEMPalette.secondary(for: colorScheme))
                            .accessibilityLabel("\(query)，找到 \(results.count) 件內容")
                        Spacer(minLength: 8)
                        Button("清除條件") { clearSearch() }
                            .font(GEMFont.body(14))
                    }

                    if results.isEmpty {
                        GEMEmptyState(title: "還沒找到這段故事", message: "試試正式歌名、其他別名或年份；也可以清除分類，搜尋全部內容。", symbol: "magnifyingglass")
                        Button("清除並重新搜尋") { clearSearch() }
                            .buttonStyle(.borderedProminent)
                    } else {
                        ForEach(results) { entry in
                            GEMExplorationRow(entry: entry)
                        }
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: 800)
            .frame(maxWidth: .infinity)
        }
        .background { GEMScreenBackground() }
        .navigationTitle("搜尋")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: "歌曲、節目、年份或關鍵字")
        .scrollDismissesKeyboard(.interactively)
        .autocorrectionDisabled()
    }

    private func clearSearch() {
        query = ""
        selectedKind = nil
    }
}

struct GEMFavoritesView: View {
    @EnvironmentObject private var library: GEMLibrary
    @Environment(\.colorScheme) private var colorScheme
    @State private var selectedKind: GEMEntryKind?

    private let kinds: [GEMEntryKind] = [.event, .release, .track, .program, .stage]
    private var favorites: [GEMEntry] {
        library.favoriteEntries.filter { selectedKind == nil || $0.kind == selectedKind }
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                GEMExploreIntro(eyebrow: "YOUR OWN READING PATH", title: "把喜歡的，留在這裡", message: "收藏故事、作品與舞台，慢慢建立自己的閱讀路徑。收藏儲存在這部裝置，關閉 App 後仍會保留。")

                if library.favoriteEntries.isEmpty {
                    GEMEmptyState(title: "第一個收藏，從好奇開始", message: "探索時點一下心形，就能在這裡重新找到那首歌或那段故事。", symbol: "heart")
                    NavigationLink(value: GEMRoute.timeline) {
                        Label("從成長故事開始", systemImage: "clock")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    NavigationLink(value: GEMRoute.library(.release)) {
                        Label("瀏覽作品與舞台", systemImage: "square.stack")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            GEMFilterChip(title: "全部收藏", isSelected: selectedKind == nil) { selectedKind = nil }
                            ForEach(kinds, id: \.self) { kind in
                                GEMFilterChip(title: kind.title, isSelected: selectedKind == kind) {
                                    selectedKind = kind
                                }
                            }
                        }
                    }
                    Text("\(favorites.count) 件收藏 · 點心形或向左滑動即可取消收藏")
                        .font(GEMFont.body(14))
                        .foregroundStyle(GEMPalette.secondary(for: colorScheme))

                    if favorites.isEmpty {
                        GEMEmptyState(title: "這個分類還沒有收藏", message: "查看其他分類，或從完整作品庫找到想保存的內容。", symbol: "heart")
                        Button("查看全部收藏") { selectedKind = nil }
                            .buttonStyle(.bordered)
                    } else {
                        ForEach(favorites) { entry in
                            GEMExplorationRow(entry: entry)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        library.toggleFavorite(entry.id)
                                    } label: {
                                        Label("取消收藏", systemImage: "heart.slash")
                                    }
                                }
                        }
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: 800)
            .frame(maxWidth: .infinity)
        }
        .swipeActionsContainer()
        .background { GEMScreenBackground() }
        .navigationTitle("我的收藏")
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// A row keeps the detail and favorite controls as two separate hit targets.
struct GEMExplorationRow: View {
    let entry: GEMEntry
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            NavigationLink(value: GEMRoute.entry(entry.id)) {
                GEMEntryRow(entry: entry)
                    .contentShape(Rectangle())
            }
            .buttonStyle(GEMPressStyle())

            GEMFavoriteButton(id: entry.id)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 2)
        .background(GEMPalette.card(for: colorScheme), in: RoundedRectangle(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(GEMPalette.purple.opacity(0.12), lineWidth: 1)
        }
    }
}

/// Shared chrome stays lightweight so long names and accessibility text can wrap.
private struct GEMExploreIntro: View {
    let eyebrow: String
    let title: String
    let message: String

    var body: some View {
        GEMSectionHeading(eyebrow: eyebrow, title: title, description: message)
            .padding(.top, 10)
            .padding(.bottom, 4)
    }
}

