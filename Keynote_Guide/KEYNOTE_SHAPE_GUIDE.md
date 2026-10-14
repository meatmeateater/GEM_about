# Keynote 自訂裁切形狀｜製作與存證

**注意**：專案內 `GEMStageCutShape.swift` 已使用 SwiftUI `Path` 實作相同頂點，並以 `.clipShape(GEMStageCutShape())` 真正裁切 Hero 和專輯圖。不過，因為 Keynote 是 macOS 軟體，此套件不會虛構「已在 Keynote 繪製」的證明。請在 Mac 上完成以下步驟並拍照存證。

1. 開啟 Keynote，建立空白投影片，新增一個 10 cm × 10 cm 的參考正方形。
2. 選「形狀 → 使用筆繪製」（依 Keynote 版本可能稱「以筆繪圖」）。選擇五個錨點，順時針連接封閉多邊形。
3. 頂點相對於正方形左上角的百分比位置依序為：
   - P1: (0%, 0%)
   - P2: (100%, 0%)
   - P3: (100%, 83%)
   - P4: (38%, 100%)
   - P5: (0%, 90%)
4. 設定形狀填色為紫色、無邊框。截圖 Keynote 的形狀與控制點供課堂驗證。
5. `GEMStageCutShape.swift` 使用 `rect.width` / `rect.height` 乘上這些百分比，把 Keynote 的幾何輪廓重新編寫成 `Path`，最終 `.clipShape(GEMStageCutShape())` 裁切 Hero 圖與專輯封面。

Keynote 形狀不會直接轉成 SwiftUI 的 `Shape` 程式碼；此處是**先定義幾何形狀，再在 SwiftUI 重建**，可向老師解釋轉換方法。
