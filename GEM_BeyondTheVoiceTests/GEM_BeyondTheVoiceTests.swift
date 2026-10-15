import XCTest
import UIKit
import MapKit
@testable import GEM_BeyondTheVoice

final class GEM_BeyondTheVoiceTests: XCTestCase {
    private func fixtureEntry(_ id: String, kind: String = "event", year: Int = 2014,
                              title: String = "成長故事", category: String = "音樂",
                              tags: [String] = [], relatedIDs: [String] = []) -> [String: Any] {
        ["id": id, "kind": kind, "title": title, "subtitle": "",
         "date": ["year": year], "category": category, "summary": "測試內容",
         "paragraphs": ["測試用內容，不是正式藝術家資料。"], "editorial": "",
         "tags": tags, "relatedIDs": relatedIDs, "sourceIDs": ["fixture-source"]]
    }

    private func fixture(_ entries: [[String: Any]]) throws -> GEMCatalog {
        let json: [String: Any] = [
            "schemaVersion": 1, "updatedAt": "2026-10-15", "entries": entries,
            "sources": [["id": "fixture-source", "title": "Fixture", "publisher": "Test",
                         "url": "https://www.iamgem.com/", "verifiedAt": "2026-10-15",
                         "scope": "Synthetic test fixture only"]]
        ]
        return try JSONDecoder().decode(GEMCatalog.self, from: JSONSerialization.data(withJSONObject: json))
    }

    func testBundledCatalogLoadsAndAllReferencesResolve() throws {
        let catalog = try GEMCatalog.load()
        XCTAssertFalse(catalog.entries.isEmpty)
        XCTAssertEqual(Set(catalog.entries.map(\.id)).count, catalog.entries.count)
        XCTAssertEqual(Set(catalog.sources.map(\.id)).count, catalog.sources.count)
        XCTAssertNoThrow(try catalog.validate())
        for kind in GEMEntryKind.allCases {
            XCTAssertTrue(catalog.entries.contains { $0.kind == kind }, "No content for \(kind)")
        }
        let byID = Dictionary(uniqueKeysWithValues: catalog.entries.map { ($0.id, $0) })
        for entry in catalog.entries {
            for track in entry.tracks {
                if let id = track.entryID { XCTAssertEqual(byID[id]?.kind, .track) }
            }
            for version in entry.versions {
                if let id = version.releaseID { XCTAssertEqual(byID[id]?.kind, .release) }
            }
        }
    }

    func testCatalogRejectsDuplicateAndDanglingIDs() throws {
        XCTAssertThrowsError(try fixture([fixtureEntry("same"), fixtureEntry("same")]).validate())
        XCTAssertThrowsError(try fixture([fixtureEntry("valid", relatedIDs: ["missing"])]).validate())
        var wrongSource = fixtureEntry("valid")
        wrongSource["sourceIDs"] = ["missing-source"]
        XCTAssertThrowsError(try fixture([wrongSource]).validate())
    }

    @MainActor
    func testTimelineKeepsSameYearEventsAndCombinesFilters() throws {
        let catalog = try fixture([
            fixtureEntry("2014-b", category: "舞台"),
            fixtureEntry("2014-a"),
            fixtureEntry("2022", year: 2022),
            fixtureEntry("release-2014", kind: "release")
        ])
        let library = GEMLibrary(catalog: catalog)
        XCTAssertEqual(library.filteredEvents().map(\.id), ["2014-a", "2014-b", "2022"])
        XCTAssertEqual(library.filteredEvents(era: 2010).map(\.id), ["2014-a", "2014-b"])
        XCTAssertEqual(library.filteredEvents(category: "舞台", era: 2010).map(\.id), ["2014-b"])
        XCTAssertTrue(library.filteredEvents(category: "舞台", era: 2020).isEmpty)
    }

    @MainActor
    func testSearchNormalizesChineseLatinAndWhitespaceAndFiltersKind() throws {
        let catalog = try fixture([
            fixtureEntry("track", kind: "track", title: "光年之外", tags: ["鄧紫棋", "Café GLORIA"]),
            fixtureEntry("release", kind: "release", title: "GLORIA"),
            fixtureEntry("event", title: "成長故事")
        ])
        let library = GEMLibrary(catalog: catalog)
        XCTAssertEqual(library.search(query: "邓紫棋").map(\.id), ["track"])
        XCTAssertEqual(library.search(query: "  ｃａｆｅ  gloria \n").map(\.id), ["track"])
        XCTAssertEqual(Set(library.search(query: "gloria").map(\.id)), Set(["track", "release"]))
        XCTAssertEqual(library.search(query: "gloria", kind: .release).map(\.id), ["release"])
        XCTAssertTrue(library.search(query: "gloria 不存在").isEmpty)
        XCTAssertEqual(library.search(query: " \n ").count, catalog.entries.count)
    }

    @MainActor
    func testFavoritePersistsAcrossStoreRecreationAndRemoval() throws {
        let suiteName = "GEMTests.\(UUID().uuidString)"
        let defaults = try XCTUnwrap(UserDefaults(suiteName: suiteName))
        defer { defaults.removePersistentDomain(forName: suiteName) }
        let catalog = try fixture([fixtureEntry("a"), fixtureEntry("b", kind: "track")])
        let first = GEMLibrary(catalog: catalog, defaults: defaults, favoritesKey: "favorites")
        first.toggleFavorite("a")
        first.toggleFavorite("b")
        first.toggleFavorite("not-in-catalog")
        XCTAssertEqual(first.favoriteIDs, Set(["a", "b"]))

        let reopened = GEMLibrary(catalog: catalog, defaults: defaults, favoritesKey: "favorites")
        XCTAssertTrue(reopened.isFavorite("a"))
        XCTAssertEqual(Set(reopened.favoriteEntries.map(\.id)), Set(["a", "b"]))
        reopened.toggleFavorite("a")
        let reopenedAgain = GEMLibrary(catalog: catalog, defaults: defaults, favoritesKey: "favorites")
        XCTAssertFalse(reopenedAgain.isFavorite("a"))
        XCTAssertEqual(reopenedAgain.favoriteIDs, Set(["b"]))
    }

    func testDatePrecisionDoesNotInventMonthOrDay() {
        let year = GEMDate(year: 2014)
        let month = GEMDate(year: 2014, month: 5)
        let day = GEMDate(year: 2014, month: 5, day: 24)
        XCTAssertEqual(year.displayText, "2014")
        XCTAssertEqual(month.displayText, "2014 年 5 月")
        XCTAssertEqual(day.displayText, "2014 年 5 月 24 日")
        XCTAssertLessThan(year.sortKey, month.sortKey)
        XCTAssertLessThan(month.sortKey, day.sortKey)
    }

    func testExternalLinksRequireHTTPSHost() {
        XCTAssertNil(GEMURL.https("http://example.com"))
        XCTAssertNil(GEMURL.https("javascript:alert(1)"))
        XCTAssertNil(GEMURL.https("https:///"))
        XCTAssertNotNil(GEMURL.https("https://www.iamgem.com/"))
    }

    @MainActor
    func testRealPhotoAssetsAndRegisteredFontsAreAvailable() throws {
        for name in ["gem_portrait", "gem_live"] {
            XCTAssertNotNil(UIImage(named: name), "Missing bundled photo \(name)")
        }
        for name in ["Sora-ExtraBold", "NotoSansTC-Regular", "NotoSansTC-Bold"] {
            XCTAssertNotNil(UIFont(name: name, size: 18), "Custom font did not register: \(name)")
        }
        let url = try XCTUnwrap(Bundle.main.url(forResource: "media-credits", withExtension: "json"))
        let credits = try JSONDecoder().decode([GEMMediaCredit].self, from: Data(contentsOf: url))
        XCTAssertEqual(Set(credits.map(\.assetName)), Set(["gem_portrait", "gem_live"]))
    }

    func testTourOverviewEnclosesAllCuratedStops() {
        let region = GEMTourContent.overviewRegion
        XCTAssertEqual(Set(GEMTourContent.stops.map(\.id)).count, GEMTourContent.stops.count)
        for stop in GEMTourContent.stops {
            XCTAssertTrue(CLLocationCoordinate2DIsValid(stop.coordinate))
            XCTAssertLessThanOrEqual(abs(stop.coordinate.latitude - region.center.latitude), region.span.latitudeDelta / 2)
            XCTAssertLessThanOrEqual(abs(stop.coordinate.longitude - region.center.longitude), region.span.longitudeDelta / 2)
        }
    }
}
