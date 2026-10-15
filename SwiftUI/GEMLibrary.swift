import Foundation
import Combine

@MainActor
final class GEMLibrary: ObservableObject {
    let catalog: GEMCatalog
    let loadError: String?
    let mediaCredits: [GEMMediaCredit]
    @Published private(set) var favoriteIDs: Set<String>
    private let defaults: UserDefaults
    private let favoritesKey: String
    private let entriesByID: [String: GEMEntry]

    init(catalog: GEMCatalog? = nil, defaults: UserDefaults = .standard,
         favoritesKey: String = "gem.favorites.v2", bundle: Bundle = .main) {
        self.defaults = defaults
        self.favoritesKey = favoritesKey
        let loaded: GEMCatalog
        if let catalog = catalog {
            loaded = catalog
            loadError = nil
        } else {
            do {
                loaded = try GEMCatalog.load(bundle: bundle)
                loadError = nil
            } catch {
                loaded = .empty
                loadError = "內容暫時無法載入，請重新開啟 App。"
                #if DEBUG
                print("GEM catalog could not load: \(error)")
                #endif
            }
        }
        self.catalog = loaded
        entriesByID = Dictionary(loaded.entries.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
        favoriteIDs = Set(defaults.stringArray(forKey: favoritesKey) ?? [])
        if let url = bundle.url(forResource: "media-credits", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let credits = try? JSONDecoder().decode([GEMMediaCredit].self, from: data) {
            mediaCredits = credits
        } else { mediaCredits = [] }
    }

    func entry(id: String) -> GEMEntry? { entriesByID[id] }
    func source(id: String) -> GEMSource? { catalog.sources.first { $0.id == id } }

    func entries(of kind: GEMEntryKind) -> [GEMEntry] {
        catalog.entries.filter { $0.kind == kind }.sorted {
            $0.date.sortKey == $1.date.sortKey ? $0.id < $1.id : $0.date.sortKey > $1.date.sortKey
        }
    }

    func filteredEvents(category: String? = nil, era: Int? = nil) -> [GEMEntry] {
        catalog.entries.filter {
            $0.kind == .event && (category == nil || $0.category == category) &&
            (era == nil || $0.date.decade == era)
        }.sorted {
            $0.date.sortKey == $1.date.sortKey ? $0.id < $1.id : $0.date.sortKey < $1.date.sortKey
        }
    }

    func search(query: String, kind: GEMEntryKind? = nil) -> [GEMEntry] {
        let terms = query.gemSearchNormalized.split(whereSeparator: { $0.isWhitespace }).map(String.init)
        return catalog.entries.filter { item in
            (kind == nil || item.kind == kind) && terms.allSatisfy { item.searchText.contains($0) }
        }.sorted {
            $0.date.sortKey == $1.date.sortKey ? $0.id < $1.id : $0.date.sortKey > $1.date.sortKey
        }
    }

    var favoriteEntries: [GEMEntry] {
        catalog.entries.filter { favoriteIDs.contains($0.id) }.sorted {
            $0.date.sortKey == $1.date.sortKey ? $0.id < $1.id : $0.date.sortKey > $1.date.sortKey
        }
    }

    func isFavorite(_ id: String) -> Bool { favoriteIDs.contains(id) }
    func toggleFavorite(_ id: String) {
        guard entriesByID[id] != nil else { return }
        if favoriteIDs.contains(id) { favoriteIDs.remove(id) } else { favoriteIDs.insert(id) }
        defaults.set(favoriteIDs.sorted(), forKey: favoritesKey)
    }
}
