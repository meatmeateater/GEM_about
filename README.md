# G.E.M. — Beyond the Voice
### 原創音樂創作人物誌 · 作品資料庫 · 巡演互動地圖 iOS 應用程式

[![iOS Version](https://img.shields.io/badge/iOS-27.0%2B-blue.svg?style=flat-square&logo=apple)](https://developer.apple.com/ios/)
[![Xcode Version](https://img.shields.io/badge/Xcode-27.0%2B-blue.svg?style=flat-square&logo=xcode)](https://developer.apple.com/xcode/)
[![Swift Version](https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat-square&logo=swift)](https://swift.org/)
[![UI Framework](https://img.shields.io/badge/SwiftUI-Liquid%20Glass-purple.svg?style=flat-square)](https://developer.apple.com/xcode/swiftui/)
[![Tests](https://img.shields.io/badge/XCTest-10%20Passed-brightgreen.svg?style=flat-square)](GEM_BeyondTheVoiceTests/)

---

## 專案簡介 (Overview)

**G.E.M. — Beyond the Voice** 是一款專為華語樂壇指標性創作天后 **G.E.M. 鄧紫棋** 打造的深度音樂人物誌與探索 App。

不同於傳統單頁式的靜態個人介紹，本 App 構建了完整的「**事件 → 作品 → 歌曲 → 舞台／版本 → 收藏**」深層探索鏈路。整體介面採用深邃午夜紫與高雅香檳金調色盤，完美融合 iOS 最新 **Liquid Glass（流體玻璃材質）**、自訂多邊形舞台切割與絲滑微動畫，提供使用者沉浸式的視聽資料庫瀏覽體驗。

---

## 成果展示 (Showcase)

### 動態操作展示 (GIF)
<!-- 📷 圖片預留位：App 完整操作走讀 GIF -->
![App 操作完整走讀動態展示 GIF](docs/screenshots/gem_demo.gif)
*▲ 動態走讀：頂部導覽列透明方塊即時指示、生涯時間線複合篩選、專輯曲目跳轉三大串流、巡演地圖與離線收藏*

### 核心介面截圖 (Screenshots)
<!-- 📷 圖片預留位：可替換為實際螢幕截圖 -->

| 首頁 Hero & 導覽指示 | 生涯成長時間線 | 發行作品檔案庫 |
|:---:|:---:|:---:|
| ![首頁介面](docs/screenshots/01_home.png) | ![時間線篩選](docs/screenshots/02_timeline.png) | ![作品庫](docs/screenshots/03_releases.png) |
| *午夜紫漸層與 Liquid Glass 膠囊列* | *2010s / 2020s 複合年代篩選* | *10 張正式專輯與橫向滑動卡片* |

| 串流平台直達 (Apple/Spotify) | 專輯曲目與快速選單 | 經典錄音版本對照 |
|:---:|:---:|:---:|
| ![串流平台直達](docs/screenshots/04_streaming.png) | ![專輯曲目清單](docs/screenshots/05_tracklist.png) | ![版本對照](docs/screenshots/06_versions.png) |
| *三合一官方串流線上收聽入口* | *單曲一鍵展開「串流」收聽選單* | *《泡沫》等跨時期重錄版本對照* |

| 《I AM GLORIA》巡演地圖 | 本地持久化收藏清單 | 深淺色主題對比 (Light/Dark) |
|:---:|:---:|:---:|
| ![巡演互動地圖](docs/screenshots/07_tour_map.png) | ![收藏管理頁面](docs/screenshots/08_favorites.png) | ![深淺色模式對比](docs/screenshots/09_dark_light.png) |
| *MapKit 標記與自適應相機鏡頭* | *支援左滑刪除與重啟持久化保存* | *午夜紫暗色與晨曦珍珠白亮色模式* |

---

## 核心功能特色 (Key Features)

- **Liquid Glass 動態導覽指示**：
  頂部導覽膠囊列採用 iOS 原生 `.glassEffect`。透過高效能 `.onGeometryChange` 自動計算畫面滾動位置，以半透明小方塊即時高亮當前瀏覽章節（人物 / 成長 / 作品 / 舞台 / 巡演），點擊時平滑自動置頂滾動。
- **跨平台串流線上收聽 (Streaming Integration)**：
  在歌曲或專輯內頁，無縫整合 **Apple Music**、**Spotify** 與 **YouTube Music** 直達連結與智慧搜尋回退機制；專輯曲目列表中為每首歌曲配置快捷串流選單，點選即可立刻開聽。
- **立體化生涯成長時間線**：
  收錄 18 件關鍵歷史事件，支援依年代（2010s 起步與突破、2020s 自立自省）與維度（音樂創作、大型舞台、個人生活）複合交叉篩選，同年多事件完整並存。
- **深度作品檔案庫與錄音版本對照**：
  收錄 10 張發行專輯與 14 首經典曲目。獨家設計「同一首歌，不同時期」對照區塊（例如《泡沫》早期錄音與全新重唱版），完整解析創作背景與音樂演進。
- **《I AM GLORIA》巡演互動地圖**：
  整合 MapKit 框架呈現重點巡迴城市與場館公佈檔案，支援城市按鈕切換、場館卡片浮現、全景概覽重置與跳轉 Apple Maps 導航。
- **完整收藏系統 (Favorites & Persistence)**：
  任一歷史事件、專輯或單曲皆可一鍵收藏。資料透過 `UserDefaults` 本地持久化保存，支援跨頁面狀態即時雙向同步，在收藏總覽頁更支援 iOS 原生左滑取消收藏操作。
- **無障礙輔助與強健離線體驗**：
  完整支援 **VoiceOver 螢幕朗讀**、**動態字級排版（Dynamic Type）**、**減少動態效果（Reduce Motion）**。本機打包完整結構化 JSON 與真實授權肖像，在無網路離線狀態下所有文字、圖片與搜尋功能皆可流暢運作。

---

## 專案架構目錄 (Architecture)

```text
GEM_BeyondTheVoice/
├── SwiftUI/                        # SwiftUI 介面與功能模組
│   ├── GEMAboutApp.swift           # App 入口點與全域 Environment 注入
│   ├── GEMAboutView.swift          # 首頁骨幹、Liquid Glass 動態指示導覽列
│   ├── GEMHeroView.swift           # 開場大型 Hero 視覺與幾何切割寫真
│   ├── GEMSections.swift           # 人物簡介、時間線、發行卡片、代表舞台區塊
│   ├── GEMDetailView.swift         # 檔案詳細資料頁面、串流收聽入口、錄音版本對照
│   ├── GEMExploreViews.swift       # 全域跨維度搜尋頁、自訂分類收藏管理頁
│   ├── GEMTourMapSection.swift     # MapKit 巡演地圖區塊、城市標記與相機互動
│   ├── GEMTourComponents.swift     # 巡演地圖自訂卡片與控制面板
│   ├── GEMTourModels.swift         # 巡演地圖資料結構與精選城市座標
│   ├── GEMComponents.swift         # 通用元件庫（卡片、行、收藏按鈕、串流面板）
│   ├── GEMStageCutShape.swift      # 自訂 Shape 幾何舞台菱形斜角切割
│   ├── GEMTheme.swift              # 深淺色調色盤 (GEMPalette) 與字體 (GEMFont)
│   ├── GEMModels.swift             # 核心資料模型（Entry、Date、Link、串流 Enum）
│   └── GEMLibrary.swift            # 核心商業邏輯（篩選、搜尋、收藏持久化）
├── Content/                        # 結構化資料與授權署名
│   ├── gem-catalog.json            # 完整生涯、發行作品、曲目與歷史事件 JSON
│   ├── artwork-map.json            # 封面圖像對應表
│   └── media-credits.json          # 圖片攝影作者與 CC 授權詳細署名
├── font/                           # 隨 App 打包之開源字型
│   ├── Sora-ExtraBold.ttf          # 標題與數字英文字型
│   └── NotoSansTC-*.ttf            # 繁體中文字型（Regular / Bold）
├── Config/                         # 系統配置與隱私權宣告
│   ├── Info.plist                  # 包含 UIAppFonts 字型註冊
│   └── PrivacyInfo.xcprivacy       # 現代化隱私清單 Manifest
├── GEM_BeyondTheVoiceTests/        # 完整 XCTest 單元測試套件
└── docs/                           # 深度文件與驗收報告
    ├── ABOUT_PAGE_SHOWCASE.md      # Medium 格式專案技術長文（含完整程式碼精析）
    ├── MAC_ACCEPTANCE.md           # Mac / iOS 驗收審核清單 (100% 依循標準)
    ├── MEDIA_CREDITS.md            # 素材來源、修圖說明與授權聲明
    └── CONTENT_SOURCES.md          # 53 項事實核對來源總表
```

---

## 素材授權與免責聲明 (Disclaimer)

- **藝人照片**：藝人肖像 `gem_portrait` 與舞台寫真 `gem_live` 源自 Wikimedia Commons，作者為**茂木木**，遵循 [CC BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/) 創用 CC 姓名標示-相同方式分享授權。完整修圖說明與原始出處詳見 [`docs/MEDIA_CREDITS.md`](docs/MEDIA_CREDITS.md)。
- **字型資源**：Sora 與 Noto Sans TC 均遵循 SIL Open Font License 1.1 開源授權，字型授權文字存檔於 `font/` 目錄。
- **免責聲明**：本專案為非營利之個人學習與技術探索作品，App 內所有文字、曲目與影視資料均為公開資訊整理；App 本身不內建任何未經授權的音訊串流伺服器，所有收聽與觀看入口皆直接引導至 **Apple Music**、**Spotify** 與 **YouTube** 等官方串流服務。
