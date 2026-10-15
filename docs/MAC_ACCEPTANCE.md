# Mac / iPhone 驗收表

驗收基準：2026-10-15；本版依使用者指定，最低 **iOS 27.0**，使用 **Xcode 27 或更新且含 iOS 27 SDK**，Swift language mode 維持 5。保留 `GEM_BeyondTheVoice` App target 與原 bundle identifier。Xcode 專案採可由新 Xcode 讀取的既有專案格式。

## 目前證據

Windows 可以執行 `python3 scripts/validate_project.py`，檢查內容結構、ID、關聯、日期精度、Xcode 資源引用、plist、字型內部名稱與圖片；安裝 `tree-sitter`、`tree-sitter-swift` 後另可解析 Swift 文法。

**這些檢查不等於 Xcode build、Swift 型別檢查、XCTest 執行、Simulator 或 iPhone 驗收。下列項目在 Mac 完成前皆為待驗收。** 使用者先前成功 build 的是改版前版本，不能直接當成本次結果。

## 建置與測試

1. 開啟 `GEM_BeyondTheVoice.xcodeproj`，選取 shared scheme `GEM_BeyondTheVoice`。
2. 確認 Xcode 版本、iOS 27 SDK 與 iOS 27 Simulator 已安裝。若 Xcode 預設選在 Command Line Tools，先到 Xcode Settings → Locations 選取該版工具。
3. 選 iOS 27 iPhone Simulator，執行 Product → Build（⌘B），再 Test（⌘U）。Test navigator 應出現 `GEM_BeyondTheVoiceTests`。
4. iPhone 實機執行時，於 App / Test targets 選擇自己的 Signing Team。Simulator 不需要先改原 bundle identifier。
5. 每次新增 `SwiftUI/*.swift`、`Content/*.json` 或字型資源後，先執行 `python3 scripts/update_xcode_project.py` 更新 membership，再開 Xcode；這個腳本不是 build 工具。

也可在專案根目錄的 Terminal 執行：

```sh
xcodebuild -version
xcodebuild -showsdks
xcrun simctl list devices available
```

將下方 `SIMULATOR_UDID` 換成上一步列出的 iOS 27 iPhone UUID，再執行：

```sh
xcodebuild -project GEM_BeyondTheVoice.xcodeproj \
  -scheme GEM_BeyondTheVoice \
  -destination 'platform=iOS Simulator,id=SIMULATOR_UDID' \
  -resultBundlePath TestResults.xcresult test
```

`TestResults.xcresult` 若已存在，改用新的輸出名稱保留前次證據。記錄 Xcode 版本、SDK、Simulator/裝置名稱與 OS、完整結果及失敗訊息。

| 自動測試範圍 | 通過條件 | 結果 |
|---|---|---|
| 打包內容與關聯 | App bundle 真正載入 JSON；每個類型有內容、ID 唯一，曲目/錄音版本的目標類型正確 | 待執行 |
| 資料錯誤 | 重複 ID、失效內容關聯、失效來源關聯被拒絕 | 待執行 |
| 同年事件 | 兩件 2014 事件同時保留，分類與年代可組合篩選 | 待執行 |
| 搜尋 | 繁簡、大小寫、全形、重音、空白與多詞搜尋，類型篩選和無結果正確 | 待執行 |
| 收藏持久化 | 加入、重建 store、取消後再重建，資料正確；未知 ID 不新增 | 待執行 |
| 日期精度 | 只知道年份時不顯示虛構月日，年份/月/日排序正確 | 待執行 |
| 外部連結 | 拒絕 HTTP、非網址與無 host 的 HTTPS | 待執行 |
| 資源註冊 | 兩張真實圖片可載入；三個自訂 UIFont 可註冊；圖片署名 JSON 可載入 | 待執行 |
| 巡演地圖 | 精選站點 ID 與經緯度有效，概覽涵蓋所有站點 | 待執行 |

## 操作與閱讀

| 任務 | 成功條件 | 結果 |
|---|---|---|
| 首頁導覽 | Hero 進入成長故事；人物、成長、作品、舞台、巡演快捷可到正確段落 | 待驗收 |
| 同年時間線 | 找到 2023 多件事件；依年代、類別篩選仍能點進每個故事 | 待驗收 |
| 連續探索 | 從事件 → 作品 → 歌曲 → 舞台/版本，再返回；沒有重複 NavigationStack 或錯誤內容 | 待驗收 |
| 作品與曲目 | 作品類型/年份可辨認，曲目資料可讀，有詳情的曲目能進入正確歌曲 | 待驗收 |
| 版本對照 | 〈泡沫〉早期/重錄資訊分別指向正確發行，編輯導讀與可查證資料分開 | 待驗收 |
| 節目角色 | 至少兩個節目的年份、季別、參與身分清楚，節目能連到舞台或來源 | 待驗收 |
| 搜尋 | 搜尋「泡沫」、「光年之外」、「GLORIA」、「邓紫棋」；類型和結果數正確，結果可進詳情 | 待驗收 |
| 找不到結果 | 顯示可理解的空狀態，可清除條件繼續探索 | 待驗收 |
| 收藏獨立操作 | 點愛心不觸發卡片導覽；首頁/內頁/收藏頁狀態同步；iOS 27 收藏列滑動操作可取消正確項目 | 待驗收 |
| 收藏重開 | 收藏至少一件事件、作品和歌曲，強制結束 App 再開仍保留；取消後重開仍移除 | 待驗收 |
| 外部連結 | 來源、官方聆聽和觀看入口開啟正確頁；受限或無網路時仍可讀本機說明 | 待驗收 |
| 地圖 | 切換城市、重置概覽、Marker / Annotation、Apple Maps 入口均合理；未把精選站點當作完整行程 | 待驗收 |
| 素材署名 | 來源頁能看到茂木木、兩張 2014 武漢照片、CC BY-SA 3.0、修改說明與連結 | 待驗收 |
| 離線 | 開飛航模式後，本機文字、兩張照片、搜尋和收藏可操作；遠端封面有文字/幾何替代 | 待驗收 |
| 錯誤處理 | 若開發者暫移 JSON，載入錯誤顯示替代畫面，不閃退；驗收後還原資源 | 待驗收 |

## 視覺、動態與無障礙

至少使用一台最小可用 iOS 27 iPhone、一般尺寸 iPhone 及 iPad Simulator。另在一台實際 iPhone 完成核心閱讀路徑。

| 項目 | 通過條件 | 結果 |
|---|---|---|
| Light / Dark | 系統與 App 切換後，首頁、內頁、篩選列、來源及收藏的文字皆可讀 | 待驗收 |
| 中文與長標題 | 作品名不被不必要截斷，專輯圖維持正方形，照片人臉不被不合理裁切 | 待驗收 |
| 動態字級 | 一般到 Accessibility 最大字級無卡片文字遮擋，按鈕可到達，水平列可捲動 | 待驗收 |
| VoiceOver | 類型、標題、年份與收藏狀態可辨識；裝飾圖不重複朗讀，來源連結有名稱 | 待驗收 |
| Reduce Motion | 開系統「減少動態效果」，Hero 位移、收藏彈跳與地圖鏡頭大幅移動停止，操作結果仍清楚 | 待驗收 |
| 文字選取 | iOS 27 原生文字選取不妨礙卡片與來源導覽 | 待驗收 |
| Glass 工具列 | 真機上的透明層級與對比可讀，捲動時不蓋住關鍵內容 | 待驗收 |
| 圖片網路狀態 | iOS 27 `AsyncImage(request:)` / `.asyncImageURLSession` 的自訂 URLSession 可讀遠端封面；初次載入、慢速網路及失敗狀態有替代畫面，返回不出現嚴重跳動 | 待驗收 |
| 點擊回饋 | 卡片、分類、收藏有一致回饋；減少動態時不影響可用性 | 待驗收 |
| 字型 | Sora 顯示英文標題、Noto Sans TC 顯示中文，XCTest 的 UIFont 檢查通過 | 待驗收 |

## 作業與交付證據

- [ ] 原十項要求在 README 的對照位置逐一展示。
- [ ] `GEMStageCutShape` 的裁切畫面保留；真實 `.key` 與形狀編輯證據另由 Mac 核對。Swift Shape 不是 `.key` 驗收證據。
- [ ] 保存 build/test 結果和至少 Light / Dark、大字級、時間線、版本詳情、收藏頁截圖。
- [ ] 錄製「事件 → 作品 → 歌曲 → 舞台/版本 → 收藏 → 重開仍保留」短片。
- [ ] 3–5 位使用者走讀，記錄任務是否完成、卡點與看完記得的內容，區分粉絲與首次認識者；不將小樣本推論成所有粉絲滿意度。

驗收人：________　日期：________　Xcode/SDK：________　裝置/OS：________

Build：________　XCTest：________　核心操作：________　已知限制：________
