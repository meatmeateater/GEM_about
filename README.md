# G.E.M. — BEYOND THE VOICE

以鄧紫棋的成長、作品和舞台為主題的 SwiftUI 粉絲音樂檔案。沿用午夜紫／香檳金，從 About 首頁探索「事件 → 作品 → 歌曲 → 舞台／版本 → 收藏」。

## 開啟與執行

1. 在 **含 iOS 27 SDK 的 Xcode 27** 開啟 `GEM_BeyondTheVoice.xcodeproj`。App 與測試的最低部署目標都是 **iOS／iPadOS 27.0**，Swift language mode 維持 5。
2. 選擇 `GEM_BeyondTheVoice` shared scheme 與 iOS 27 Simulator。真機執行時，在 Signing & Capabilities 選自己的 Team。
3. 按 `⌘R`。資料、兩張署名照片與三個自訂字型會隨 App 打包，無須重新拖入 Xcode。
4. 按 `⌘U` 執行已加入的 XCTest target。具體驗收流程見 [Mac 驗收清單](docs/MAC_ACCEPTANCE.md)。

本次修改在 Windows 完成。已執行的檢查與未執行的 Mac 驗收分別記錄於 [驗證紀錄](docs/VALIDATION.md)；靜態檢查不等於 Xcode build 或 XCTest 執行成功。

## 可以探索什麼

- **成長時間線**：18 個事件，依年代快速跳轉、依類型篩選，同年可保留不同故事。
- **發行作品**：10 張專輯／EP／重錄發行，含版本說明、曲目與相關歌曲入口。
- **歌曲**：14 首歌曲檔案，包含〈泡沫〉、〈我的秘密〉等不同時期的版本對照。
- **節目與舞台**：2 個節目、6 件舞台精選；參與身分、歌曲和官方影片分開整理。
- **搜尋**：跨事件、作品、歌曲、節目和舞台搜尋；支援繁簡中文、英文字大小寫、全半形及多個關鍵字。
- **收藏**：每份檔案可收藏／取消；本機保存，重開仍在。收藏頁可依類型篩選，也可向左滑動取消。
- **巡演地圖**：四座精選城市的官方公告，城市按鈕／標記、鏡頭、場館卡和概覽重置同步。這是公告檔案，不是完整場次清單或即時售票服務。
- **來源與署名**：每則詳情附來源及核對日期；編輯導讀與已查證資料分開。

內容是精選檔案，資料核對日期為 2026-10-15。完整來源與編輯範圍見 [CONTENT_SOURCES.md](docs/CONTENT_SOURCES.md)。

## iOS 27 與原生介面

- `AsyncImage(request:)` 與 `asyncImageURLSession(_:)`：使用遵守伺服器 HTTP cache header 的封面快取，設定快取容量和逾時；不承諾所有遠端圖片都能離線顯示。
- `swipeActionsContainer()`：讓收藏頁的 ScrollView 支援原生取消收藏操作；獨立心形按鈕仍保留。
- 長文與檔案欄位使用 `textSelection(.enabled)`，使用 iOS 27 原生互動選取。
- 主按鈕、章節列與地圖控制採原生 Liquid Glass；其他卡片保留紫金色的閱讀層次。
- 互動微動畫與一次性 Hero 淡入；開啟 Reduce Motion 時停用位移、彈跳及地圖鏡頭動畫。

API 核對：[SwiftUI 更新](https://developer.apple.com/documentation/updates/swiftui)、[AsyncImage](https://developer.apple.com/documentation/swiftui/asyncimage)、[iOS 27 release notes](https://developer.apple.com/documentation/ios-ipados-release-notes/ios-ipados-27-release-notes)。新 SDK 的實際建置與手勢行為仍需在 Mac 驗收。

## 圖片、封面與字型

`gem_portrait`、`gem_live` 使用 Wikimedia Commons 作者茂木木的 CC BY-SA 3.0 照片，皆為 2014-05-24 武漢 XXX Live，不當作其他演出照片。原始 JPEG 保留；介面的裁切、遮罩與漸層呈現已記錄在署名中。[照片與授權](docs/MEDIA_CREDITS.md)

發行作品封面使用正式來源的遠端網址，完整比例顯示；失敗或未提供時呈現作品名稱與年份的文字設計，仍可查看詳情及官方入口。原版抽象素材留在 Assets 作為歷史設計檔，新的作品卡不將其當成官方封面。

字型隨 App 打包：Sora ExtraBold、Noto Sans TC Regular／Bold。`font/` 內附 SIL OFL 授權。`Info.plist`、資源引用與 PostScript 名稱由靜態檢查核對，實際註冊另由 XCTest／Mac 驗收確認。

## 維護與驗證

核心內容在 `Content/gem-catalog.json`；署名在 `Content/media-credits.json`。新增條目使用穩定 ID，日期可只填年份，不要以排序序號或年份作唯一 ID。

```sh
python3 scripts/apply_artwork.py
python3 scripts/update_xcode_project.py
python3 scripts/validate_project.py
```

第一個指令依封面來源索引更新作品圖像與出處；第二個更新 Xcode 檔案引用，保留 App 身分並補上測試、JSON、字型與 Privacy manifest；第三個檢查資料關聯、日期、連結格式、資源、project 與 Swift 文法。Swift 文法檢查需另外安裝 `tree-sitter`、`tree-sitter-swift`，或使用 `--syntax-deps` 指向現有套件；沒有時會明確列為跳過。

## 原作業十項對照

| # | 要求 | 展示位置 |
|---|---|---|
| 1 | VStack／HStack／ZStack／Text／Image／ScrollView | 首頁、探索頁與詳情 |
| 2 | Asset + SF Symbol | 真實照片、分類與操作圖示 |
| 3 | 多種 modifier | 字型、間距、背景、裁切、動態與玻璃材質 |
| 4 | 上下捲動 | About 首頁與詳情 |
| 5 | 多檔 View | `SwiftUI/` 各功能檔 |
| 6 | View property 客製化 | `GEMEntryRow(entry:)`、`GEMReleaseCard(entry:)`、城市卡 |
| 7 | Light／Dark | 首頁右上角切換，所有內頁沿用 |
| 8 | Text + Markdown 連結 | 頁尾官方網站／Spotify 文字連結 |
| 9 | 自訂字型 | Sora／Noto Sans TC，真實 TTF 已加入 Resources |
| 10 | Keynote Shape／SwiftUI 裁切 | Hero／舞台保留 `GEMStageCutShape`；真正 Keynote 檔與繪圖存證需依 [指南](Keynote_Guide/KEYNOTE_SHAPE_GUIDE.md) 在 Mac 完成 |

此為非官方粉絲作品，沒有 App 內音樂播放功能；聆聽與觀看會進入相應官方平台。
