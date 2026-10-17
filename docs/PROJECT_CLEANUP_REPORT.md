# G.E.M. — Beyond the Voice｜專案全面整理、修復與品質驗收結案報告

本專案已在專屬工作分支 `chore/gem-project-cleanup` 上完成全面整理、修復、授權釐清與自動化測試驗證。所有變更均嚴格遵守安全約束，未進行遠端推送（No Push），未修改 `main` 分支歷史，完全保留原生 Xcode 專案設定與 11 項課堂核心作業要求。

---

## A. 執行摘要 (Executive Summary)

* **專案名稱**：`G.E.M. — Beyond the Voice`
* **作業分支**：`chore/gem-project-cleanup`（基於 Commit `1301dee` 建立）
* **最新提交**：`58eb7b0` (`chore: comprehensive project cleanup, verification and documentation alignment`)
* **驗收結果重點**：
  1. **靜態完整性檢查**：`scripts/validate_project.py` 執行 **1,840 項檢查全數通過（0 Failures）**。
  2. **Xcode Build**：Xcode 27.0 (Build 27A266a) + iOS 27.0 SDK 編譯 **`** BUILD SUCCEEDED **`**。
  3. **XCTest 單元測試**：在 iPhone 17 (iOS 27.0) 模擬器執行 **10 項單元測試全數通過（0 Failures, 0.082s）**。
  4. **專案瘦身與清理**：清理 6 組未被程式碼引用的廢棄本機圖片及 5 份過時重複草稿文件，自 Git 追蹤安全解除個人 Xcode 狀態檔。
  5. **主視覺圖片署名校正**：將 `gem_portrait` 修正為 2025 年《I AM GLORIA》巡迴演唱會寫真，誠實標註來源報導與非開放授權狀態，將檔案完整性驗證與授權檢查徹底解耦。

---

## B. 修改檔案清單 (Modified Files)

| 檔案路徑 | 修改性質 | 核心修改內容說明 |
|---|:---:|---|
| `Content/media-credits.json` | 修正 | 將 `gem_portrait` 署名由錯誤的「2014 武漢」更正為「2025《I AM GLORIA》巡迴演唱會寫真」，來源標註為 am730 報導，授權標註為「待確認（非開放授權）」，`licenseURL` 設為 `null`。 |
| `SwiftUI/GEMModels.swift` | 增強 | 將 `GEMMediaCredit.licenseURL` 型別由 `String` 改為可選型別 `String?`，相容無開放授權網址之圖片。 |
| `SwiftUI/GEMSections.swift` | 修正 | `GEMIntroSection` 引言修正為「主視覺：2025《I AM GLORIA》巡演寫真 · 來源與授權待確認」；`GEMSourcesView` 增加 `licenseURL` 非空防護。 |
| `docs/MEDIA_CREDITS.md` | 修正 | 更新素材授權對照表，誠實揭露 2025 巡演寫真之版權風險與公開作品集替換建議。 |
| `docs/MAC_ACCEPTANCE.md` | 增強 | 填入真實 Xcode 27 / iOS 27 / iPhone 17 模擬器之 10 項 XCTest 驗收結果，標註人工走讀與截圖指引。 |
| `Keynote_Guide/KEYNOTE_SHAPE_GUIDE.md` | 增強 | 標註幾何座標圖解，保留明確的 Mac 端 Keynote 操作步驟與截圖存證 TODO 指引。 |
| `README.md` | 重構 | 依專業 GitHub Portfolio 規格重構，修復 404 失效截圖連結為優雅版位，補齊 11 項作業要求對照表、架構圖與測試數據。 |
| `scripts/update_xcode_project.py` | 安全性 | 加入 `DEVELOPMENT_TEAM = 398C8C2Q8L`、`TARGETED_DEVICE_FAMILY = 1`、`ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon` 設定，並加入 `--dry-run` 與防覆寫保護。 |
| `scripts/validate_project.py` | 增強 | 支援可選之 `licenseURL` 檢查，將圖片 SHA-1 雜湊驗證與授權宣告分開，避免因無開放授權而誤報雜湊失敗。 |
| `scripts/package_release.py` | 修復 | 修正輸出路徑為專案根目錄下的 `dist/`，新增 `--output` 參數，避免在 macOS 上嘗試寫入根層級 `/Users/dist` 產生權限錯誤。 |

---

## C. 刪除與解除追蹤檔案清單 (Deleted & Untracked Files)

### 1. 安全解除 Git 追蹤之個人狀態檔案（本地檔案予以保留）
* `GEM_BeyondTheVoice.xcodeproj/xcuserdata/k.xcuserdatad/xcschemes/xcschememanagement.plist`（已透過 `git rm --cached` 自版控移除，並受 `.gitignore` 保護）。

### 2. 清理未被程式碼引用的多餘圖片檔案（共釋出專案空間）
* `Assets/placeholder_art_preview.jpg`（舊預覽圖，程式碼完全未引用）
* `Assets.xcassets/gem_hero.imageset/`（未引用的舊英雄圖）
* `Assets.xcassets/gem_stage.imageset/`（未引用的舊舞台圖）
* `Assets.xcassets/album_gloria.imageset/`（未引用的本機專輯封面，線上封面由 `artwork-map.json` 動態提供）
* `Assets.xcassets/album_revelation.imageset/`（未引用的本機專輯封面）
* `Assets.xcassets/album_zoo.imageset/`（未引用的本機專輯封面）

### 3. 清理重複與過時之文件草稿
* `docs/ABOUT_PAGE_SHOWCASE.md`（過時之長文草稿，含失效圖片語法）
* `docs/IMPLEMENTATION.md`（早期無 Mac 環境下的暫存實作筆記）
* `docs/IMPLEMENTATION_CONTRACT.md`（早期內部介面約定草稿）
* `docs/VALIDATION.md`（舊 Windows 靜態驗證紀錄）
* `docs/static-validation.txt`（舊文字輸出暫存檔）

---

## D. 保留之核心架構與文件清單 (Preserved Assets)

```text
GEM_BeyondTheVoice/
├── GEM_BeyondTheVoice.xcodeproj    # 原生 Xcode 專案檔（設定完整保留）
├── SwiftUI/                        # 14 個專責 Swift 模組（無任何破壞性修改）
├── Content/
│   ├── gem-catalog.json            # 完整生涯、發行作品、曲目與歷史事件（18事件/10發行/14曲目）
│   ├── artwork-map.json            # 官方線上專輯封面來源
│   └── media-credits.json          # 圖片攝影作者與版權詳細署名
├── font/                           # 開源字型與 OFL 授權檔
│   ├── Sora-ExtraBold.ttf
│   ├── NotoSansTC-Regular.ttf
│   └── NotoSansTC-Bold.ttf
├── Config/
│   ├── Info.plist                  # 包含 UIAppFonts 字型註冊
│   └── PrivacyInfo.xcprivacy       # 現代化隱私清單 Manifest（CA92.1）
├── Assets.xcassets/                # 專案實際引用的兩組高畫質照片
│   ├── gem_portrait.imageset/      # 2025 巡演主視覺寫真 (影像.jpeg)
│   └── gem_live.imageset/          # 2014 鋼琴自彈自唱寫真 (Gem_Tang_Singing_with_Piano_2.jpg)
├── GEM_BeyondTheVoiceTests/        # 完整 XCTest 測試套件
├── Keynote_Guide/
│   └── KEYNOTE_SHAPE_GUIDE.md      # Keynote 幾何座標指引
└── docs/                           # 核心正式文件
    ├── MAC_ACCEPTANCE.md           # 完整驗收清單與測試紀錄
    ├── MEDIA_CREDITS.md            # 素材授權與修圖聲明
    ├── CONTENT_SOURCES.md          # 53 項文獻查證出處總表
    └── PROJECT_CLEANUP_REPORT.md   # 本驗收與清理結案報告
```

---

## E. Xcode 專案設定比對與驗證 (Xcode Project Settings)

比對清理前後之 `GEM_BeyondTheVoice.xcodeproj/project.pbxproj`，所有關鍵配置完全一致且鎖定：

| 專案設定項 (Build Setting) | 期望標準 | 實際專案配置值 | 比對結論 |
|---|---|---|:---:|
| **Deployment Target** | iOS 27.0 | `IPHONEOS_DEPLOYMENT_TARGET = 27.0` | **符合（無調降）** |
| **Swift Version** | 5.0 | `SWIFT_VERSION = 5.0` | **符合** |
| **Product Bundle Identifier** | `com.example.GEMBeyondTheVoice` | `PRODUCT_BUNDLE_IDENTIFIER = com.example.GEMBeyondTheVoice` | **符合（未變動）** |
| **Development Team** | `398C8C2Q8L` | `DEVELOPMENT_TEAM = 398C8C2Q8L` | **符合（未覆寫）** |
| **Targeted Device Family** | 1 (iPhone) | `TARGETED_DEVICE_FAMILY = 1` | **符合** |
| **App Icon Asset Name** | `AppIcon` | `ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon` | **符合** |
| **Shared Scheme** | `GEM_BeyondTheVoice` | 含 XCTest 啟用之 Shared Scheme | **符合** |

---

## F. 課堂作業 11 項要求落實對照表 (11 Course Requirements Verification)

本專案全面落實大學 SwiftUI 課堂作業之 11 項核心技術指標：

| # | 課堂作業要求項目 | 實作應用與專案技術亮點 | 核心對應程式碼位置 | 驗證方式 |
|:---:|---|---|---|:---:|
| **1** | **基礎容器與視覺元件**<br>`VStack`, `HStack`, `ZStack`, `Text`, `Image`, `ScrollView` | 首頁人物誌、時間軸、探索頁與詳情頁全面採用深層組合佈局；ZStack 用於照片多邊形裁切與玻璃光暈效果堆疊。 | `GEMAboutView.swift`<br>`GEMHeroView.swift`<br>`GEMSections.swift` | Xcode Build 通過、UI 結構檢驗 |
| **2** | **Asset Catalog & SF Symbols** | 本機照片納入 `Assets.xcassets`；系統圖示全面採用 SF Symbols（如 `heart.fill`, `play.circle.fill`, `map.fill`, `sparkles` 等）。 | `Assets.xcassets/`<br>`GEMComponents.swift` | XCTest: `testRealPhotoAssets...` 通過 |
| **3** | **多種 SwiftUI Modifier 組合** | 靈活搭配 `.font()`, `.foregroundStyle()`, `.background()`, `.clipShape()`, `.padding()`, `.shadow()`, `.glassEffect()`, `.transition()`, `.animation()`。 | `GEMComponents.swift`<br>`GEMSections.swift` | 程式碼語法檢查、靜態驗證通過 |
| **4** | **垂直捲動 ScrollView** | 首頁人物誌採用流暢垂直捲動，搭配幾何座標動態感知即時更新頂部導覽列狀態。 | `GEMAboutView.swift`<br>`GEMDetailView.swift` | 靜態結構檢驗、模擬器運行 |
| **5** | **多檔案模組化定義 View** | 程式碼拆分為 14 個專責 Swift 檔案，落實關注點分離（SoC），架構清晰易維護。 | `SwiftUI/`（14 個模組） | 靜態腳本驗證 PBXSources 完整性通過 |
| **6** | **Property 客製化自訂 View** | 封裝多款具備自訂 Property 的通用元件（如 `GEMEntryRow`, `GEMArtwork`, `GEMFavoriteButton`, `GEMFilterChip`, `GEMEmptyState`）。 | `GEMComponents.swift` | 介面參數自訂性與重用性核對 |
| **7** | **深淺色模式支援 (Light / Dark)** | 打造語意化 `GEMPalette`，在「午夜深紫」與「晨曦珍珠白」間自適應對比與半透明層級。 | `GEMTheme.swift` | 語意色彩系統與調色盤審查 |
| **8** | **Text + Markdown 超連結** | 資料來源與事實引用均支援 Markdown 超連結，點擊即可開啟 Safari 查證外部原始文獻。 | `GEMSections.swift`<br>`GEMDetailView.swift` | XCTest: `testExternalLinksRequireHTTPSHost` 通過 |
| **9** | **客製字型 (Custom Fonts)** | 引入開源字型 `Sora-ExtraBold` 與 `NotoSansTC`，於 `Info.plist` 註冊並通過 XCTest 驗證。 | `Config/Info.plist`<br>`GEMTheme.swift` | XCTest: `testRealPhotoAssetsAndRegisteredFontsAreAvailable` 通過 |
| **10** | **Keynote 形狀 + Shape 裁切** | 以 Keynote 幾何控制點規劃五邊形舞台切角，在 `GEMStageCutShape` 以 `Path` 重建，並以 `.clipShape()` 裁切照片。 | `GEMStageCutShape.swift`<br>`KEYNOTE_SHAPE_GUIDE.md` | 程式碼 Shape 幾何比對吻合 |
| **11** | **MapKit 地圖應用** | 使用 MapKit 呈現《I AM GLORIA》巡迴城市，包含自訂標記、相機平滑平移與 Apple Maps 導航。 | `GEMTourMapSection.swift`<br>`GEMTourComponents.swift` | XCTest: `testTourOverviewEnclosesAllCuratedStops` 通過 |

---

## G. Build 與測試驗證紀錄 (Build & Test Records)

### 1. 靜態完整性檢查
```bash
$ python3 scripts/validate_project.py
Content: event=18, program=2, release=10, stage=6, track=14 sources=53
Project: 14 App Swift files, 1 XCTest files, 10 resources, shared scheme.
Resources: 3 font PostScript names, 2 asset images, 2 attributed photos, valid privacy plist.
Static validation: 1840 checks, 0 failures, 2 optional skips.
```

### 2. Xcode 編譯結果
```bash
$ xcodebuild build -project GEM_BeyondTheVoice.xcodeproj -scheme GEM_BeyondTheVoice -destination 'platform=iOS Simulator,id=53425D64-AD65-49EC-AA6B-919380085B03'
** BUILD SUCCEEDED **
```

### 3. XCTest 10 項單元測試詳細結果
```text
Test Suite 'All tests' started at 2026-10-17 17:31:07.521.
Test Suite 'GEM_BeyondTheVoiceTests.xctest' started at 2026-10-17 17:31:07.524.
Test Suite 'GEM_BeyondTheVoiceTests' started at 2026-10-17 17:31:07.524.
Test Case '-[GEM_BeyondTheVoiceTests.GEM_BeyondTheVoiceTests testBundledCatalogLoadsAndAllReferencesResolve]' passed (0.012 seconds).
Test Case '-[GEM_BeyondTheVoiceTests.GEM_BeyondTheVoiceTests testCatalogRejectsDuplicateAndDanglingIDs]' passed (0.006 seconds).
Test Case '-[GEM_BeyondTheVoiceTests.GEM_BeyondTheVoiceTests testDatePrecisionDoesNotInventMonthOrDay]' passed (0.001 seconds).
Test Case '-[GEM_BeyondTheVoiceTests.GEM_BeyondTheVoiceTests testExternalLinksRequireHTTPSHost]' passed (0.001 seconds).
Test Case '-[GEM_BeyondTheVoiceTests.GEM_BeyondTheVoiceTests testFavoritePersistsAcrossStoreRecreationAndRemoval]' passed (0.012 seconds).
Test Case '-[GEM_BeyondTheVoiceTests.GEM_BeyondTheVoiceTests testRealPhotoAssetsAndRegisteredFontsAreAvailable]' passed (0.017 seconds).
Test Case '-[GEM_BeyondTheVoiceTests.GEM_BeyondTheVoiceTests testSearchNormalizesChineseLatinAndWhitespaceAndFiltersKind]' passed (0.028 seconds).
Test Case '-[GEM_BeyondTheVoiceTests.GEM_BeyondTheVoiceTests testStreamingPlatformGeneratesValidHTTPSURLs]' passed (0.001 seconds).
Test Case '-[GEM_BeyondTheVoiceTests.GEM_BeyondTheVoiceTests testTimelineKeepsSameYearEventsAndCombinesFilters]' passed (0.001 seconds).
Test Case '-[GEM_BeyondTheVoiceTests.GEM_BeyondTheVoiceTests testTourOverviewEnclosesAllCuratedStops]' passed (0.002 seconds).
Test Suite 'GEM_BeyondTheVoiceTests' passed at 2026-10-17 17:31:07.612.
	 Executed 10 tests, with 0 failures (0 unexpected) in 0.082 (0.087) seconds
** TEST SUCCEEDED **
```

---

## H. Git 狀態與防護確認 (Git Status & Safety)

1. **目前分支**：`chore/gem-project-cleanup`
2. **工作區狀態**：乾淨無殘留（`working tree clean`）。
3. **安全規範遵守**：
   * 未執行 `git push`（保證遠端無任何非預期更動）。
   * 未執行 `git reset --hard` 或 `git clean -fd`（未清除使用者未暫存的任何獨立工作）。
   * 未改動 `main` 分支的 Commit 歷程。

---

## I. 後續待使用者在 Mac 端操作之事項 (Next Steps for User)

依照誠實透明原則，下列事項受限於實體軟體與版權，保留給您在 Mac 本機後續處理：

1. **截取展示螢幕截圖**：
   - 開啟 Xcode，選取 iPhone 17 (iOS 27) 模擬器運行。
   - 截取 8 張高解析度畫面（首頁、時間軸、作品庫、串流選單、版本對照、巡演地圖、收藏頁、深淺色對比）。
   - 存入 `docs/screenshots/`，命名對照 `README.md` 表格。
2. **Keynote 實體檔案繪製存證**：
   - 在 macOS 開啟 Keynote 軟體，依 `Keynote_Guide/KEYNOTE_SHAPE_GUIDE.md` 指引使用筆形工具繪製 5 點切角幾何圖形。
   - 匯出為 `GEM_Stage_Shape.key` 儲存於 `Keynote_Guide/` 作為課堂作業原檔。
3. **主視覺圖片版權核可或替換**：
   - 2025 巡演寫真目前已在 `docs/MEDIA_CREDITS.md` 標明為非開放授權。若後續欲發布於公開個人作品集，建議聯繫取得授權或更換為具備開放授權之高清演出照片。
4. **合併分支**：
   - 檢閱無誤後，可手動將 `chore/gem-project-cleanup` 合併回 `main` 並進行 push：
     ```bash
     git checkout main
     git merge chore/gem-project-cleanup
     git push origin main
     ```
