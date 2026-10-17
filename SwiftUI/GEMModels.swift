import Foundation

enum GEMEntryKind: String, Codable, CaseIterable, Identifiable, Hashable {
    case event, release, track, program, stage
    var id: String { rawValue }
    var title: String {
        switch self {
        case .event: return "成長故事"
        case .release: return "專輯與 EP"
        case .track: return "歌曲"
        case .program: return "節目"
        case .stage: return "重要舞台"
        }
    }
    var symbol: String {
        switch self {
        case .event: return "point.topleft.down.to.point.bottomright.curvepath"
        case .release: return "opticaldisc"
        case .track: return "music.note"
        case .program: return "tv"
        case .stage: return "music.mic"
        }
    }
}

struct GEMDate: Codable, Hashable {
    let year: Int
    var month: Int? = nil
    var day: Int? = nil
    var sortKey: Int { year * 10_000 + (month ?? 0) * 100 + (day ?? 0) }
    var decade: Int { year / 10 * 10 }
    var displayText: String {
        guard let month = month else { return "\(year)" }
        guard let day = day else { return "\(year) 年 \(month) 月" }
        return "\(year) 年 \(month) 月 \(day) 日"
    }
}

struct GEMLink: Codable, Hashable, Identifiable {
    let label: String
    let url: String
    var id: String { label + "|" + url }
    var destination: URL? { GEMURL.https(url) }
}

enum GEMURL {
    static func https(_ value: String) -> URL? {
        guard let url = URL(string: value), url.scheme?.lowercased() == "https",
              let host = url.host, !host.isEmpty else { return nil }
        return url
    }
}

struct GEMSource: Codable, Hashable, Identifiable {
    let id: String
    let title: String
    let publisher: String
    let url: String
    let verifiedAt: String
    let scope: String
    var destination: URL? { GEMURL.https(url) }
}

struct GEMMetadata: Codable, Hashable, Identifiable {
    let label: String
    let value: String
    var id: String { label + "|" + value }
}

struct GEMTrackListing: Codable, Hashable, Identifiable {
    let number: Int
    let title: String
    var entryID: String? = nil
    var id: Int { number }
}

struct GEMRecordingVersion: Codable, Hashable, Identifiable {
    let id: String
    let title: String
    let date: GEMDate
    var releaseID: String? = nil
    let note: String
    let links: [GEMLink]
    let sourceIDs: [String]
}

struct GEMEntry: Codable, Identifiable, Hashable {
    let id: String
    let kind: GEMEntryKind
    let title: String
    let subtitle: String
    let date: GEMDate
    let category: String
    let summary: String
    let paragraphs: [String]
    let editorial: String
    let tags: [String]
    let relatedIDs: [String]
    let sourceIDs: [String]
    let imageAsset: String?
    let artworkURL: String?
    let metadata: [GEMMetadata]
    let tracks: [GEMTrackListing]
    let versions: [GEMRecordingVersion]
    let links: [GEMLink]

    var year: Int { date.year }
    var dateLabel: String { date.displayText }
    var searchText: String {
        ([title, subtitle, summary, editorial, category, String(year)] + tags +
         paragraphs + tracks.map(\.title) + metadata.map(\.value))
            .joined(separator: " ").gemSearchNormalized
    }

    enum CodingKeys: String, CodingKey {
        case id, kind, title, subtitle, date, category, summary, paragraphs, editorial,
             tags, relatedIDs, sourceIDs, imageAsset, artworkURL, metadata, tracks, versions, links
    }

    init(from decoder: Decoder) throws {
        let v = try decoder.container(keyedBy: CodingKeys.self)
        id = try v.decode(String.self, forKey: .id)
        kind = try v.decode(GEMEntryKind.self, forKey: .kind)
        title = try v.decode(String.self, forKey: .title)
        date = try v.decode(GEMDate.self, forKey: .date)
        category = try v.decode(String.self, forKey: .category)
        summary = try v.decode(String.self, forKey: .summary)
        paragraphs = try v.decode([String].self, forKey: .paragraphs)
        subtitle = try v.decodeIfPresent(String.self, forKey: .subtitle) ?? ""
        editorial = try v.decodeIfPresent(String.self, forKey: .editorial) ?? ""
        tags = try v.decodeIfPresent([String].self, forKey: .tags) ?? []
        relatedIDs = try v.decodeIfPresent([String].self, forKey: .relatedIDs) ?? []
        sourceIDs = try v.decodeIfPresent([String].self, forKey: .sourceIDs) ?? []
        imageAsset = try v.decodeIfPresent(String.self, forKey: .imageAsset)
        artworkURL = try v.decodeIfPresent(String.self, forKey: .artworkURL)
        metadata = try v.decodeIfPresent([GEMMetadata].self, forKey: .metadata) ?? []
        tracks = try v.decodeIfPresent([GEMTrackListing].self, forKey: .tracks) ?? []
        versions = try v.decodeIfPresent([GEMRecordingVersion].self, forKey: .versions) ?? []
        links = try v.decodeIfPresent([GEMLink].self, forKey: .links) ?? []
    }
}

struct GEMCatalog: Codable {
    let schemaVersion: Int
    let updatedAt: String
    let entries: [GEMEntry]
    let sources: [GEMSource]
    static let empty = GEMCatalog(schemaVersion: 1, updatedAt: "", entries: [], sources: [])

    static func load(bundle: Bundle = .main) throws -> GEMCatalog {
        guard let url = bundle.url(forResource: "gem-catalog", withExtension: "json") else {
            throw GEMCatalogError.missingResource
        }
        let catalog = try JSONDecoder().decode(GEMCatalog.self, from: Data(contentsOf: url))
        try catalog.validate()
        return catalog
    }

    func validate() throws {
        let ids = Set(entries.map(\.id))
        let sourceIDs = Set(sources.map(\.id))
        guard schemaVersion == 1, ids.count == entries.count,
              sourceIDs.count == sources.count else { throw GEMCatalogError.invalidCatalog }
        for item in entries {
            let related = item.relatedIDs + item.tracks.compactMap(\.entryID) + item.versions.compactMap(\.releaseID)
            let referenced = item.sourceIDs + item.versions.flatMap(\.sourceIDs)
            guard !item.title.isEmpty, !item.paragraphs.isEmpty, !item.sourceIDs.isEmpty,
                  related.allSatisfy({ ids.contains($0) }),
                  referenced.allSatisfy({ sourceIDs.contains($0) }) else {
                throw GEMCatalogError.invalidCatalog
            }
        }
    }
}

enum GEMCatalogError: Error { case missingResource, invalidCatalog }

struct GEMMediaCredit: Codable, Identifiable {
    let id: String
    let assetName: String
    let title: String
    let author: String
    let sourceURL: String
    let license: String
    let licenseURL: String?
    let modifications: String
}

enum GEMRoute: Hashable {
    case timeline, library(GEMEntryKind), search, favorites, entry(String), sources
}

extension String {
    var gemSearchNormalized: String {
        let traditional = applyingTransform(StringTransform(rawValue: "Simplified-Traditional"), reverse: false) ?? self
        return traditional.folding(options: [.caseInsensitive, .diacriticInsensitive, .widthInsensitive],
                                   locale: Locale(identifier: "zh_TW"))
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

enum GEMStreamingPlatform: String, CaseIterable, Identifiable {
    case appleMusic = "Apple Music"
    case spotify = "Spotify"
    case youtubeMusic = "YouTube Music"

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .appleMusic: return "music.note"
        case .spotify: return "play.circle.fill"
        case .youtubeMusic: return "play.rectangle.fill"
        }
    }

    func searchURL(for query: String) -> URL? {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let encoded = trimmed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        let urlString: String
        switch self {
        case .appleMusic:
            urlString = "https://music.apple.com/us/search?term=\(encoded)"
        case .spotify:
            urlString = "https://open.spotify.com/search/\(encoded)"
        case .youtubeMusic:
            urlString = "https://music.youtube.com/search?q=\(encoded)"
        }
        return GEMURL.https(urlString)
    }
}

extension GEMEntry {
    func streamingURL(for platform: GEMStreamingPlatform) -> URL? {
        for link in links {
            guard let url = link.destination else { continue }
            let host = url.host?.lowercased() ?? ""
            switch platform {
            case .appleMusic:
                if host.contains("music.apple.com") { return url }
            case .spotify:
                if host.contains("spotify.com") { return url }
            case .youtubeMusic:
                if host.contains("youtube.com") { return url }
            }
        }
        return platform.searchURL(for: "G.E.M. 鄧紫棋 \(title)")
    }
}

extension GEMTrackListing {
    func streamingURL(for platform: GEMStreamingPlatform, albumTitle: String? = nil) -> URL? {
        let query: String
        if let album = albumTitle, !album.isEmpty {
            query = "G.E.M. 鄧紫棋 \(title) \(album)"
        } else {
            query = "G.E.M. 鄧紫棋 \(title)"
        }
        return platform.searchURL(for: query)
    }
}
