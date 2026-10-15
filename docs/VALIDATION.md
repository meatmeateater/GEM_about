# v2 驗證紀錄

日期：2026-10-15。工作環境：Windows PowerShell；Python 3；沒有 Swift compiler、Apple SDK、Xcode 或 iOS Simulator。

## 已執行

```text
python scripts/apply_artwork.py
Applied 10 verified release covers; 12 contemporary song covers.

python scripts/update_xcode_project.py
Updated Xcode membership: 14 app Swift, 1 XCTest, 10 resources.

python scripts/validate_project.py
Content: event=18, program=2, release=10, stage=6, track=14 sources=53
Project: 14 App Swift files, 1 XCTest files, 10 resources, shared scheme.
Resources: 3 font PostScript names, 7 asset images, 2 attributed photos, valid privacy plist.
Swift syntax: Tree-sitter parsed 15 files. This does not type-check Apple frameworks.
Static validation: 1859 checks, 0 failures, 0 optional skips.
```

原始檢查輸出見 `static-validation.txt`。53 筆來源包含 43 筆文字／作品來源及 10 筆封面出處。

上述 1,859 項是靜態檢查斷言，包含資料必填、穩定 ID、日期、關聯、曲目順序、來源／版本引用、HTTPS 格式、Xcode 檔案與 target／scheme 引用、TTF PostScript 名稱、圖片解碼與授權、Privacy manifest 以及 Swift 文法。它們不是 1,859 次 iOS runtime 測試。

十張封面由官方發行頁的圖片標籤／metadata 取得，核對其對應作品；圖片網址以 HTTP HEAD 確認 image 類型。人物與舞台原始 JPEG 已目視確認。這只確認素材，不代表 App 的原生排版或遠端圖片載入已經在 iPhone 驗收。

## 獨立讀碼後的修正

- 繁簡搜尋改用實際存在的 `StringTransform(rawValue: "Simplified-Traditional")`，避免引用不存在的靜態成員。
- 年份先轉字串，避免 SwiftUI 本地化整數插值加入千分位。
- 使用者於執行中切換 Reduce Motion 時，收藏圖示也移除 symbol effects。
- Hero 只裁切照片背景，避免大字級下把互動內容裁掉。
- 地圖重置清除選取；點同一城市可重新聚焦；鏡頭只由一處更新。
- 專輯曲號與 MV 章節、歌曲本體與重錄版本分開；同期歌曲封面不借用較晚重錄版冒充原版。
- 字型與 XCTest 檔案真正納入 Xcode Resources／測試 target。

## iOS 27 API 核對

以下依 Apple 官方文件核對宣告與可用版本，不代表已通過 Swift type-check。

| API | 使用位置 | 官方文件 |
|---|---|---|
| `AsyncImage(request:scale:transaction:content:)` | `GEMComponents.swift`，iOS 27 請求快取與逾時 | [Apple](https://developer.apple.com/documentation/swiftui/asyncimage) |
| `asyncImageURLSession(_:)` | `GEMComponents.swift`，指定封面快取 session | [Apple](https://developer.apple.com/documentation/swiftui/view/asyncimageurlsession(_:)) |
| `swipeActionsContainer()` | `GEMExploreViews.swift`，收藏 ScrollView 原生滑動 | [Apple](https://developer.apple.com/documentation/swiftui/view/swipeactionscontainer()) |
| `textSelection(.enabled)` | 內頁、人物介紹與場館資訊 | [iOS 27 release notes](https://developer.apple.com/documentation/ios-ipados-release-notes/ios-ipados-27-release-notes) |
| `glassProminent`／`glassEffect` | 主按鈕、章節列及地圖控制；既有 iOS 26+ 能力 | [Apple](https://developer.apple.com/documentation/swiftui/glassprominentbuttonstyle) |
| `MKMapItem(location:address:)`／`openInMaps(launchOptions:)` | iOS 26+ Map item 建構及外開 Apple Maps | [Apple](https://developer.apple.com/documentation/mapkit/mkmapitem) |

平台依使用者要求設為 iOS／iPadOS 27.0，App 與 test target 一致，版本 2.0（build 2）。Swift language mode 保留 5；沒有加入必須付費或登入的第三方套件。

## 尚未執行

- Xcode build 與 Apple framework 型別／可用性檢查。
- 已加入測試 target 的 9 個 XCTest 方法。
- Simulator／iPhone 的排版、照片構圖、字型註冊、原生滑動、文字選取、導航返回位置與動畫。
- VoiceOver、大字級、Reduce Motion、Light／Dark 與低速／離線網路驗收。
- 真實 Keynote `.key` 檔與形狀編輯存證、獨立粉絲走讀及操作錄影。

以上以 `MAC_ACCEPTANCE.md` 為後續驗收依據。修改前使用者已成功 build；本版不沿用該結果宣稱建置成功。
