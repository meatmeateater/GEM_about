# 圖片與字型署名

核對日期：2026-10-17。兩張真實人物照片的原始圖像隨專案打包，可離線讀取。App「資料來源與素材」亦提供作者、來源與授權入口。攝影者與藝術家均未因此為本 App 背書。

| Asset | 作品與拍攝資訊 | 作者 | 來源與授權 | 本次修改 |
|---|---|---|---|---|
| `gem_portrait` | G.E.M. 鄧紫棋《I AM GLORIA》世界巡迴演唱會寫真；5,160 × 2,582 | 待確認（報導配圖／官方宣傳照） | [am730 報導頁](https://www.am730.com.hk/article/593879) · 授權：**待確認（非開放授權）** | 原始檔經縮放、局部裁切、GEMStageCutShape 自訂幾何遮罩與漸層呈現。版權屬原攝影者或所屬版權方所有。**注意：非 CC 開放授權，本專案僅供課堂作業與個人技術研究展示；若需公開發布或商業利用，必須取得原版權方授權。** |
| `gem_live` | Gem Tang Singing with Piano 2，2014-05-24，武漢 XXX Live；3,845 × 2,297 | 茂木木 | [Commons 檔案頁](https://commons.wikimedia.org/wiki/File:Gem_Tang_Singing_with_Piano_2.jpg) · [原始 JPEG](https://upload.wikimedia.org/wikipedia/commons/0/01/Gem_Tang_Singing_with_Piano_2.jpg) · [CC BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/) | 原始檔未改；介面依版型縮放、裁切、圓角或形狀遮罩，可能加覆漸層。由此產生的圖片呈現改作亦採 CC BY-SA 3.0。 |

> [!WARNING]
> `gem_portrait` 採用 2025 年《I AM GLORIA》巡演相關寫真，來源為新聞報導配圖，非 Wikimedia Commons 開放授權，不可將舊照片的作者與 CC BY-SA 授權直接套用。公開展示或發布前應審慎評估版權風險。

## 遠端專輯封面

`Content/artwork-map.json` 記錄十件發行作品的封面 URL 與對應官方發行/串流頁面，供內容資料引用與署名。2026-10-15 已核對頁面實際圖片標籤或 metadata，並以 HTTP HEAD 確認十個圖片 URL 回傳 200 與 image 類型。沒有把封面二進位檔加入 Assets。

| 作品 | 圖像來源 |
|---|---|
| G.E.M. EP | [Spotify 發行頁](https://open.spotify.com/album/3Kz3xJzl7gTIiL7u111dCW)，2008、5 首、640 × 640 圖片 metadata |
| 18... | [Apple Music](https://music.apple.com/us/album/18/6775749474)，正文 srcset 的 632 × 632 封面 |
| MySecret | [Apple Music](https://music.apple.com/us/album/mysecret/6776100461)，正文 srcset 的 632 × 632 封面 |
| Xposed | [Apple Music](https://music.apple.com/us/album/xposed/6775778892)，正文 srcset 的 632 × 632 封面 |
| 新的心跳 | [Apple Music](https://music.apple.com/us/album/heartbeat/1053567923)，正文 srcset 的 632 × 632 封面 |
| 摩天動物園 | [Sony Music](https://www.sonymusic.com.tw/album/g-e-m-city-zoo/)，專輯頁的 Sony CDN 圖片 |
| 啟示錄 | [藝術家官方頁](https://www.iamgem.com/qishilu/)，正文發行封面 `qishilu-fan.jpg` |
| Revelación | [藝術家官方頁](https://www.iamgem.com/revelacion/)，正文發行封面 `Revelacion-scaled.jpg` |
| T.I.M.E. | [藝術家官方頁](https://www.iamgem.com/time/)，正文發行封面 `T.I.M.E.繁.jpg` |
| I AM GLORIA | [Sony Music](https://www.sonymusic.com.tw/album/i-am-gloria/)，專輯頁的 Sony CDN 圖片 |

封面版權屬各權利人；這些圖像沒有 Commons 照片的 CC 授權。App 透過遠端 URL 顯示並使用 URLSession 的 HTTP 快取，離線/載入失敗時用文字與幾何圖像替代；是否留在快取由伺服器回應與系統決定，不承諾首次離線可取得。

## 字型

沿用專案已有的三個字型二進位檔，補齊 Xcode Resources 引用及官方授權文字。

| 檔案 | 字型 | 授權文字 | 官方來源 |
|---|---|---|---|
| `Sora-ExtraBold.ttf` | Sora ExtraBold | `font/Sora-OFL.txt`，SIL Open Font License 1.1 | [Sora 原始專案](https://github.com/sora-xor/sora-font) · [Google Fonts 授權](https://github.com/google/fonts/blob/main/ofl/sora/OFL.txt) |
| `NotoSansTC-Regular.ttf`、`NotoSansTC-Bold.ttf` | Noto Sans TC Regular / Bold | `font/NotoSansTC-OFL.txt`，SIL Open Font License 1.1 | [Noto CJK 原始專案](https://github.com/notofonts/noto-cjk) · [Google Fonts 授權](https://github.com/google/fonts/blob/main/ofl/notosanstc/OFL.txt) |

## 隱私宣告依據

`Config/PrivacyInfo.xcprivacy` 宣告 `NSPrivacyAccessedAPICategoryUserDefaults`、原因 `CA92.1`。用途為此 App 自身的主題偏好與本機收藏，不做追蹤、不傳出收藏紀錄。[Apple：Required reason API](https://developer.apple.com/documentation/bundleresources/app-privacy-configuration/nsprivacyaccessedapitypes/nsprivacyaccessedapitype)、[Apple：TN3183](https://developer.apple.com/documentation/technotes/tn3183-adding-required-reason-api-entries-to-your-privacy-manifest)。
