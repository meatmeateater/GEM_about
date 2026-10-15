# v2 實作交付對照

2026-10-15。依使用者補充，平台從企畫原定 iOS 17 改成 iOS 27，要求含 iOS 27 SDK 的 Xcode 27。App identity 維持既有專案，Swift language mode 維持 5。

| 企畫項目 | 已寫入程式與內容 | 驗證範圍 |
|---|---|---|
| 人物介紹 | 具體生涯概要、三條閱讀入口、Hero 進入站內故事 | 讀碼與內容來源檢查；排版待 Mac |
| 互動時間線 | 18 事件、分類、年代跳轉、詳情、前後事件與相關作品 | 資料 ID／關聯靜態檢查，另有 XCTest；操作待 Mac |
| 發行作品與曲目 | 10 發行、對應數位／實體版說明、曲目、歌曲連結 | 條目／曲序／引用靜態檢查；來源範圍另記 |
| 歌曲與版本 | 14 歌曲、版本清單、所屬發行與官方連結 | 關聯及型別檢查；外開播放由官方平台提供 |
| 節目舞台 | 2 節目、6 舞台，角色、場合與官方影片 | 一手來源逐筆整理，連線／地區可播放性待實機 |
| 搜尋與收藏 | 跨類型關鍵字、繁簡／大小寫／寬度正規化、分類、本機持久儲存、原生 swipe 移除 | 含獨立 XCTest，尚未在 Windows 執行 XCTest |
| 巡演 | 保留 Map／Marker／Annotation；概覽與選取一致、單一鏡頭觸發、動態站數、空資料替代 | 座標靜態檢查；地圖與 Apple Maps 待 Mac |
| 素材 | 兩張有署名的真實授權照片、官方遠端封面與文字替代 | 原圖目視及檔案完整性，未驗證原生畫面 |
| 美術／動畫 | 紫金色、淺色模式較深文字紫、完整封面、原生玻璃按鈕、收藏回饋、Reduce Motion | Swift 文法／讀碼檢查；實際動畫與無障礙待裝置 |
| 工程基礎 | 資源引用、TTF、OFL、Privacy manifest、XCTest target、shared scheme | 專案引用與 plist 靜態核對；Xcode build 待 Mac |

## 檔案責任

- `GEMModels.swift`：可編碼內容、穩定 ID、日期精度、路由與目錄關聯驗證。
- `GEMLibrary.swift`：內容載入、搜尋、分類排序與本機收藏儲存。
- `GEMAboutView.swift`／`GEMSections.swift`／`GEMHeroView.swift`：主頁與章節導覽。
- `GEMExploreViews.swift`：時間線、作品庫、搜尋、收藏與獨立導覽／收藏控制。
- `GEMDetailView.swift`：正文、導讀、資料、曲目、版本、關聯與來源。
- `GEMComponents.swift`：共用作品圖像、原生封面快取、連結、篩選與空狀態。
- `GEMTour*.swift`：精選巡演公告、城市選取與場館操作。
- `Content/`：本機文字目錄、素材署名與封面來源索引。
- `GEM_BeyondTheVoiceTests/`：目錄、搜尋、時間線、持久收藏、資源與座標的 XCTest。

## 驗收證據界線

此工作環境沒有 Swift compiler、macOS／iOS SDK、Xcode 或 Simulator。Tree-sitter 只檢查 Swift 文法，不能辨識 Apple API 是否可用、泛型推導是否成功或 actor isolation 是否通過。獨立讀碼有修正這些風險，但不取代 Xcode type-check。

使用者先前提供的成功 build 是修改前版本的證據；本版的 Xcode build、XCTest、字型註冊、排版、VoiceOver、Reduce Motion 與原生滑動操作結果，需照 `MAC_ACCEPTANCE.md` 執行後填入。

原企畫中的真人素材已以有署名的 CC 照片落地。獨立粉絲走讀、Simulator 錄影與真實 Keynote 繪圖存證，仍需在對應環境完成，不能由本輪靜態檢查推定通過。
