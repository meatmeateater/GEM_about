# G.E.M. — Beyond the Voice
### 原創音樂人人物誌 · 作品資料庫 · 巡演地圖 iOS 應用程式

[![iOS Version](https://img.shields.io/badge/iOS-27.0%2B-blue.svg?style=flat-square&logo=apple)](https://developer.apple.com/ios/)
[![Xcode Version](https://img.shields.io/badge/Xcode-27.0%2B-blue.svg?style=flat-square&logo=xcode)](https://developer.apple.com/xcode/)
[![Swift Version](https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat-square&logo=swift)](https://swift.org/)
[![UI Framework](https://img.shields.io/badge/SwiftUI-Liquid%20Glass-purple.svg?style=flat-square)](https://developer.apple.com/xcode/swiftui/)
[![Tests](https://img.shields.io/badge/XCTest-10%20Passed-brightgreen.svg?style=flat-square)](GEM_BeyondTheVoiceTests/)
[![Static Validation](https://img.shields.io/badge/Checks-1840%20Passed-brightgreen.svg?style=flat-square)](scripts/validate_project.py)

---

## 專案簡介 (Overview)

**G.E.M. — Beyond the Voice** 是一款專為華語樂壇代表性創作天后 **G.E.M. 鄧紫棋（Gloria Tang）** 打造的深度音樂人物誌與探索 App。

不同於常見的單頁式靜態展示，本專案建構了完整的「**事件 → 作品 → 歌曲 → 舞台／版本 → 收藏**」深層關聯鏈路。介面設計融合 iOS 現代 **Liquid Glass（流體玻璃質感）** 與典雅午夜紫、香檳金調色盤，搭配自訂多邊形幾何切角與微動畫，兼顧 **VoiceOver 無障礙旁白**、**動態字級支援** 與 **減少動態效果（Reduce Motion）**。

- **GitHub 專案庫**：[meatmeateater/GEM_about](https://github.com/meatmeateater/GEM_about)
- **技術文件清單**：
  - [Mac / iOS 驗收審核清單](file:///Users/k/Documents/GEM_about/docs/MAC_ACCEPTANCE.md)
  - [素材來源、修圖說明與授權聲明](file:///Users/k/Documents/GEM_about/docs/MEDIA_CREDITS.md)
  - [53 筆事實核對來源總表](file:///Users/k/Documents/GEM_about/docs/CONTENT_SOURCES.md)
  - [Keynote 自訂裁切形狀製作指引](file:///Users/k/Documents/GEM_about/Keynote_Guide/KEYNOTE_SHAPE_GUIDE.md)

---

## 核心功能亮點 (Key Features)

1. **Liquid Glass 動態導覽指示**：
   頂部導覽膠囊列採用 iOS 原生 `.glassEffect`。透過幾何感應技術即時追蹤垂直捲動位置，以半透明小方塊流暢標示當前閱讀章節（人物 / 成長 / 作品 / 舞台 / 巡演），點擊時平滑置頂導航。
2. **串流平台即時整合 (Streaming Integration)**：
   單曲與專輯內頁整合 **Apple Music**、**Spotify** 與 **YouTube Music** 聆聽入口，並配置智慧搜尋機制，點選即可直接喚起對應平台。
3. **立體化生涯成長時間軸**：
   收錄 18 件關鍵歷史事件，支援依年代（2010s 起步與突破、2020s 自立自省）與維度（音樂創作、大型舞台、個人生活）複合交叉篩選，同年多事件完整並存。
4. **深度作品檔案庫與錄音版本對照**：
   收錄 10 張發行作品與 14 首經典曲目。特別設計「同曲不同時期」版本對照區塊（例如〈泡沫〉早期錄音與全新重唱版），分開呈現客觀事實與編輯導讀。
5. **《I AM GLORIA》巡演互動地圖**：
   基於 MapKit 呈現重點巡迴城市與場館公佈檔案，具備單一相機動態對焦、城市切換、場館資訊卡浮現與一鍵開啟 Apple Maps 導航功能。
6. **本機持久化收藏系統 (Favorites & Persistence)**：
   任意歷史事件、專輯或單曲皆可一鍵收藏。資料透過 `UserDefaults` 持久化儲存，跨頁面狀態即時雙向同步，總覽頁支援原生左滑取消收藏。
7. **全功能離線與無障礙體驗**：
   打包完整結構化 JSON 與本機寫真，無網路狀態下文字、照片與搜尋完全可用；全面實作 Accessibility Label、Hint，並適應系統 Reduce Motion 設定。

---

## 課堂作業要求落實對照表 (Course Requirements)

本專案全面落實並深化了課堂作業規定的 11 項核心技術要求：

| # | 作業要求項目 | 本專案實作亮點與應用情境 | 核心對應程式碼檔案 |
|:---:|---|---|---|
| **1** | **基礎容器與視覺元件**<br>`VStack`, `HStack`, `ZStack`, `Text`, `Image`, `ScrollView` | 首頁人物誌、時間軸、探索頁與詳情頁全面採用深層組合佈局；ZStack 用於照片多邊形裁切與玻璃光暈效果堆疊。 | [`GEMAboutView.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMAboutView.swift)<br>[`GEMHeroView.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMHeroView.swift)<br>[`GEMSections.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMSections.swift) |
| **2** | **Asset Catalog & SF Symbols** | 本機照片納入 `Assets.xcassets`；系統圖示全面採用 SF Symbols（如 `heart.fill`, `play.circle.fill`, `map.fill`, `sparkles` 等）。 | [`Assets.xcassets/`](file:///Users/k/Documents/GEM_about/Assets.xcassets)<br>[`GEMComponents.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMComponents.swift) |
| **3** | **多種 SwiftUI Modifier 組合** | 靈活搭配 `.font()`, `.foregroundStyle()`, `.background()`, `.clipShape()`, `.padding()`, `.shadow()`, `.glassEffect()`, `.transition()`, `.animation()`。 | [`GEMComponents.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMComponents.swift)<br>[`GEMSections.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMSections.swift) |
| **4** | **垂直捲動 ScrollView** | 首頁人物誌採用流暢垂直捲動，搭配幾何座標動態感知即時更新頂部導覽列狀態。 | [`GEMAboutView.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMAboutView.swift)<br>[`GEMDetailView.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMDetailView.swift) |
| **5** | **多檔案模組化定義 View** | 程式碼拆分為 14 個專責 Swift 檔案，落實關注點分離（SoC），架構清晰易維護。 | [`SwiftUI/`](file:///Users/k/Documents/GEM_about/SwiftUI/)（14 個模組） |
| **6** | **Property 客製化自訂 View** | 封裝多款具備自訂 Property 的通用元件（如 `GEMEntryRow`, `GEMArtwork`, `GEMFavoriteButton`, `GEMFilterChip`, `GEMEmptyState`）。 | [`GEMComponents.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMComponents.swift) |
| **7** | **深淺色模式支援 (Light / Dark)** | 打造語意化 `GEMPalette`，在「午夜深紫」與「晨曦珍珠白」間自適應對比與半透明層級。 | [`GEMTheme.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMTheme.swift) |
| **8** | **Text + Markdown 超連結** | 資料來源與事實引用均支援 Markdown 超連結，點擊即可開啟 Safari 查證外部原始文獻。 | [`GEMSections.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMSections.swift)<br>[`GEMDetailView.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMDetailView.swift) |
| **9** | **客製字型 (Custom Fonts)** | 引入開源字型 `Sora-ExtraBold` 與 `NotoSansTC`，於 `Info.plist` 註冊並通過 XCTest 驗證。 | [`Config/Info.plist`](file:///Users/k/Documents/GEM_about/Config/Info.plist)<br>[`GEMTheme.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMTheme.swift) |
| **10** | **Keynote 形狀 + Shape 裁切** | 以 Keynote 幾何控制點規劃五邊形舞台切角，在 `GEMStageCutShape` 以 `Path` 重建，並以 `.clipShape()` 裁切照片。 | [`GEMStageCutShape.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMStageCutShape.swift)<br>[`KEYNOTE_SHAPE_GUIDE.md`](file:///Users/k/Documents/GEM_about/Keynote_Guide/KEYNOTE_SHAPE_GUIDE.md) |
| **11** | **MapKit 地圖應用** | 使用 MapKit 呈現《I AM GLORIA》巡迴城市，包含自訂標記、相機平滑平移與 Apple Maps 導航。 | [`GEMTourMapSection.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMTourMapSection.swift)<br>[`GEMTourComponents.swift`](file:///Users/k/Documents/GEM_about/SwiftUI/GEMTourComponents.swift) |

---

## 畫面展示與版位規劃 (Showcase)

> [!TIP]
> 截圖檔案推薦以 **iPhone 17 (iOS 27)** 模擬器執行 `Cmd + S` 擷取，儲存於 `docs/screenshots/` 目錄並依序命名。

| 展示項目 | 畫面特色說明 | 建議預留截圖放置點 |
|---|---|:---:|
| **01. 首頁 Hero 與導覽** | 午夜紫漸層底色、非對稱幾何切角寫真與 Liquid Glass 頂部導覽列 | `docs/screenshots/01_home.png` |
| **02. 生涯成長時間軸** | 複合年代標籤（2010s / 2020s）與音樂、舞台、個人維度交叉篩選 | `docs/screenshots/02_timeline.png` |
| **03. 作品檔案庫** | 10 張正規專輯橫向滑動卡片，具備封面載入備援與收藏按鈕 | `docs/screenshots/03_releases.png` |
| **04. 串流平台直達** | 單曲與專輯詳情頁，Apple Music / Spotify / YouTube Music 快速選單 | `docs/screenshots/04_streaming.png` |
| **05. 錄音版本對照** | 〈泡沫〉早期創作版與全新重唱版之編曲、錄音年份與發行對照 | `docs/screenshots/05_versions.png` |
| **06. 巡演互動地圖** | MapKit 標記深圳、廣州、北京等重點場館，相機流暢移動與導航 | `docs/screenshots/06_tour_map.png` |
| **07. 本機收藏清單** | 跨條目獨立收藏管理，支援 iOS 原生左滑刪除與重新啟動驗證 | `docs/screenshots/07_favorites.png` |
| **08. 深淺色主題對比** | 深色（午夜紫暗金）與淺色（晨曦亮紫珍珠白）對比呈現 | `docs/screenshots/08_dark_light.png` |

---

## 設計系統 (Design System)

### 1. 色彩體系 (Color Palette)
- **Primary / Accent**：香檳金 `GEMPalette.gold`（`#D8B26E` / `#E5C583`）
- **Background Dark**：午夜深紫 `GEMPalette.deepPurpleDark`（`#1A0C2E`）
- **Background Light**：晨曦珍珠白 `GEMPalette.pearlLight`（`#F9F6FA`）
- **Surface**：Liquid Glass 材質搭配語意化次要背景色。

### 2. 字型系統 (Typography)
- **英文與數字標題**：`Sora-ExtraBold`（展現現代音樂力量感與律動感）
- **中文內文與標籤**：`NotoSansTC-Regular`、`NotoSansTC-Bold`（確保繁體中文排版閱讀舒適性）

### 3. 自訂幾何裁切 (Stage Cut Geometry)
- 五點多邊形座標公式：`(0, 0) → (1.0, 0) → (1.0, 0.83) → (0.38, 1.0) → (0, 0.90)`，營造不對稱的現代前衛舞台光芒切角。

---

## 專案架構與檔案組織 (Architecture)

```text
GEM_BeyondTheVoice/
├── GEM_BeyondTheVoice.xcodeproj    # Xcode 專案配置檔（鎖定 iOS 27.0, Swift 5.0）
├── SwiftUI/                        # SwiftUI 視圖與業務邏輯模組
│   ├── GEMAboutApp.swift           # App 入口點與全域 Environment 注入
│   ├── GEMAboutView.swift          # 首頁骨架、Liquid Glass 動態導覽指示
│   ├── GEMHeroView.swift           # 開場大型 Hero 視覺與幾何切角寫真
│   ├── GEMSections.swift           # 人物簡介、時間軸、發行作品、代表舞台
│   ├── GEMDetailView.swift         # 詳情檔案頁、串流連結、錄音版本對照
│   ├── GEMExploreViews.swift       # 全域搜尋頁、本機收藏管理頁
│   ├── GEMTourMapSection.swift     # MapKit 巡演地圖、相機鏡頭控制
│   ├── GEMTourComponents.swift     # 巡演地圖專用卡片與控制面板
│   ├── GEMTourModels.swift         # 巡演地圖資料結構與精選城市座標
│   ├── GEMComponents.swift         # 共用元件（卡片、收藏按鈕、串流面板）
│   ├── GEMStageCutShape.swift      # 自訂 Shape 舞台菱形幾何裁切
│   ├── GEMTheme.swift              # 深淺色調色盤 (GEMPalette) 與字體 (GEMFont)
│   ├── GEMModels.swift             # 核心資料模型（Entry、Date、Link、串流 Enum）
│   └── GEMLibrary.swift            # 核心商業邏輯（篩選、搜尋、收藏持久化）
├── Content/                        # 結構化資料與授權署名
│   ├── gem-catalog.json            # 完整生涯、發行作品、曲目與歷史事件（18事件/10發行/14曲目）
│   ├── artwork-map.json            # 封面圖像線上來源與雜湊索引
│   └── media-credits.json          # 圖片攝影作者與版權詳細署名
├── font/                           # 隨 App 打包之開源字型（SIL OFL 1.1）
│   ├── Sora-ExtraBold.ttf          # 標題與數字英文客製字型
│   └── NotoSansTC-*.ttf            # 繁體中文內文字型（Regular / Bold）
├── Config/                         # 系統配置與隱私權宣告
│   ├── Info.plist                  # 包含 UIAppFonts 字型註冊
│   └── PrivacyInfo.xcprivacy       # 現代化隱私清單 Manifest（CA92.1）
├── GEM_BeyondTheVoiceTests/        # 完整 XCTest 單元測試套件
│   └── GEM_BeyondTheVoiceTests.swift # 10 項嚴謹單元測試（包含資料、字型、地圖與持久化）
├── Keynote_Guide/                  # Keynote 自訂裁切形狀指南
│   └── KEYNOTE_SHAPE_GUIDE.md      # Keynote 幾何座標與繪製實作指引
├── docs/                           # 深度文件與驗收報告
│   ├── MAC_ACCEPTANCE.md           # Mac / iOS 驗收審核清單（100% 依循標準）
│   ├── MEDIA_CREDITS.md            # 素材來源、修圖說明與授權聲明
│   └── CONTENT_SOURCES.md          # 53 項事實核對來源總表
└── scripts/                        # 工程維護與驗證自動化腳本
    ├── apply_artwork.py            # 線上封面中繼資料對應
    ├── package_release.py          # 發行封裝打包工具
    ├── update_xcode_project.py     # Xcode 專案檔案引用安全同步工具
    └── validate_project.py         # 離線靜態完整性檢查腳本
```

---

## 測試與品質保證 (Testing & QA)

專案內建完整的單元測試套件與離線靜態檢查機制，確保程式碼與資料的極致穩定性。

### 1. 單元測試 (XCTest)
在 macOS / Xcode 27.0 / iOS 27.0 Simulator 環境下執行通過：
- **`testBundledCatalogLoadsAndAllReferencesResolve`**：確認內建 JSON 載入無誤，所有引用關聯皆可解析。
- **`testCatalogRejectsDuplicateAndDanglingIDs`**：確認目錄防錯機制能有效拒絕重複與失效 ID。
- **`testDatePrecisionDoesNotInventMonthOrDay`**：驗證日期精度嚴謹度，僅有年份時絕不虛構月日。
- **`testExternalLinksRequireHTTPSHost`**：嚴格檢驗所有外部超連結皆具備安全 HTTPS 協定與 Host。
- **`testFavoritePersistsAcrossStoreRecreationAndRemoval`**：測試收藏在 Store 重建與重開時的持久化狀態。
- **`testRealPhotoAssetsAndRegisteredFontsAreAvailable`**：驗證 Asset 目錄寫真與自訂字型註冊可正常解析。
- **`testSearchNormalizesChineseLatinAndWhitespaceAndFiltersKind`**：驗證繁簡轉換、全半形、大小寫與多詞搜尋精準度。
- **`testStreamingPlatformGeneratesValidHTTPSURLs`**：驗證各串流平台安全轉址生成邏輯。
- **`testTimelineKeepsSameYearEventsAndCombinesFilters`**：驗證同年多事件在多維度篩選下的排序與並存。
- **`testTourOverviewEnclosesAllCuratedStops`**：驗證巡演地圖相機邊界能精準包覆所有巡演站點。

### 2. 靜態完整性驗證 (Static Validation)
執行 `python3 scripts/validate_project.py`，通過 **1,840 項檢查（0 Failures）**，嚴格覆蓋：
- 53 筆事實文獻出處格式檢查。
- 專案檔案引用與 PBXBuildPhase 成員同步檢查。
- 字型 PostScript 內部名稱一致性與 OFL 授權條款檢查。
- 圖片 SHA-1 雜湊檔案完整性檢查。

---

## 圖片與素材授權說明 (Media & Credits)

本專案對所有使用的素材來源與版權狀態秉持誠實、公開、透明原則：

1. **主視覺寫真 (`gem_portrait`)**：
   - 目前畫面使用的是 2025 年《I AM GLORIA》巡迴演唱會相關寫真（檔案規格：5160 × 2582 JPEG）。
   - 來源報導：參照 [am730 相關新聞報導](https://www.am730.com.hk/article/593879)。
   - **版權現狀**：版權屬原攝影者或相關權利人所有，目前標記為「**待確認（非開放授權）**」。非商用課堂展示使用，若作公開作品集發布建議替換為具備正式授權之照片。
2. **鋼琴自彈自唱寫真 (`gem_live`)**：
   - 攝影者：**茂木木**。
   - 授權方式：[CC BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/)（創用 CC 姓名標示-相同方式分享 3.0）。
   - 來源：[Wikimedia Commons](https://commons.wikimedia.org/wiki/File:Gem_Tang_Singing_with_Piano_2.jpg)。
3. **開源字型**：
   - Sora、Noto Sans TC 均基於 [SIL Open Font License 1.1](font/Sora-OFL.txt) 授權打包使用。

---

## 系統需求與環境建置 (Environment & Build)

### 系統與工具需求
- **作業系統**：macOS Sequoia 15.0 或更新版本
- **開發工具**：Xcode 27.0 或更新版本（含 iOS 27.0 SDK）
- **執行目標**：iOS 27.0+（支援 iPhone 17 / iPhone 17 Pro 模擬器與實機）

### 建置與測試指令
在終端機專案根目錄下執行：

```bash
# 1. 執行專案離線靜態驗證
python3 scripts/validate_project.py

# 2. 建置 Xcode 專案 (Build)
xcodebuild build \
  -project GEM_BeyondTheVoice.xcodeproj \
  -scheme GEM_BeyondTheVoice \
  -destination 'platform=iOS Simulator,name=iPhone 17'

# 3. 執行 XCTest 單元測試套件 (Test)
xcodebuild test \
  -project GEM_BeyondTheVoice.xcodeproj \
  -scheme GEM_BeyondTheVoice \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

---

## 待辦事項與後續規劃 (Roadmap & Next Steps)

- [x] 完成 iOS 27 / Xcode 27 專案設定鎖定與清理。
- [x] 完成 10 項 XCTest 單元測試全部通過（0 Failures）。
- [x] 完成檔案完整性與授權證明分開記錄（1,840 項靜態驗證通過）。
- [x] 清除未引用的冗餘圖片與過時文件。
- [ ] **Mac 介面截圖**：於 Mac 端以 iPhone 17 模擬器截取 8 張高畫質介面圖並放入 `docs/screenshots/`。
- [ ] **Keynote 原檔匯出**：於 Mac Keynote 繪製五邊形舞台切角並匯出 `GEM_Stage_Shape.key` 至 `Keynote_Guide/`。
- [ ] **版權確認**：聯繫確認 2025 巡演照片之公開授權狀態或更換為公有領域圖像。

---

## 誌謝與聲明 (Acknowledgments & Disclaimer)

- **音樂主題**：致敬華語樂壇卓越創作歌手 **G.E.M. 鄧紫棋** 與其團隊創作之經典音樂篇章。
- **免責聲明**：本專案為非營利性質之大專院校 iOS SwiftUI 程式設計作業與技術研究作品。專案內收錄之所有文字、歌曲資訊與影音資料均為公開資訊整理；本 App 不內建任何音訊串流伺服器，所有收聽與觀看入口皆直接連結至官方合法串流平台。
