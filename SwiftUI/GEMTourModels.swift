import Foundation
import MapKit

/// Verified tour stops listed on the official G.E.M. tour page.
/// Coordinates identify the venue (not an arbitrary city-centre pin).
struct GEMTourStop: Identifiable {
    let id: String
    let city: String
    let englishCity: String
    let region: String
    let dates: String
    let venue: String
    let caption: String
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var focusedRegion: MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.14, longitudeDelta: 0.20)
        )
    }
}

enum GEMTourContent {
    static let officialURL = URL(string: "https://www.iamgem.com/tours/")!

    /// Framing that keeps all four Asian tour stops on the starting map.
    static var overviewRegion: MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 14.7, longitude: 111.4),
            span: MKCoordinateSpan(latitudeDelta: 31.0, longitudeDelta: 30.0)
        )
    }

    static let stops: [GEMTourStop] = [
        GEMTourStop(
            id: "taipei",
            city: "台北",
            englishCity: "TAIPEI",
            region: "TAIWAN",
            dates: "2026.04.09 — 04.12",
            venue: "臺北大巨蛋",
            caption: "從歌聲到全場共鳴，寫下屬於台北的 GLORIA 記憶。",
            latitude: 25.04239,
            longitude: 121.55958
        ),
        GEMTourStop(
            id: "singapore",
            city: "新加坡",
            englishCity: "SINGAPORE",
            region: "SINGAPORE",
            dates: "2026.05.23",
            venue: "Singapore National Stadium",
            caption: "在獅城的夜色裡，讓每一道聲音匯成光。",
            latitude: 1.30444,
            longitude: 103.87417
        ),
        GEMTourStop(
            id: "kuala-lumpur",
            city: "吉隆坡",
            englishCity: "KUALA LUMPUR",
            region: "MALAYSIA",
            dates: "2026.06.06",
            venue: "National Stadium Bukit Jalil",
            caption: "當萬人合唱響起，舞台與城市之間再沒有距離。",
            latitude: 3.05468,
            longitude: 101.69137
        ),
        GEMTourStop(
            id: "shenzhen",
            city: "深圳",
            englishCity: "SHENZHEN",
            region: "CHINA",
            dates: "2026.10.01–02 · 10.04–05",
            venue: "深圳大運中心體育場",
            caption: "以音樂串連更多相遇，延續 GLORIA 的旅程。",
            latitude: 22.69703,
            longitude: 114.21234
        )
    ]
}
