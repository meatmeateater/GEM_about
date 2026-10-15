# #03 打造吸睛的 About 頁面
## G.E.M. 鄧紫棋 Beyond the Voice · 原創音樂人物誌、作品庫與巡演地圖 App

**Published:** 2026-10-15  
**Tags:** `[GEM]` · `[SwiftUI]` · `[iOS27]` · `[MusicApp]` · `[AboutPage]` · `[AppleMusic]` · `[Spotify]`

---

> ### **成果展示（GIF） — About G.E.M. 鄧紫棋**

<!-- 📷 圖片預留位：App 操作動態展示 GIF -->
![App 操作完整走讀動態展示 GIF](請在此貼上你的GIF圖片連結或檔名_例如_gem_demo.gif)

*▲ 動態展示：從首頁 Hero 瀏覽、頂部導覽列透明方塊指示、時間線篩選、作品專輯跳轉串流、巡演地圖到收藏操作*

---

> ### **成果展示（Screenshot）**

<!-- 📷 圖片預留位：各介面截圖展示區（可放 6~9 張截圖，推薦 3 張一排或橫向並排） -->

| 首頁 Hero 與動態導覽列 | 成長時間線篩選 | 作品庫橫向滾動 |
|:---:|:---:|:---:|
| ![首頁介面截圖](請在此貼上圖片連結_01_Home.png) | ![時間線篩選截圖](請在此貼上圖片連結_02_Timeline.png) | ![作品庫截圖](請在此貼上圖片連結_03_Albums.png) |
| *首頁頂部導覽指示與藝人寫真* | *2010s/2020s 複合年代篩選* | *專輯卡片與即時收藏* |

| 歌曲詳情與串流收聽 | 專輯曲目與串流選單 | 經典錄音版本對照 |
|:---:|:---:|:---:|
| ![歌曲詳情與串流](請在此貼上圖片連結_04_Streaming.png) | ![專輯曲目清單](請在此貼上圖片連結_05_TrackList.png) | ![版本對照介面](請在此貼上圖片連結_06_Versions.png) |
| *Apple Music/Spotify 直達* | *曲目快捷播放選單* | *不同時期錄音版本分析* |

| 巡演互動地圖 | 本地持久化收藏清單 | 深淺色主題對比 (Light / Dark) |
|:---:|:---:|:---:|
| ![巡演地圖介面](請在此貼上圖片連結_07_TourMap.png) | ![收藏頁面截圖](請在此貼上圖片連結_08_Favorites.png) | ![深淺色模式截圖](請在此貼上圖片連結_09_LightDark.png) |
| *MapKit 標記與場館資訊* | *滑動刪除與狀態同步* | *午夜紫與晨曦珍珠白對比* |

---

> ### **專案簡介**

本專案以華語樂壇指標性創作天后 **G.E.M. 鄧紫棋（Gloria Tang）** 為主題，打造一款融合當代極致視覺與全方位內容的 **SwiftUI 旗艦級音樂人物誌與探索 App**。

不同於常見的單頁式靜態展示，本 App 構建了完整的「**事件 → 作品 → 歌曲 → 舞台／版本 → 收藏**」深層探索架構，將藝人生涯歷史、專輯與歌曲資訊、官方串流收聽跳轉、巡演軌跡與來源查證緊密串聯。介面設計採用 iOS 最新 **Liquid Glass（流體玻璃材質）**，搭配深紫色、香檳金的高雅舞台配色，並兼顧 **VoiceOver 無障礙旁白**、**動態字級支援** 與 **減少動態效果（Reduce Motion）**。

---

> ### **GitHub 專案連結**

- **GitHub 專案庫**：[GEM_BeyondTheVoice](https://github.com/example/GEM_BeyondTheVoice)
- **詳細設計與驗收報告**：[Mac / iOS 驗收清單](file:///Users/k/Documents/GEM_about/docs/MAC_ACCEPTANCE.md)
- **資料來源與素材署名**：[素材與授權說明](file:///Users/k/Documents/GEM_about/docs/MEDIA_CREDITS.md)

---

> ### **原作業十項要求對照表**

本專案完整落實並深化了作業要求的十項核心指標：

| # | 作業要求項目 | 本專案實作亮點 | 核心程式碼檔案 |
|---|---|---|---|
| **1** | 基本排版元件（`VStack` / `HStack` / `ZStack` / `Text` / `Image` / `ScrollView`） | 結合垂直流式捲動、橫向卡片列與重疊圖層 | [`GEMHeroView.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMHeroView.swift), [`GEMDetailView.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMDetailView.swift) |
| **2** | Asset 圖片與 SF Symbols | 授權真實肖像、動態圖示效果（Symbol Effects） | `Assets.xcassets`, [`GEMComponents.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMComponents.swift) |
| **3** | 豐富的 View Modifiers | Liquid Glass、階層陰影、幾何圓角與非線性動畫 | [`GEMTheme.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMTheme.swift), [`GEMAboutView.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMAboutView.swift) |
| **4** | 上下滾動 `ScrollView`（含 `ScrollViewReader`） | 雙向連動：滾動時自動標示當前章節、點擊平滑導航 | [`GEMAboutView.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMAboutView.swift), [`GEMSections.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMSections.swift) |
| **5** | 模組化多檔案 View 結構 | 依職責拆分為 14 個獨立 Swift 模組 | `SwiftUI/*.swift` |
| **6** | View Property 客製化與元件封裝 | 可重用的發行卡片、檔案列與串流區塊元件 | [`GEMComponents.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMComponents.swift), [`GEMDetailView.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMDetailView.swift) |
| **7** | 支援深淺色模式（Light / Dark Mode） | 自適應色彩語系、支援 App 內即時切換與持久化 | [`GEMTheme.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMTheme.swift), [`GEMAboutView.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMAboutView.swift) |
| **8** | Text Markdown 與外部超連結 | 支援 Markdown 排版與安全的 HTTPS 串流直達 | [`GEMComponents.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMComponents.swift), [`GEMModels.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMModels.swift) |
| **9** | 自訂字型（Custom Font）整合 | 註冊 Sora ExtraBold 英文與 Noto Sans TC 中文字型 | [`GEMTheme.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMTheme.swift), [`Info.plist`](file:///Users/k/Documents/GEM_about/Config/Info.plist) |
| **10** | 自訂形狀裁切圖片（Custom Shape） | 實作舞台菱形切割 `GEMStageCutShape` 裁切寫真 | [`GEMStageCutShape.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMStageCutShape.swift), [`GEMHeroView.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMHeroView.swift) |

---

> ### **程式碼講解 Code Explanation**

#### **1. 基本排版元件（VStack, HStack, ZStack, Text, Image, ScrollView）**
在 [`GEMHeroView.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMHeroView.swift) 中，透過 `ZStack` 疊加舞台菱形光暈、自訂裁切的藝人寫真與多層次文字標題，展現出氣勢磅礴的開場視覺：

<!-- 📷 圖片預留位：基本排版與 Hero 效果截圖 -->
![Hero 開場視覺截圖](請在此貼上圖片連結_Hero排版.png)
*▲ 圖 1：ZStack 與 VStack 疊加之開場視覺與標題排版*

```swift
struct GEMHeroView: View {
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // 背景深邃漸層與幾何光暈
            LinearGradient(
                colors: [GEMPalette.violet.opacity(0.85), Color(red: 0.08, green: 0.05, blue: 0.14)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )

            // 藝人主要視覺照片搭配自訂幾何裁切
            Image("gem_portrait")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: 420)
                .clipShape(GEMStageCutShape())

            // 垂直堆疊標題與引言
            VStack(alignment: .leading, spacing: 8) {
                Text("G.E.M. 鄧紫棋")
                    .font(GEMFont.display(34))
                    .foregroundStyle(Color.white)
                Text("BEYOND THE VOICE · 留住時間的聲音")
                    .font(GEMFont.headline(15))
                    .foregroundStyle(GEMPalette.gold)
            }
            .padding(24)
        }
    }
}
```

---

#### **2. 圖片資源（Asset Catalog）與 SF Symbols**
專案在 `Assets.xcassets` 中引入兩張由攝影師茂木木授權（CC BY-SA 3.0）的高解析度寫真 `gem_portrait` 與現場演出 `gem_live`。同時全面活用系統 SF Symbols，配合 iOS 的 `.symbolEffect(.bounce)` 打造細膩的心形收藏回饋：

<!-- 📷 圖片預留位：SF Symbol 動態收藏按鈕截圖 -->
![SF Symbols 收藏動畫截圖](請在此貼上圖片連結_SFSymbols收藏.png)
*▲ 圖 2：SF Symbol 彈跳動態效果與高解析度寫真*

```swift
struct GEMFavoriteButton: View {
    let id: String
    @EnvironmentObject private var library: GEMLibrary
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Button {
            library.toggleFavorite(id)
        } label: {
            Image(systemName: library.isFavorite(id) ? "heart.fill" : "heart")
                .font(.system(size: 19, weight: .medium))
                .foregroundStyle(GEMPalette.purple)
                .symbolEffect(.bounce, options: .nonRepeating, value: reduceMotion ? false : library.isFavorite(id))
                .symbolEffectsRemoved(reduceMotion)
                .frame(minWidth: 44, minHeight: 44)
                .background(GEMPalette.purple.opacity(0.09), in: Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(library.isFavorite(id) ? "取消收藏" : "收藏")")
    }
}
```

---

#### **3. 豐富的 View Modifiers 與 Liquid Glass 材質**
本專案導入 iOS 最新發布的 `.glassEffect(.regular, in:)`，在導覽列與標籤膠囊上呈現真實折射半透明玻璃質感，輔以陰影與漸層邊框：

<!-- 📷 圖片預留位：Liquid Glass 材質特寫截圖 -->
![Liquid Glass 膠囊導覽列特寫](請在此貼上圖片連結_LiquidGlass特寫.png)
*▲ 圖 3：真實折射之流體玻璃材質 Liquid Glass 膠囊列*

```swift
// 導覽膠囊列的材質與陰影修飾
.padding(.vertical, 4)
.glassEffect(.regular, in: Capsule())
.padding(.horizontal, 10)
.padding(.bottom, 8)
.accessibilityElement(children: .contain)
.accessibilityLabel("章節導覽")
```

---

#### **4. 上下滾動與導覽列滑動動態指示（ScrollView + ScrollViewReader）**
在 [`GEMAboutView.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMAboutView.swift) 中，透過 `ScrollViewReader` 與 iOS 原生高效能 `.onGeometryChange(for:of:action:)` 雙向連動：
1. **使用者滾動時**：即時計算各章節的 `minY` 偏移量，自動將「人物、成長、作品、舞台、巡演」當前位置以**透明小方塊**高亮標示。
2. **使用者點擊標籤時**：藉由 `proxy.scrollTo(section.0, anchor: .top)` 平滑移動到該區塊。

<!-- 📷 圖片預留位：滑動時透明小方塊跟隨定位截圖 -->
![導覽列透明方塊動態指示截圖](請在此貼上圖片連結_導覽透明小方塊.png)
*▲ 圖 4：滑動時動態指示章節位置的半透明小方塊（人物 / 成長 / 作品 / 舞台 / 巡演）*

```swift
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
}
```

---

#### **5. 模組化多檔案 View 結構**
專案架構清晰解耦，嚴格遵循單一職責原則（SRP）：
- **入口與主視圖**：[`GEMAboutApp.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMAboutApp.swift), [`GEMAboutView.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMAboutView.swift)
- **首頁專區區塊**：[`GEMHeroView.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMHeroView.swift), [`GEMSections.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMSections.swift)
- **詳情與探索視圖**：[`GEMDetailView.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMDetailView.swift), [`GEMExploreViews.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMExploreViews.swift)
- **巡演地圖模組**：[`GEMTourMapSection.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMTourMapSection.swift), [`GEMTourComponents.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMTourComponents.swift), [`GEMTourModels.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMTourModels.swift)
- **通用元件與主題**：[`GEMComponents.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMComponents.swift), [`GEMTheme.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMTheme.swift), [`GEMStageCutShape.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMStageCutShape.swift)
- **資料模型與資料庫**：[`GEMModels.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMModels.swift), [`GEMLibrary.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMLibrary.swift)

<!-- 📷 圖片預留位：Xcode 專案多檔案架構目錄截圖 -->
![Xcode 專案檔案結構截圖](請在此貼上圖片連結_Xcode架構.png)
*▲ 圖 5：清晰解耦的 14 個 SwiftUI 模組結構*

---

#### **6. View Property 客製化與元件封裝**
封裝可重複使用的發行作品卡片 [`GEMReleaseCard`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMComponents.swift)，傳入 `GEMEntry` 物件即可自動展現封面圖像、年份分類標籤、標題、摘要與獨立收藏按鈕：

<!-- 📷 圖片預留位：GEMReleaseCard 元件截圖 -->
![發行作品卡片元件截圖](請在此貼上圖片連結_作品卡片元件.png)
*▲ 圖 6：具備高重用性的 GEMReleaseCard 自訂 View 元件*

```swift
struct GEMReleaseCard: View {
    let entry: GEMEntry
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            NavigationLink(value: GEMRoute.entry(entry.id)) {
                VStack(alignment: .leading, spacing: 12) {
                    GEMArtwork(entry: entry)
                        .frame(width: 220, height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    Text("\(String(entry.year))  /  \(entry.category)")
                        .font(GEMFont.body(12))
                        .foregroundStyle(GEMPalette.purple)
                    Text(entry.title)
                        .font(GEMFont.headline(20))
                        .foregroundStyle(GEMPalette.foreground(for: scheme))
                        .fixedSize(horizontal: false, vertical: true)
                    Text(entry.summary)
                        .font(GEMFont.body(14))
                        .foregroundStyle(GEMPalette.secondary(for: scheme))
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                }
                .frame(width: 220, alignment: .leading)
            }
            .buttonStyle(GEMPressStyle())

            HStack {
                Text("查看作品").font(GEMFont.body(13)).foregroundStyle(GEMPalette.secondary(for: scheme))
                Spacer()
                GEMFavoriteButton(id: entry.id)
            }
        }
        .frame(width: 220, alignment: .leading)
    }
}
```

---

#### **7. 支援深淺色模式（Light / Dark Mode）**
在 [`GEMTheme.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMTheme.swift) 中打造深淺色動態調色盤 `GEMPalette`，並在頂部工具列提供手動一鍵切換按鈕，切換結果透過 `@AppStorage("gemUsesDarkMode")` 儲存：

<!-- 📷 圖片預留位：深淺色對比截圖 -->
![深淺色模式並排對比截圖](請在此貼上圖片連結_深淺色對比.png)
*▲ 圖 7：午夜紫暗黑模式與清爽日間模式的色彩對比*

```swift
enum GEMPalette {
    static let purple = Color(red: 0.60, green: 0.38, blue: 0.95)
    static let gold = Color(red: 0.93, green: 0.79, blue: 0.48)
    static let violet = Color(red: 0.23, green: 0.11, blue: 0.38)

    static func foreground(for scheme: ColorScheme) -> Color {
        scheme == .dark ? Color.white : Color(red: 0.12, green: 0.08, blue: 0.18)
    }

    static func secondary(for scheme: ColorScheme) -> Color {
        scheme == .dark ? Color.white.opacity(0.72) : Color(red: 0.35, green: 0.30, blue: 0.42)
    }

    static func card(for scheme: ColorScheme) -> Color {
        scheme == .dark ? Color(red: 0.14, green: 0.10, blue: 0.22) : Color.white
    }
}
```

---

#### **8. Text Markdown 與串流平台直達連結**
在進入歌曲或專輯頁面時，由 [`GEMStreamingPlatformSection`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMComponents.swift) 提供 **Apple Music**、**Spotify** 與 **YouTube Music** 的直接跳轉；同時在曲目列表中為每首歌曲配置「串流」選單：

<!-- 📷 圖片預留位：串流平台線上收聽區塊截圖 -->
![串流平台收聽入口與選單截圖](請在此貼上圖片連結_串流平台區塊.png)
*▲ 圖 8：Apple Music / Spotify / YouTube Music 直達入口與單曲選單*

```swift
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
        case .appleMusic: urlString = "https://music.apple.com/us/search?term=\(encoded)"
        case .spotify: urlString = "https://open.spotify.com/search/\(encoded)"
        case .youtubeMusic: urlString = "https://music.youtube.com/search?q=\(encoded)"
        }
        return GEMURL.https(urlString)
    }
}
```

在頁面文字中，亦可使用標準 Markdown 語法超連結：
```swift
Text("參訪鄧紫棋 [官方網站](https://www.iamgem.com/) 或在 [Spotify 關注](https://open.spotify.com/artist/74KMfq2ol7SF2T5gsL5848) 最新單曲。")
```

---

#### **9. 自訂字型（Custom Fonts）整合與註冊**
專案在 `font/` 目錄中打包並於 `Info.plist` 中登錄了符合開源 SIL OFL 授權的真實字型檔案：
- **`Sora-ExtraBold.ttf`**：用於西文數字、年份與重音大標題。
- **`NotoSansTC-Regular.ttf` & `NotoSansTC-Bold.ttf`**：用於高質感繁體中文閱讀。

<!-- 📷 圖片預留位：自訂字型在介面上的呈現截圖 -->
![自訂字型呈現截圖](請在此貼上圖片連結_自訂字型.png)
*▲ 圖 9：Sora ExtraBold 與 Noto Sans TC 在介面中的字體層次排版*

在 [`GEMTheme.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMTheme.swift) 中封裝語義化字體調用：

```swift
enum GEMFont {
    static func display(_ size: CGFloat) -> Font {
        Font.custom("Sora-ExtraBold", size: size)
    }

    static func headline(_ size: CGFloat) -> Font {
        Font.custom("NotoSansTC-Bold", size: size)
    }

    static func body(_ size: CGFloat) -> Font {
        Font.custom("NotoSansTC-Regular", size: size)
    }
}
```
*在 XCTest 單元測試中，透過 `UIFont(name:size:)` 驗證 100% 成功註冊於系統。*

---

#### **10. 自訂形狀裁切圖片（`GEMStageCutShape` 舞台幾何切割）**
在 [`GEMStageCutShape.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMStageCutShape.swift) 中實現自訂 `Shape`，以不對稱六邊形斜切切割照片，象徵聚光燈與鑽石舞台的光芒切割感：

<!-- 📷 圖片預留位：自訂形狀裁切特寫截圖 -->
![舞台幾何形狀裁切特寫截圖](請在此貼上圖片連結_幾何裁切.png)
*▲ 圖 10：GEMStageCutShape 幾何多邊形斜切效果*

```swift
struct GEMStageCutShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let cutInset: CGFloat = min(rect.width, rect.height) * 0.08
        path.move(to: CGPoint(x: rect.minX + cutInset, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cutInset))
        path.addLine(to: CGPoint(x: rect.maxX - cutInset, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cutInset))
        path.closeSubpath()
        return path
    }
}
```

---

> ### **遇到的問題與解決方法**

1. **頂部導覽列章節同步與滑動偵測延遲**：
   - *問題*：傳統使用 `PreferenceKey` 搭配 `GeometryReader` 計算座標時，容易造成大量的 View 重繪並引發滑動卡頓。
   - *解決方案*：改採 iOS 原生高效能 `.onGeometryChange(for:of:action:)`，精確監控 5 個章節相對於 global 座標的 `minY`，並設定 260pt 閾值平滑切換 `activeSection`。
2. **串流連結的跨平台相容性與合規驗證**：
   - *問題*：部分歷史早期曲目在特定串流服務上沒有固定的靜態 ID，直接寫入非 HTTPS 網址會被安全原則阻絕。
   - *解決方案*：建立 `GEMStreamingPlatform` 模組，優先取用官方指定連結；若未收錄則動態構建已百分比編碼（Percent Encoding）的標準合法 HTTPS 搜尋入口（Apple Music / Spotify / YouTube Music），並在 XCTest 中驗證所有連結格式。
3. **導覽欄標題換行折疊**：
   - *問題*：在 iPhone 直立窄螢幕下，ToolbarItem 的 `G.E.M. / ABOUT` 容易被系統折成兩行（`G.E.\nM....`）。
   - *解決方案*：加上 `.lineLimit(1)` 與 `.fixedSize(horizontal: true, vertical: false)` 強制鎖定水平寬度，避免非預期換行。
4. **離線網路下的圖片與資料容錯**：
   - *問題*：開啟飛航模式時，遠端封面載入失敗可能導致空白或閃退。
   - *解決方案*：在 `GEMArtwork` 中設計了優雅的幾何幾彩備用視圖（Fallback View），呈現作品名與金色年份；本機打包的核心 JSON 檔案與真實寫真確保無網路時依然能暢快瀏覽。

---

> ### **開發心得與總結**

透過這次 **#03 打造吸睛的 About 頁面** 的深度開發，我體會到 SwiftUI 在架構大型主題內容時的強大優勢。從基本的 Stack 佈局、字型設定、材質修飾，到進階的 `ScrollViewReader` 動態滾動、Liquid Glass 材質與 MapKit 整合，SwiftUI 的宣告式語法讓複雜的介面狀態與微動畫變得直觀且高度可維護。

特別是在實作「串流平台即時收聽」與「導覽欄滑動透明方塊」時，能深刻體會到現代 iOS 在使用者體驗細節上的極致追求——不僅要在視覺上兼具舞台美感與現代感，更要顧及深淺色對比、無障礙輔助與離線強健度。這款 App 不僅是一份吸睛的 About 頁面，更是一座完整致敬鄧紫棋音樂創作歷程的數位藝術殿堂！
