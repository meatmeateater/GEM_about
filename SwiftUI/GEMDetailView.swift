import SwiftUI

struct GEMDetailView: View {
    let id: String

    @EnvironmentObject private var library: GEMLibrary
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.openURL) private var openURL

    var body: some View {
        Group {
            if let entry = library.entry(id: id) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 26) {
                        hero(entry)
                        if entry.kind == .release || entry.kind == .track {
                            GEMStreamingPlatformSection(entry: entry)
                        }
                        if !entry.metadata.isEmpty { metadata(entry) }
                        story(entry)
                        if !entry.editorial.isEmpty { editorial(entry) }
                        if !entry.tracks.isEmpty { trackList(entry) }
                        if !entry.versions.isEmpty { recordingVersions(entry) }
                        if !entry.links.isEmpty { officialLinks(entry) }
                        if !entry.relatedIDs.isEmpty { relatedEntries(entry) }
                        if entry.kind == .event { chronology(entry) }
                        sources(entry)
                    }
                    .padding(20)
                    .frame(maxWidth: 800)
                    .frame(maxWidth: .infinity)
                }
                .navigationTitle(entry.kind.title)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        GEMFavoriteButton(id: entry.id)
                    }
                }
            } else {
                ScrollView {
                    VStack(spacing: 24) {
                        GEMEmptyState(title: "找不到這份檔案", message: "這筆內容可能已在更新時調整，請回到時間線或作品庫繼續探索。", symbol: "doc.questionmark")
                        NavigationLink(value: GEMRoute.timeline) {
                            Label("探索成長故事", systemImage: "clock")
                        }
                        .buttonStyle(.borderedProminent)
                        NavigationLink(value: GEMRoute.library(.release)) {
                            Label("瀏覽作品庫", systemImage: "square.stack")
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(24)
                    .frame(maxWidth: 800)
                    .frame(maxWidth: .infinity)
                }
                .navigationTitle("內容檔案")
            }
        }
        .background { GEMScreenBackground() }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func hero(_ entry: GEMEntry) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            if entry.kind == .release || entry.kind == .track || entry.imageAsset != nil || entry.artworkURL != nil {
                GEMArtwork(entry: entry)
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: 360)
                    .frame(maxWidth: .infinity)
                    .accessibilityLabel("\(entry.title)的作品視覺")
            }

            Label(entry.category + " · " + entry.dateLabel, systemImage: entry.kind.symbol)
                .font(GEMFont.body(14))
                .foregroundStyle(GEMPalette.purple)
                .fixedSize(horizontal: false, vertical: true)

            Text(entry.title)
                .font(GEMFont.headline(32))
                .foregroundStyle(GEMPalette.foreground(for: colorScheme))
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityAddTraits(.isHeader)

            if !entry.subtitle.isEmpty {
                Text(entry.subtitle)
                    .font(GEMFont.body(16))
                    .foregroundStyle(GEMPalette.secondary(for: colorScheme))
                    .fixedSize(horizontal: false, vertical: true)
            }

            Text(entry.summary)
                .font(GEMFont.body(18))
                .foregroundStyle(GEMPalette.foreground(for: colorScheme))
                .lineSpacing(7)
                .fixedSize(horizontal: false, vertical: true)
                .textSelection(.enabled)
        }
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func metadata(_ entry: GEMEntry) -> some View {
        GEMDetailSection(title: "檔案資訊", symbol: "info.circle") {
            VStack(alignment: .leading, spacing: 18) {
                ForEach(entry.metadata) { fact in
                    VStack(alignment: .leading, spacing: 5) {
                        Text(fact.label)
                            .font(GEMFont.body(13))
                            .foregroundStyle(GEMPalette.secondary(for: colorScheme))
                        Text(fact.value)
                            .font(GEMFont.headline(16))
                            .foregroundStyle(GEMPalette.foreground(for: colorScheme))
                            .fixedSize(horizontal: false, vertical: true)
                            .textSelection(.enabled)
                    }
                    .accessibilityElement(children: .combine)
                }
            }
        }
    }

    private func story(_ entry: GEMEntry) -> some View {
        GEMDetailSection(title: storyTitle(for: entry.kind), symbol: entry.kind.symbol) {
            if entry.paragraphs.isEmpty {
                GEMDetailParagraph(text: entry.summary)
            } else {
                ForEach(Array(entry.paragraphs.enumerated()), id: \.offset) { _, paragraph in
                    GEMDetailParagraph(text: paragraph)
                }
            }
        }
    }

    private func editorial(_ entry: GEMEntry) -> some View {
        GEMDetailSection(title: "編輯導讀", symbol: "text.book.closed") {
            GEMDetailParagraph(text: entry.editorial)
            Text("這是編輯的閱讀角度；可查證的經歷與作品資訊請參閱本頁來源。")
                .font(GEMFont.body(13))
                .foregroundStyle(GEMPalette.secondary(for: colorScheme))
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func trackList(_ entry: GEMEntry) -> some View {
        GEMDetailSection(title: entry.kind == .release ? "曲目" : "相關曲目", symbol: "list.number") {
            Text("有「歌曲檔案」入口的曲目，可以點開閱讀背景與其他版本；亦可點擊「串流」直接前往音樂平台播放。")
                .font(GEMFont.body(13))
                .foregroundStyle(GEMPalette.secondary(for: colorScheme))
                .fixedSize(horizontal: false, vertical: true)

            ForEach(entry.tracks) { track in
                if let targetID = track.entryID, library.entry(id: targetID) != nil {
                    trackRow(track, navigable: true, albumTitle: entry.title)
                } else {
                    trackRow(track, navigable: false, albumTitle: entry.title)
                }
                if track.id != entry.tracks.last?.id { Divider() }
            }
        }
    }

    private func trackRow(_ track: GEMTrackListing, navigable: Bool, albumTitle: String) -> some View {
        HStack(alignment: .center, spacing: 12) {
            Text(String(format: "%02d", track.number))
                .font(GEMFont.display(14))
                .foregroundStyle(GEMPalette.purple)
                .frame(minWidth: 26, alignment: .leading)

            if navigable, let targetID = track.entryID {
                NavigationLink(value: GEMRoute.entry(targetID)) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(track.title)
                            .font(GEMFont.headline(16))
                            .foregroundStyle(GEMPalette.foreground(for: colorScheme))
                            .fixedSize(horizontal: false, vertical: true)
                        Text("歌曲檔案")
                            .font(GEMFont.body(12))
                            .foregroundStyle(GEMPalette.purple)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("第 \(track.number) 首，\(track.title)，查看歌曲檔案")
            } else {
                VStack(alignment: .leading, spacing: 3) {
                    Text(track.title)
                        .font(GEMFont.headline(16))
                        .foregroundStyle(GEMPalette.foreground(for: colorScheme))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer(minLength: 4)

            Menu {
                ForEach(GEMStreamingPlatform.allCases) { platform in
                    if let url = trackStreamingURL(for: track, platform: platform, albumTitle: albumTitle) {
                        Button {
                            openURL(url) { _ in }
                        } label: {
                            Label("在 \(platform.rawValue) 播放", systemImage: platform.symbol)
                        }
                    }
                }
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "headphones")
                        .font(.system(size: 11, weight: .semibold))
                    Text("串流")
                        .font(GEMFont.headline(12))
                }
                .foregroundStyle(GEMPalette.purple)
                .padding(.horizontal, 9)
                .padding(.vertical, 6)
                .background(GEMPalette.purple.opacity(0.12), in: Capsule())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("在串流平台聆聽 \(track.title)")

            if navigable {
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(GEMPalette.purple)
                    .accessibilityHidden(true)
            }
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }

    private func trackStreamingURL(for track: GEMTrackListing, platform: GEMStreamingPlatform, albumTitle: String) -> URL? {
        if let targetID = track.entryID, let entry = library.entry(id: targetID), let url = entry.streamingURL(for: platform) {
            return url
        }
        return track.streamingURL(for: platform, albumTitle: albumTitle)
    }

    private func recordingVersions(_ entry: GEMEntry) -> some View {
        GEMDetailSection(title: "同一首歌，不同時期", symbol: "square.on.square") {
            Text("對照發行時間與版本背景，或前往各版本的官方入口與串流平台聆聽。")
                .font(GEMFont.body(14))
                .foregroundStyle(GEMPalette.secondary(for: colorScheme))
                .fixedSize(horizontal: false, vertical: true)

            ForEach(entry.versions) { version in
                VStack(alignment: .leading, spacing: 14) {
                    Text(version.date.displayText)
                        .font(GEMFont.display(16))
                        .foregroundStyle(GEMPalette.purple)
                    Text(version.title)
                        .font(GEMFont.headline(19))
                        .foregroundStyle(GEMPalette.foreground(for: colorScheme))
                        .fixedSize(horizontal: false, vertical: true)
                        .accessibilityAddTraits(.isHeader)
                    GEMDetailParagraph(text: version.note)

                    // Version streaming platform links
                    VStack(alignment: .leading, spacing: 6) {
                        Text("此版本串流聆聽：")
                            .font(GEMFont.body(12))
                            .foregroundStyle(GEMPalette.secondary(for: colorScheme))
                        HStack(spacing: 8) {
                            ForEach(GEMStreamingPlatform.allCases) { platform in
                                if let url = platform.searchURL(for: "G.E.M. 鄧紫棋 \(version.title)") {
                                    Button {
                                        openURL(url) { _ in }
                                    } label: {
                                        HStack(spacing: 4) {
                                            Image(systemName: platform.symbol)
                                                .font(.system(size: 11))
                                            Text(platform.rawValue)
                                                .font(GEMFont.body(11))
                                        }
                                        .foregroundStyle(GEMPalette.purple)
                                        .padding(.horizontal, 9)
                                        .padding(.vertical, 5)
                                        .background(GEMPalette.purple.opacity(0.1), in: Capsule())
                                    }
                                    .buttonStyle(.plain)
                                    .accessibilityLabel("在 \(platform.rawValue) 聆聽 \(version.title)")
                                }
                            }
                        }
                    }

                    if let releaseID = version.releaseID, let release = library.entry(id: releaseID) {
                        NavigationLink(value: GEMRoute.entry(releaseID)) {
                            Label("收錄作品：\(release.title)", systemImage: "opticaldisc")
                                .font(GEMFont.body(15))
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(GEMPalette.purple)
                    }

                    ForEach(version.links) { link in
                        GEMExternalLink(link: link)
                    }
                    if !version.sourceIDs.isEmpty {
                        DisclosureGroup("這個版本的資料來源") {
                            GEMSourceList(sourceIDs: version.sourceIDs)
                                .padding(.top, 10)
                        }
                        .font(GEMFont.body(14))
                        .tint(GEMPalette.purple)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(GEMPalette.purple.opacity(0.07), in: RoundedRectangle(cornerRadius: 18))
            }
        }
    }

    private func officialLinks(_ entry: GEMEntry) -> some View {
        GEMDetailSection(title: entry.kind == .program || entry.kind == .stage ? "官方觀看入口" : "官方聆聽與作品入口", symbol: "arrow.up.right.square") {
            ForEach(entry.links) { link in
                GEMExternalLink(link: link)
            }
            Text("將開啟外部官方頁面；可播放內容依平台、地區與會員狀態而異。")
                .font(GEMFont.body(13))
                .foregroundStyle(GEMPalette.secondary(for: colorScheme))
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func relatedEntries(_ entry: GEMEntry) -> some View {
        let related = entry.relatedIDs.compactMap { library.entry(id: $0) }.filter { $0.id != entry.id }
        return Group {
            if !related.isEmpty {
                VStack(alignment: .leading, spacing: 16) {
                    Text(relatedTitle(for: entry.kind))
                        .font(GEMFont.headline(22))
                        .foregroundStyle(GEMPalette.foreground(for: colorScheme))
                        .accessibilityAddTraits(.isHeader)
                    ForEach(related) { item in
                        GEMExplorationRow(entry: item)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func chronology(_ entry: GEMEntry) -> some View {
        let events = library.filteredEvents(category: nil, era: nil)
        if let current = events.firstIndex(where: { $0.id == entry.id }) {
            GEMDetailSection(title: "沿著時間繼續走", symbol: "arrow.left.arrow.right") {
                if current > events.startIndex {
                    chronologyLink(events[events.index(before: current)], direction: "上一件故事", symbol: "arrow.left")
                }
                if current < events.index(before: events.endIndex) {
                    chronologyLink(events[events.index(after: current)], direction: "下一件故事", symbol: "arrow.right")
                }
                NavigationLink(value: GEMRoute.timeline) {
                    Label("查看完整成長時間線", systemImage: "clock")
                        .font(GEMFont.body(15))
                        .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                }
                .buttonStyle(.plain)
                .foregroundStyle(GEMPalette.purple)
            }
        }
    }

    private func chronologyLink(_ entry: GEMEntry, direction: String, symbol: String) -> some View {
        NavigationLink(value: GEMRoute.entry(entry.id)) {
            VStack(alignment: .leading, spacing: 6) {
                Label(direction + " · " + entry.dateLabel, systemImage: symbol)
                    .font(GEMFont.body(13))
                    .foregroundStyle(GEMPalette.purple)
                Text(entry.title)
                    .font(GEMFont.headline(17))
                    .foregroundStyle(GEMPalette.foreground(for: colorScheme))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func sources(_ entry: GEMEntry) -> some View {
        GEMDetailSection(title: "資料來源", symbol: "link") {
            if entry.sourceIDs.isEmpty {
                Text("這份檔案目前沒有可開啟的來源。")
                    .font(GEMFont.body(14))
                    .foregroundStyle(GEMPalette.secondary(for: colorScheme))
            } else {
                GEMSourceList(sourceIDs: entry.sourceIDs)
            }
            NavigationLink(value: GEMRoute.sources) {
                Label("內容範圍與素材署名", systemImage: "info.circle")
                    .font(GEMFont.body(14))
                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
            }
            .buttonStyle(.plain)
            .foregroundStyle(GEMPalette.purple)
        }
    }

    private func storyTitle(for kind: GEMEntryKind) -> String {
        switch kind {
        case .event: return "這個時刻發生了什麼"
        case .release: return "走進這張作品"
        case .track: return "關於這首歌"
        case .program: return "節目與參與角色"
        case .stage: return "舞台紀錄"
        }
    }

    private func relatedTitle(for kind: GEMEntryKind) -> String {
        switch kind {
        case .event: return "這段故事，還連著⋯"
        case .release: return "作品背後的故事與舞台"
        case .track: return "回到作品，走向舞台"
        case .program: return "從節目走進歌曲"
        case .stage: return "從舞台回到歌曲"
        }
    }
}

private struct GEMDetailSection<Content: View>: View {
    let title: String
    let symbol: String
    let content: Content

    init(title: String, symbol: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.symbol = symbol
        self.content = content()
    }

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Label(title, systemImage: symbol)
                .font(GEMFont.headline(19))
                .foregroundStyle(GEMPalette.foreground(for: colorScheme))
                .accessibilityAddTraits(.isHeader)
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(GEMPalette.card(for: colorScheme), in: RoundedRectangle(cornerRadius: 24))
        .overlay {
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(GEMPalette.purple.opacity(0.14), lineWidth: 1)
        }
    }
}

private struct GEMDetailParagraph: View {
    let text: String
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Text(text)
            .font(GEMFont.body(16))
            .foregroundStyle(GEMPalette.foreground(for: colorScheme))
            .lineSpacing(7)
            .fixedSize(horizontal: false, vertical: true)
            .textSelection(.enabled)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
