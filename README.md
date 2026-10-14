# G.E.M. — BEYOND THE VOICE

以 SwiftUI 打造的 G.E.M. 鄧紫棋藝人 About Page。設計：午夜紫 / 香檳金 / 唱片雜誌感，支援 Dark / Light 切換，並新增 **MapKit 世界巡演互動地圖**（Map、Marker、Annotation）。

## 打開專案

1. 若壓縮包包含 `GEM_BeyondTheVoice.xcodeproj`，在 Mac 上以 Xcode 15+ 開啟。部署目標 iOS 17.0+。
2. 確認 SwiftUI 11 個檔案位於專案內、`Assets.xcassets` 在 Target 的資源中。
3. 在 Xcode > Project > Target > Signing & Capabilities 選自己的 Team，必要時變更 Bundle Identifier。
4. 選 iPhone Simulator，按 `⌘R` 執行。
5. 頂端右側太陽/月亮按鈕切換 Light / Dark；此選項以 AppStorage 記住偏好。
6. 向下捲動到 **03 / WORLD TOUR**，點選台北／新加坡／吉隆坡／深圳的標記或城市按鈕，檢查地圖鏡頭移動與下方資訊卡。

如 Xcode 無法直接開啟專案：自行建立 iOS App，Interface 選 SwiftUI、Language 選 Swift；**刪掉 Xcode 原始的 `@main App` 檔，僅保留 `GEMAboutApp.swift`**，將 `SwiftUI` 內所有 `.swift` 檔加入 App target，然後將五個 `.imageset` 複製到新專案 Assets.xcassets。

## 自訂字型：必要的手動步驟

**此包不包含字型檔**（請從官方免費授權來源自行下載）。

- 下載 **Sora ExtraBold**、**Noto Sans TC Bold**、**Noto Sans TC Regular** TTF 字型。
- 官方來源： https://fonts.google.com/specimen/Sora 及 https://fonts.google.com/noto/specimen/Noto+Sans+TC 。
- 若下載到 Variable Font，請確認檔名及真實 PostScript name；可另用 Google Fonts 的靜態 TTF 字重版本。
- 把字型拖進 Xcode target，勾選 **Copy items if needed** 和 App target。
- `Info.plist` / Target Info → `Fonts provided by application` (UIAppFonts) 加入實際隨 App 打包的 TTF 檔名。例如 `Sora-ExtraBold.ttf`、`NotoSansTC-Bold.ttf`、`NotoSansTC-Regular.ttf`。
- `GEMTheme.swift` 中 `.custom("Sora-ExtraBold", ...)` / `.custom("NotoSansTC-Bold", ...)` / `.custom("NotoSansTC-Regular", ...)` 使用**字型的 PostScript 名稱，而不是單純字型檔名**。若取得的版本名稱不同，要同步修改。

未安裝字型，iOS 會以系統字型備援，仍可預覽頁面，但課堂展示「自訂字型」前必須真的安裝。

## 圖片 Asset 與授權

包內有**五張原創抽象示意圖**，都是 placeholder，**不是鄧紫棋真人照片，也不是官方專輯封面**。以避免未授權再散布照片／唱片封面。請用你已取得合法使用權的素材直接替換（保持 Asset 名稱）：

- `gem_hero`: Artist hero portrait (推薦直式，至少 900×1200)
- `gem_stage`: Artist stage photo (推薦橫式，至少 1000×650)
- `album_gloria`: 《I AM GLORIA》封面
- `album_revelation`: 《啟示錄》封面
- `album_zoo`: 《摩天動物園》封面

正式版請適當標註影像來源，不要將示意圖當成官方影像。

## Keynote 自訂形狀（作業要求第 10 點）

請讀 `Keynote_Guide/KEYNOTE_SHAPE_GUIDE.md`，依照五個頂點在 Keynote 真正畫出多邊形並截圖。SwiftUI 中 `GEMStageCutShape.swift` 使用 `Path` 重建完全相同的形狀；`GEMHeroView.swift`、`GEMComponents.swift` 都以 `.clipShape(GEMStageCutShape())` 裁切照片。

## 十項規格檢查

| # | 規格 | 實作位置 |
|---|---|---|
| 1 | VStack、HStack、ZStack、Text、Image、ScrollView | `GEMAboutView.swift`, `GEMHeroView.swift`, `GEMSections.swift`, `GEMTourMapSection.swift` |
| 2 | 圖片 Asset + SF Symbol | `Assets.xcassets`、`Image("gem_hero")`、`Image(systemName: "waveform")` |
| 3 | 多個 modifier | `.font` `.tracking` `.padding` `.background` `.overlay` `.clipShape` `.foregroundStyle` 等 |
| 4 | 上下捲動 | `GEMAboutView.swift` 的 `ScrollView(.vertical)` |
| 5 | 多檔案 View 型別 | `GEMAboutView.swift`, `GEMHeroView.swift`, `GEMComponents.swift`, `GEMSections.swift`, `GEMTourMapSection.swift`, `GEMTourComponents.swift` |
| 6 | View property 客製化 | `GEMAlbumCard(album:)`, `GEMTourCityChip(stop:isSelected:onSelect:)`, `GEMTourDetailCard(stop:)` 等 |
| 7 | Light / Dark mode | `GEMAboutView.swift` 的切換按鈕 + `.preferredColorScheme` |
| 8 | Text + Markdown 連結 | `GEMConnectSection`：`Text("前往 [G.E.M. 官方網站](https://www.iamgem.com/) ...")` |
| 9 | 自訂字型 | `GEMTheme.swift` 中 `Font.custom`；**須自己下載字型並加入 Target** |
| 10 | Keynote 形狀 / SwiftUI 剪裁 | Keynote 手動繪製＋`GEMStageCutShape.swift`＋`.clipShape(...)`；**須自行完成 Keynote 繪圖存證** |

## 新增功能：03 / WORLD TOUR（MapKit）

本次更新直接沿用原專案的 **GEMPalette** 與 **GEMFont**，而非另外建立一套地圖主題：

- `SwiftUI/GEMTourModels.swift`：`GEMTourStop` 自訂資料模型、演唱會日期、場館名稱與座標、概覽地圖範圍。
- `SwiftUI/GEMTourMapSection.swift`：嵌入 About 頁面的 `Map(position:selection:)`、`Marker`、自訂 `Annotation`、鏡頭動畫、返回全部城市按鈕。
- `SwiftUI/GEMTourComponents.swift`：紫金色自訂地圖圖釘、資料驅動城市選單、互動式巡演資訊卡。
- `SwiftUI/GEMAboutView.swift`：將 `GEMTourMapSection()` 插入音樂旅程與專輯列表之間。
- `SwiftUI/GEMSections.swift`：更新後續章節編號為 04（專輯）、05（歌曲）、06（官方連結）。

### 如何操作地圖

1. 地圖預設顯示四座城市：台北、新加坡、吉隆坡、深圳。
2. 直接點擊台北的 **G.E.M. / TAIPEI** 自訂 Annotation，或其他城市的 **Marker**，地圖會以動畫聚焦所選場館並更新卡片。
3. 地圖下方可橫向滑動的城市標籤也能切換城市。
4. 地圖右上角的四向箭頭可返回所有城市概覽。
5. `APPLE MAPS` 會使用 `MKMapItem` 開啟對應場館；`OFFICIAL TOUR` 會開啟 G.E.M. 官方巡演頁面。
6. Light / Dark 模式跟隨原專案的切換按鈕；地圖採用 **muted standard** 樣式，卡片使用 `GEMPalette` 色票。

本範例**不需要使用者定位權限**（沒有要求當前位置）也不需要 MapKit API key；但地圖圖磚必須能連線載入。部分地區的 Apple Maps 地圖供應與詳細程度可能不同。

### 本次範例資料來源

- 巡演日期與場館：官方 https://www.iamgem.com/tours/ （2026 年 10 月核對）。
- 場館座標（近似）：Taipei Dome / Mapcarta；Singapore National Stadium / Wikidata；Bukit Jalil National Stadium / Mapcarta；Shenzhen Universiade Sports Centre Stadium / Mapcarta。
- **這是歷史場次地圖，不是售票系統、非未來行程保證。** 展示用圖片目前仍為原創佔位素材。
- 若要增加站點，在 `GEMTourContent.stops` 陣列中增加 `GEMTourStop` 即可；城市清單、標記與資訊卡會隨資料同步產生。

## 內容查證與導覽

- 官方網站：https://www.iamgem.com/
- Sony Music 2025 專輯：https://www.sonymusic.com.tw/album/i-am-gloria/
- Sony Music 2019 專輯：https://www.sonymusic.com.tw/album/g-e-m-city-zoo/
- Sony Music 2026 作品：https://www.sonymusic.com.tw/album/free-to-be-you/
- Spotify：https://open.spotify.com/artist/7aRC4L63dBn3CiLDuWaLSI

資料與文字為粉絲性質的作品示範，並非官方 App。

## 已知限制

開發環境中無 macOS/iOS SDK，已用 Swift parser 檢查語法及 plist/project 格式，但無法在此進行真正的 Xcode 編譯或 iPhone 模擬器截圖；需要你在 Xcode 開啟後按 `⌘R` 最終驗證。Keynote 實際繪圖、字型安裝、正版照片替換等必須在你的 Mac 上完成。
