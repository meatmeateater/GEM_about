import Foundation

struct GEMAlbum: Identifiable {
    let id: String
    let title: String
    let description: String
    let year: String
    let assetName: String
}

struct GEMTrack: Identifiable {
    let number: Int
    let title: String
    let description: String
    let symbol: String

    var id: Int { number }
}

enum GEMContent {
    static let albums: [GEMAlbum] = [
        GEMAlbum(
            id: "gloria",
            title: "I AM GLORIA",
            description: "經典作品，以新的聲音再次綻放",
            year: "2025",
            assetName: "album_gloria"
        ),
        GEMAlbum(
            id: "revelation",
            title: "啟示錄",
            description: "以音樂編織的長篇故事",
            year: "2022",
            assetName: "album_revelation"
        ),
        GEMAlbum(
            id: "zoo",
            title: "摩天動物園",
            description: "觀察世界，也凝視內心",
            year: "2019",
            assetName: "album_zoo"
        )
    ]

    static let tracks: [GEMTrack] = [
        GEMTrack(number: 1, title: "光年之外", description: "BEYOND THE LIGHT YEARS", symbol: "sparkles"),
        GEMTrack(number: 2, title: "泡沫", description: "BUBBLE", symbol: "circle.hexagongrid.fill"),
        GEMTrack(number: 3, title: "倒數", description: "TIK TOK", symbol: "timer"),
        GEMTrack(number: 4, title: "天空沒有極限", description: "THE SKY'S THE LIMIT", symbol: "moon.stars.fill")
    ]
}

struct GEMMilestone: Identifiable {
    let year: String
    let title: String
    let detail: String
    var id: String { year }
}

extension GEMContent {
    static let milestones: [GEMMilestone] = [
        GEMMilestone(year: "2008", title: "故事開始", detail: "推出首張作品《G.E.M.》，正式展開音樂旅程。"),
        GEMMilestone(year: "2019", title: "摩天動物園", detail: "以音樂觀察世界，寫下新的創作篇章。"),
        GEMMilestone(year: "2022", title: "啟示錄", detail: "將音樂與影像敘事串連成完整作品。"),
        GEMMilestone(year: "2025", title: "I AM GLORIA", detail: "重錄經典歌曲，讓熟悉的旋律呈現全新聲音。"),
        GEMMilestone(year: "2026", title: "自由的你", detail: "推出新創作單曲，延伸關於自我與自由的思考。")
    ]
}
