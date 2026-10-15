# 巡演地圖驗收

本版平台為 iOS 27，使用含 iOS 27 SDK 的 Xcode 27。詳細清單見 `docs/MAC_ACCEPTANCE.md`。

1. 開啟 App，在上方章節列點「巡演」，前往 `06 / TOUR ARCHIVE`。
2. 初始為四座城市概覽，沒有預先選取的城市或場館卡。
3. 點台北自訂 Annotation，確認場館卡出現，台北 chip 選取並聚焦；切換新加坡等 Marker，卡片／chip／鏡頭同步。
4. 拖動地圖後，再點已選城市 chip，也應能重新聚焦。
5. 點概覽按鈕，清除城市選取並返回總覽；確認沒有仍亮著的 chip 或舊場館卡。
6. 點「在 Apple Maps 查看場館」，顯示對應場館位置；點「官方巡演公告」，開啟官方頁面。
7. 點延伸閱讀可進入《I AM GLORIA》作品檔案，並返回地圖。
8. 開啟系統 Reduce Motion，重試選取／重置：內容仍更新，鏡頭不做移動動畫。
9. Light／Dark、大字級與 VoiceOver 下，城市 chip 與概覽按鈕可操作；地圖下的文字卡仍可閱讀。
10. 無網路時，文字、城市與已打包內容仍可讀；不把未載入圖磚宣稱為離線地圖。

資料為 2026 年四座城市的精選官方公告，核對於 2026-10-15，並非完整巡演名單、實際舉行保證或即時售票資訊。

來源：[藝術家官方巡演頁](https://www.iamgem.com/tours/)。場館座標沿用原專案的近似位置。[MapKit for SwiftUI](https://developer.apple.com/documentation/mapkit/mapkit-for-swiftui)

本功能沒有讀取使用者所在位置，不需要定位權限。
