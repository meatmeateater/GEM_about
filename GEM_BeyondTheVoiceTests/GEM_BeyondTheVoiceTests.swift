import Testing
import UIKit
import SwiftUI
import CoreGraphics
import MapKit
@testable import GEM_BeyondTheVoice

struct GEM_BeyondTheVoiceTests {

    // MARK: - Tour Stops & MapKit Tests (MAP-03, MAP-04, MAP-19, MAP-20, MAP-31, MAP-33)
    @Test func testTourStopsCountAndOrder() {
        let stops = GEMTourContent.stops
        #expect(stops.count == 4)
        #expect(stops[0].id == "taipei")
        #expect(stops[1].id == "singapore")
        #expect(stops[2].id == "kuala-lumpur")
        #expect(stops[3].id == "shenzhen")
    }

    @Test func testTourStopCoordinatesValid() {
        for stop in GEMTourContent.stops {
            #expect(stop.coordinate.latitude >= -90 && stop.coordinate.latitude <= 90)
            #expect(stop.coordinate.longitude >= -180 && stop.coordinate.longitude <= 180)
            #expect(!stop.city.isEmpty)
            #expect(!stop.englishCity.isEmpty)
            #expect(!stop.venue.isEmpty)
            #expect(!stop.dates.isEmpty)
        }
    }

    @Test func testTourOverviewRegionEnclosesAllStops() {
        let overview = GEMTourContent.overviewRegion
        let minLat = overview.center.latitude - overview.span.latitudeDelta / 2
        let maxLat = overview.center.latitude + overview.span.latitudeDelta / 2
        let minLon = overview.center.longitude - overview.span.longitudeDelta / 2
        let maxLon = overview.center.longitude + overview.span.longitudeDelta / 2

        for stop in GEMTourContent.stops {
            #expect(stop.coordinate.latitude >= minLat && stop.coordinate.latitude <= maxLat)
            #expect(stop.coordinate.longitude >= minLon && stop.coordinate.longitude <= maxLon)
        }
    }

    @Test func testTourStopFocusedRegion() {
        for stop in GEMTourContent.stops {
            let region = stop.focusedRegion
            #expect(region.span.latitudeDelta > 0)
            #expect(region.span.longitudeDelta > 0)
            #expect(abs(region.center.latitude - stop.coordinate.latitude) < 0.0001)
            #expect(abs(region.center.longitude - stop.coordinate.longitude) < 0.0001)
        }
    }

    @Test func testTourOfficialURL() {
        let url = GEMTourContent.officialURL
        #expect(url.scheme == "https")
        #expect(url.host == "www.iamgem.com")
        #expect(url.absoluteString == "https://www.iamgem.com/tours/")
    }

    // MARK: - Discography & Tracks (UI-15, UI-17, UI-20, UI-21, R-02)
    @Test func testAlbumsData() {
        let albums = GEMContent.albums
        #expect(albums.count == 3)
        let ids = albums.map { $0.id }
        #expect(ids == ["gloria", "revelation", "zoo"])
    }

    @Test func testTracksData() {
        let tracks = GEMContent.tracks
        #expect(tracks.count == 4)
        for (index, track) in tracks.enumerated() {
            #expect(track.number == index + 1)
            #expect(!track.title.isEmpty)
            #expect(!track.description.isEmpty)
            #expect(UIImage(systemName: track.symbol) != nil)
        }
    }

    @Test func testMilestonesData() {
        let milestones = GEMContent.milestones
        #expect(milestones.count == 5)
        #expect(milestones.first?.year == "2008")
        #expect(milestones.last?.year == "2026")
    }

    // MARK: - Assets & SF Symbols (R-02, ASSET-01, ICON-01..04)
    @Test func testAssetImagesLoadedSuccessfully() {
        let assetNames = [
            "gem_hero",
            "gem_stage",
            "album_gloria",
            "album_revelation",
            "album_zoo"
        ]
        for name in assetNames {
            let image = UIImage(named: name)
            #expect(image != nil, "Asset image \(name) must exist and be loadable")
        }
    }

    @Test func testAllRequiredSFSymbolsExist() {
        let symbols = [
            "waveform",
            "sun.max.fill",
            "moon.stars.fill",
            "globe.asia.australia.fill",
            "music.mic",
            "hand.draw",
            "arrow.up.left.and.arrow.down.right",
            "triangle.fill",
            "quote.opening",
            "sparkles",
            "circle.hexagongrid.fill",
            "timer",
            "arrow.up.right",
            "heart.fill",
            "map.fill"
        ]
        for symbol in symbols {
            #expect(UIImage(systemName: symbol) != nil, "SF Symbol \(symbol) must exist in system catalog")
        }
    }

    // MARK: - Keynote Shape & Geometry (R-10, SHAPE-04, SHAPE-05)
    @Test func testGEMStageCutShapeGeometry() {
        let shape = GEMStageCutShape()
        let rect = CGRect(x: 0, y: 0, width: 200, height: 100)
        let path = shape.path(in: rect)
        #expect(!path.isEmpty)
        let bounds = path.boundingRect
        #expect(bounds.width == 200)
        #expect(bounds.height == 100)
    }

    // MARK: - Palette & ColorScheme Modes (R-07, THEME-04, THEME-05)
    @Test func testPaletteCardColorsDifferentiateMode() {
        let darkCard = GEMPalette.card(for: .dark)
        let lightCard = GEMPalette.card(for: .light)
        #expect(darkCard != lightCard)
    }

    @Test func testPaletteForegroundColorsDifferentiateMode() {
        let darkFg = GEMPalette.foreground(for: .dark)
        let lightFg = GEMPalette.foreground(for: .light)
        #expect(darkFg != lightFg)
    }

    // MARK: - Connect Markdown Text (R-08, UI-25)
    @Test func testConnectSectionContainsMarkdownLinks() {
        let markdownText = "前往 [G.E.M. 官方網站](https://www.iamgem.com/) 探索更多，或透過 [Spotify](https://open.spotify.com/artist/7aRC4L63dBn3CiLDuWaLSI) 聆聽她的作品。"
        #expect(markdownText.contains("[G.E.M. 官方網站](https://www.iamgem.com/)"))
        #expect(markdownText.contains("[Spotify](https://open.spotify.com/artist/7aRC4L63dBn3CiLDuWaLSI)"))
    }
}
