# 新版地圖功能快速檢查

1. 使用 Xcode 15+ 開啟 `GEM_BeyondTheVoice.xcodeproj`，部署目標 iOS 17+。
2. 在 `SwiftUI/GEMAboutView.swift` 確認 Journey 與 Discography 中間已加入 `GEMTourMapSection()`。
3. 向下捲動到 `03 / WORLD TOUR`；可見 4 座巡演城市的 Apple Map。
4. 點選非台北城市的 Marker：地圖鏡頭移動、城市 Chip 與 Detail Card 同步更新。
5. 點選台北的紫金 G.E.M. Annotation、城市 Chip，確認互動一致。
6. 點右上角縮放圖示回到亞洲地圖概覽。
7. 按 APPLE MAPS，跳到對應場館位置；按 OFFICIAL TOUR，跳官方場次頁。
8. 切換右上角日/月圖示，檢查 Dark / Light 模式的背景、卡片、標籤顏色。

### 專案檔案

- `GEMTourModels.swift` — 自訂行程資料與場館座標
- `GEMTourComponents.swift` — 可重用的紫金 Annotation、城市 Chip、Detail Card
- `GEMTourMapSection.swift` — MapKit 地圖、Marker/Annotation、互動、鏡頭動畫

### 資料查證

巡演場館日期： https://www.iamgem.com/tours/

MapKit SwiftUI API： https://developer.apple.com/documentation/mapkit/mapkit-for-swiftui

註：所有場次在 2026-10-14 之前，定位為歷史巡演回顧，而非訂票頁。
