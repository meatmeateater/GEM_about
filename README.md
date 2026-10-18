# G.E.M. About
### 原創音樂人物誌 · 作品資料庫 · 巡演地圖 iOS 應用程式

[![iOS Version](https://img.shields.io/badge/iOS-27.0%2B-blue.svg?style=flat-square&logo=apple)](https://developer.apple.com/ios/)
[![Xcode Version](https://img.shields.io/badge/Xcode-27.0%2B-blue.svg?style=flat-square&logo=xcode)](https://developer.apple.com/xcode/)
[![Swift Version](https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat-square&logo=swift)](https://swift.org/)
[![UI Framework](https://img.shields.io/badge/SwiftUI-Liquid%20Glass-purple.svg?style=flat-square)](https://developer.apple.com/xcode/swiftui/)
[![Tests](https://img.shields.io/badge/XCTest-10%20Passed-brightgreen.svg?style=flat-square)](GEM_BeyondTheVoiceTests/)
[![Static Validation](https://img.shields.io/badge/Checks-1840%20Passed-brightgreen.svg?style=flat-square)](scripts/validate_project.py)

---

## 專案簡介 (Overview)

**G.E.M. About** 是一款專為華語樂壇代表性創作天后 **G.E.M. 鄧紫棋（Gloria Tang）** 打造的深度音樂人物誌與探索 App。

不同於常見的單頁式靜態展示，本專案建構了完整的「**事件 → 作品 → 歌曲 → 舞台／版本 → 收藏**」深層關聯鏈路。介面設計融合 iOS 現代 **Liquid Glass（流體玻璃質感）** 與典雅午夜紫、香檳金調色盤，搭配自訂多邊形幾何切角與微動畫，兼顧 **VoiceOver 無障礙旁白**、**動態字級支援** 與 **減少動態效果（Reduce Motion）**。

- **GitHub 專案庫**：[meatmeateater/GEM_about](https://github.com/meatmeateater/GEM_about)
- **技術文件清單**：
  - [素材來源、修圖說明與授權聲明](docs/MEDIA_CREDITS.md)
  - [53 筆事實核對來源總表](docs/CONTENT_SOURCES.md)

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
   基於 MapKit 呈現重點巡迴城市與場館公佈檔案（台北、新加坡、吉隆坡、深圳），具備單一相機動態對焦、城市切換、場館資訊卡浮現與一鍵開啟 Apple Maps 導航功能。
6. **本機持久化收藏系統 (Favorites & Persistence)**：
   任意歷史事件、專輯或單曲皆可一鍵收藏。資料透過 `UserDefaults` 持久化儲存，跨頁面狀態即時雙向同步，總覽頁支援原生左滑取消收藏。
7. **全功能離線與無障礙體驗**：
   打包完整結構化 JSON 與本機寫真，無網路狀態下文字、照片與搜尋完全可用；全面實作 Accessibility Label、Hint，並適應系統 Reduce Motion 設定。

---

## 設計系統 (Design System)

專案嚴格依據 [`SwiftUI/GEMTheme.swift`](SwiftUI/GEMTheme.swift) 中的 `GEMPalette` 與 `GEMFont` 實作：

### 1. 色彩體系 (Color Palette)
- **香檳金焦點色 (`GEMPalette.gold`)**：`#FCD18C`（RGB 0.99, 0.82, 0.55），用於徽章、重點數字、醒目標籤與強調線條。
- **動態自適應紫色 (`GEMPalette.purple`)**：
  - 深色模式：`#C49CFF`（柔和薰衣草紫，RGB 0.77, 0.61, 1.0）
  - 淺色模式：`#632EA6`（深邃高對比紫，RGB 0.39, 0.18, 0.65）
- **電音紫強調色 (`GEMPalette.violet`)**：`#7040D4`（RGB 0.44, 0.25, 0.83）。
- **動態背景漸層 (`GEMPalette.background(dark:)`)**：
  - 深色漸層（3 階）：`#0F0B1B` → `#1D1132` → `#0E0B1B`（午夜暗紫深邃背景）
  - 淺色漸層（3 階）：`#FBF8FE` → `#F3EBFA` → `#FDF9FB`（柔和晨曦珍珠白背景）
- **卡片與內容容器 (`GEMPalette.card(for:)`)**：
  - 深色模式：`#291D3C`（次級午夜紫面板）
  - 淺色模式：`.white`（純淨白色卡片）
- **文字階層 (`GEMPalette.foreground(for:)` / `secondary(for:)`)**：
  - 主文字：深色 `.white`，淺色 `#291A38`
  - 次要文字：深色 `#BFB3D1`，淺色 `#6B5C7A`
- **表面材質 (Surface)**：iOS 原生 Liquid Glass 模糊材質搭配半透明膠囊造型。

### 2. 字型系統 (Typography)
- **英文與數字標題**：`Sora-ExtraBold`（透過 `GEMFont.display` 套用，展現現代音樂力量感與律動感）
- **中文粗體標題**：`NotoSansTC-Bold`（透過 `GEMFont.headline` 套用）
- **中文內文與標籤**：`NotoSansTC-Regular`（透過 `GEMFont.body` 套用，確保繁體中文排版閱讀舒適性）

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
├── docs/                           # 相關文件
│   ├── MEDIA_CREDITS.md            # 素材來源、修圖說明與授權聲明
│   └── CONTENT_SOURCES.md          # 53 項事實核對來源總表
│   
└── scripts/                        # 工程維護與驗證自動化腳本
    ├── apply_artwork.py            # 線上封面中繼資料對應
    ├── package_release.py          # 發行封裝打包工具
    ├── update_xcode_project.py     # Xcode 專案檔案引用與設定安全檢查工具
    └── validate_project.py         # 離線靜態完整性檢查腳本
```

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

# 2. 檢查 Xcode 專案檔案完整性（預設安全檢查模式，不修改磁碟）
python3 scripts/update_xcode_project.py

# 3. 建置 Xcode 專案 (Build)
xcodebuild build \
  -project GEM_BeyondTheVoice.xcodeproj \
  -scheme GEM_BeyondTheVoice \
  -destination 'platform=iOS Simulator,name=iPhone 17'

# 4. 執行 XCTest 單元測試套件 (Test)
xcodebuild test \
  -project GEM_BeyondTheVoice.xcodeproj \
  -scheme GEM_BeyondTheVoice \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

---

## 誌謝與聲明 (Acknowledgments & Disclaimer)

- **音樂主題**：致敬華語樂壇卓越創作歌手 **G.E.M. 鄧紫棋** 與其團隊創作之經典音樂篇章。
- **免責聲明**：本專案為非營利性質之大專院校 iOS SwiftUI 程式設計作業與技術研究作品。專案內收錄之所有文字、歌曲資訊與影音資料均為公開資訊整理；本 App 不內建任何音訊串流伺服器，所有收聽與觀看入口皆直接連結至官方合法串流平台。
