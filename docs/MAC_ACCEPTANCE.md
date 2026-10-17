# Mac / iPhone 驗收表

驗收基準：2026-10-17；本版依使用者指定，最低 **iOS 27.0**，使用 **Xcode 27 或更新且含 iOS 27 SDK**，Swift language mode 維持 5。保留 `GEM_BeyondTheVoice` App target 與原 bundle identifier `com.example.GEMBeyondTheVoice`。

## 目前驗收證據與執行結果

### 1. 本地靜態驗證 (`python3 scripts/validate_project.py`)
- **執行結果**：1,840 項檢查全部通過（0 failures, 2 optional skips）。
- **涵蓋內容**：目錄資料結構、穩定 ID、日期精度、跨條目關聯、HTTPS 外部連結、Xcode Resources 引用、Info.plist 與字型 PostScript 名稱、PrivacyInfo.xcprivacy 宣告、素材完整性與署名。

### 2. Xcode 27 + iOS 27 Simulator 實測
- **Xcode 版本**：Xcode 27.0 (Build 27A266a)
- **SDK**：iOS 27.0 SDK
- **測試模擬器**：iPhone 17 (Simulator UUID: `53425D64-AD65-49EC-AA6B-919380085B03`)
- **Build 結果**：`** BUILD SUCCEEDED **`
- **XCTest 執行結果**：**10 tests passed, 0 failures (`** TEST SUCCEEDED **`)**

| 自動測試項目 | 測試涵蓋目標 | 本地自動化測試結果 |
|---|---|:---:|
| 打包內容與關聯 | App bundle 載入 JSON，各類型 ID 唯一，關聯正常 | **通過 (Passed)** |
| 資料防錯檢查 | 重複 ID、失效內容與來源關聯正確被拒絕 | **通過 (Passed)** |
| 同年事件排序 | 2014 等同年事件正常呈現，分類與年代篩選運作 | **通過 (Passed)** |
| 搜尋引擎正規化 | 繁簡、大小寫、全形、重音、多詞搜尋與類型過濾 | **通過 (Passed)** |
| 收藏持久化儲存 | 新增、重建 store、取消後再重開，資料完整保持 | **通過 (Passed)** |
| 日期精度不虛構 | 僅年份時不虛構月日，年代與日期排序正確 | **通過 (Passed)** |
| 外部連結格式 | 拒絕非 HTTPS 或無 host 之無效外部 URL | **通過 (Passed)** |
| 資源與字型註冊 | 兩張真實圖片可載入；Sora / Noto Sans TC 可註冊 | **通過 (Passed)** |
| 巡演地圖站點 | 站點經緯度有效，地圖邊界正確包覆所有巡演城市 | **通過 (Passed)** |
| 串流平台安全網址 | Apple Music / Spotify / YouTube Music 網址有效 | **通過 (Passed)** |

## 人工操作與視覺體驗驗收（待本機走讀）

| 任務 / 檢驗項目 | 成功條件 | 驗收狀態 |
|---|---|:---:|
| 首頁導覽與章節捷徑 | Hero 進入成長故事；人物、作品、舞台、巡演捷徑直達正確段落 | 待手動走讀 |
| 連續探索體驗 | 從事件 → 作品 → 歌曲 → 舞台/版本，無重複 NavigationStack | 待手動走讀 |
| 作品與曲目詳情 | 作品年份與串流入口可見，曲目列表可點擊進入歌曲 | 待手動走讀 |
| 歌曲版本對照 | 〈泡沫〉早期與重錄版本對照清楚，編輯導讀與客觀事實分離 | 待手動走讀 |
| 巡演地圖操作 | 城市切換流暢、單一相機焦點、可直接開啟 Apple Maps | 待手動走讀 |
| 本機離線體驗 | 飛航模式下文字、本機圖片、搜尋與收藏皆可正常運作 | 待手動走讀 |
| Light / Dark 模式 | 淺色/深色主題下文字對比清楚，紫金色層次自然 | 待手動截圖 |
| Dynamic Type 動態字級 | 放大至輔助使用字級時卡片文字不重疊，水平列可正常滑動 | 待手動走讀 |
| VoiceOver 旁白 | 圖片有精準無障礙標籤，裝飾元素不重複朗讀，按鈕具備名稱 | 待手動走讀 |
| Reduce Motion 減弱動態 | 啟用系統減弱動態時，禁用劇烈相機移動與彈跳效果 | 待手動走讀 |

## 交付附件與留存指引

- [x] **XCTest 完整結果**：10 項單元測試全數在 iOS 27 Simulator 通過。
- [x] **素材與版權核對**：`gem_portrait` 更新為 2025 巡演寫真並標註版權風險；`gem_live` 註明 CC BY-SA 3.0。
- [ ] **作業展示截圖**：於 Mac 本機截取 6~9 張 iPhone 介面畫面（待使用者截取）。
- [ ] **Keynote 原檔**：需使用 Mac Keynote 軟體匯出 `.key` 檔案（參照 `Keynote_Guide/` 幾何說明）。
- [ ] **操作走讀短片**：錄製從首頁到收藏之 30 秒流暢操作影片（待使用者錄製）。
