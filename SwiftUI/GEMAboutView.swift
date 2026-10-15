import SwiftUI

struct GEMAboutView: View {
    @AppStorage("gemUsesDarkMode") private var usesDarkMode = true
    @EnvironmentObject private var library: GEMLibrary
    @Environment(\.colorScheme) private var scheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var path: [GEMRoute] = []

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
                                GEMIntroSection().id("artist")
                                GEMJourneySection().id("journey")
                                GEMDiscographySection().id("music")
                                GEMTracksSection()
                                GEMStageSection().id("stage")
                                GEMTourMapSection().id("tour")
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
                    Text("G.E.M. / ABOUT").font(GEMFont.display(12)).tracking(1.1)
                        .foregroundStyle(GEMPalette.foreground(for: scheme)).accessibilityAddTraits(.isHeader)
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

    private func chapterBar(proxy: ScrollViewProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach([("artist", "人物"), ("journey", "成長"), ("music", "作品"), ("stage", "舞台"), ("tour", "巡演")], id: \.0) { section in
                    Button {
                        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.35)) {
                            proxy.scrollTo(section.0, anchor: .top)
                        }
                    } label: {
                        Text(section.1).font(GEMFont.body(14)).padding(.horizontal, 17).frame(minHeight: 44)
                    }.buttonStyle(.plain).foregroundStyle(GEMPalette.foreground(for: scheme))
                }
            }.padding(.horizontal, 12)
        }
        .padding(.vertical, 4).glassEffect(.regular, in: Capsule())
        .padding(.horizontal, 10).padding(.bottom, 8)
        .accessibilityElement(children: .contain).accessibilityLabel("章節導覽")
    }
}

#Preview {
    GEMAboutView().environmentObject(GEMLibrary())
}
