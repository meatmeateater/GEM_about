import SwiftUI

struct GEMAboutView: View {
    @AppStorage("gemUsesDarkMode") private var usesDarkMode = true
    @EnvironmentObject private var library: GEMLibrary
    @Environment(\.colorScheme) private var scheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var path: [GEMRoute] = []
    @State private var activeSection: String = "artist"
    @State private var sectionOffsets: [String: CGFloat] = [:]

    private let orderedSections = [
        ("artist", "人物"),
        ("journey", "成長"),
        ("music", "作品"),
        ("stage", "舞台"),
        ("tour", "巡演")
    ]

    var body: some View {
        NavigationStack(path: $path) {
            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    VStack(spacing: 0) {
                        GEMHeroView()
                        VStack(alignment: .leading, spacing: 46) {
                            if let error = library.loadError {
                                GEMEmptyState(title: "內容暫時無法載入", message: error, symbol: "exclamationmark.circle")
                            } else {
                                GEMIntroSection()
                                    .id("artist")
                                    .onGeometryChange(for: CGFloat.self) { proxy in
                                        proxy.frame(in: .global).minY
                                    } action: { updateSection("artist", minY: $0) }

                                GEMJourneySection()
                                    .id("journey")
                                    .onGeometryChange(for: CGFloat.self) { proxy in
                                        proxy.frame(in: .global).minY
                                    } action: { updateSection("journey", minY: $0) }

                                GEMDiscographySection()
                                    .id("music")
                                    .onGeometryChange(for: CGFloat.self) { proxy in
                                        proxy.frame(in: .global).minY
                                    } action: { updateSection("music", minY: $0) }

                                GEMTracksSection()

                                GEMStageSection()
                                    .id("stage")
                                    .onGeometryChange(for: CGFloat.self) { proxy in
                                        proxy.frame(in: .global).minY
                                    } action: { updateSection("stage", minY: $0) }

                                GEMTourMapSection()
                                    .id("tour")
                                    .onGeometryChange(for: CGFloat.self) { proxy in
                                        proxy.frame(in: .global).minY
                                    } action: { updateSection("tour", minY: $0) }

                                GEMHomeFavoritesSection()
                                GEMConnectSection()
                            }
                        }
                        .padding(.horizontal, 22).padding(.top, 12).padding(.bottom, 44)
                    }.frame(maxWidth: 780).frame(maxWidth: .infinity)
                }
                .background { GEMScreenBackground() }
                .safeAreaInset(edge: .top, spacing: 0) { chapterBar(proxy: proxy) }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("G.E.M. / ABOUT")
                        .font(GEMFont.display(12))
                        .tracking(1.1)
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                        .foregroundStyle(GEMPalette.foreground(for: scheme))
                        .accessibilityAddTraits(.isHeader)
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    NavigationLink(value: GEMRoute.search) {
                        Image(systemName: "magnifyingglass").frame(minWidth: 36, minHeight: 44)
                    }.accessibilityLabel("搜尋故事、作品與舞台")
                    NavigationLink(value: GEMRoute.favorites) {
                        Image(systemName: "heart").frame(minWidth: 36, minHeight: 44)
                    }.accessibilityLabel("我的收藏")
                    Button {
                        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.2)) { usesDarkMode.toggle() }
                    } label: {
                        Image(systemName: usesDarkMode ? "sun.max" : "moon.stars")
                            .frame(minWidth: 36, minHeight: 44)
                    }.accessibilityLabel(usesDarkMode ? "切換為一般模式" : "切換為深色模式")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: GEMRoute.self) { route in
                switch route {
                case .timeline: GEMTimelineView()
                case .library(let kind): GEMLibraryView(initialKind: kind)
                case .search: GEMSearchView()
                case .favorites: GEMFavoritesView()
                case .entry(let id): GEMDetailView(id: id)
                case .sources: GEMSourcesView()
                }
            }
        }
        .tint(GEMPalette.purple)
        .preferredColorScheme(usesDarkMode ? .dark : .light)
    }

    private func updateSection(_ id: String, minY: CGFloat) {
        sectionOffsets[id] = minY
        let threshold: CGFloat = 260
        var current = orderedSections.first?.0 ?? "artist"
        for section in orderedSections {
            if let y = sectionOffsets[section.0], y <= threshold {
                current = section.0
            }
        }
        if activeSection != current {
            withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.2)) {
                activeSection = current
            }
        }
    }

    private func chapterBar(proxy: ScrollViewProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                ForEach(orderedSections, id: \.0) { section in
                    let isCurrent = activeSection == section.0
                    Button {
                        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.35)) {
                            activeSection = section.0
                            proxy.scrollTo(section.0, anchor: .top)
                        }
                    } label: {
                        Text(section.1)
                            .font(isCurrent ? GEMFont.headline(14) : GEMFont.body(14))
                            .foregroundStyle(isCurrent
                                ? (scheme == .dark ? Color.white : GEMPalette.purple)
                                : GEMPalette.foreground(for: scheme).opacity(0.62))
                            .padding(.horizontal, 16)
                            .frame(minHeight: 38)
                            .background {
                                if isCurrent {
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(scheme == .dark
                                            ? Color.white.opacity(0.20)
                                            : GEMPalette.purple.opacity(0.14))
                                        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                                }
                            }
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(isCurrent ? .isSelected : [])
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
        }
        .padding(.vertical, 4)
        .glassEffect(.regular, in: Capsule())
        .padding(.horizontal, 10)
        .padding(.bottom, 8)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("章節導覽")
    }
}

#Preview {
    GEMAboutView().environmentObject(GEMLibrary())
}
