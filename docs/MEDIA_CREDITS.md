# 圖片與字型署名

核對日期：2026-10-15。兩張真實人物照片的原始 JPEG 隨專案打包，可離線讀取。App「資料來源與素材」亦應提供作者、來源與授權入口。攝影者與藝術家均未因此為本 App 背書。

| Asset | 作品與拍攝資訊 | 作者 | 來源與授權 | 本次修改 |
|---|---|---|---|---|
| `gem_portrait` | Gem Tang Singing，2014-05-24，武漢 XXX Live；2,483 × 3,229 | 茂木木 | [Commons 檔案頁](https://commons.wikimedia.org/wiki/File:Gem_Tang_Singing.jpg) · [原始 JPEG](https://upload.wikimedia.org/wikipedia/commons/7/76/Gem_Tang_Singing.jpg) · [CC BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/) | 原始檔未改；介面依版型縮放、裁切、圓角或形狀遮罩，可能加覆漸層。由此產生的圖片呈現改作亦採 CC BY-SA 3.0。 |
| `gem_live` | Gem Tang Singing with Piano 2，2014-05-24，武漢 XXX Live；3,845 × 2,297 | 茂木木 | [Commons 檔案頁](https://commons.wikimedia.org/wiki/File:Gem_Tang_Singing_with_Piano_2.jpg) · [原始 JPEG](https://upload.wikimedia.org/wikipedia/commons/0/01/Gem_Tang_Singing_with_Piano_2.jpg) · [CC BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/) | 原始檔未改；介面依版型縮放、裁切、圓角或形狀遮罩，可能加覆漸層。由此產生的圖片呈現改作亦採 CC BY-SA 3.0。 |

CC BY-SA 3.0 適用於上述照片及其圖片改作。App 原始程式碼與其他素材的授權需依各自檔案判定。若分享截圖或重新使用照片，請一併保留作者、檔案頁、授權連結及修改說明。

專輯的幾何圖案若保留，僅是本專案的編輯視覺，不能標示為官方唱片封面。兩張照片均為同一場 2014 現場，不能當作其他年份舞台的紀錄照片。

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

封面版權屬各權利人；這些圖像沒有 Commons 照片的 CC 授權。App 透過遠端 URL 顯示並使用 URLSession 的 HTTP 快取，離線/載入失敗時用文字與幾何圖像替代；是否留在快取由伺服器回應與系統決定，不承諾首次離線可取得。Apple Music 使用實際 square srcset，未誤用 1200 × 630 的社群預覽；iamgem 的 `og:image` 是通用官網 banner，因此改取正文封面。

## 字型

沿用專案已有的三個字型二進位檔，這次補齊 Xcode Resources 引用及官方授權文字。

| 檔案 | 字型 | 授權文字 | 官方來源 |
|---|---|---|---|
| `Sora-ExtraBold.ttf` | Sora ExtraBold | `font/Sora-OFL.txt`，SIL Open Font License 1.1 | [Sora 原始專案](https://github.com/sora-xor/sora-font) · [Google Fonts 授權](https://github.com/google/fonts/blob/main/ofl/sora/OFL.txt) |
| `NotoSansTC-Regular.ttf`、`NotoSansTC-Bold.ttf` | Noto Sans TC Regular / Bold | `font/NotoSansTC-OFL.txt`，SIL Open Font License 1.1 | [Noto CJK 原始專案](https://github.com/notofonts/noto-cjk) · [Google Fonts 授權](https://github.com/google/fonts/blob/main/ofl/notosanstc/OFL.txt) |

靜態檢查可讀取 TTF 的 PostScript 名稱並核對程式引用，但真正的 iOS 字型註冊與畫面呈現仍須依 `MAC_ACCEPTANCE.md` 驗證。

## 隱私宣告依據

`Config/PrivacyInfo.xcprivacy` 宣告 `NSPrivacyAccessedAPICategoryUserDefaults`、原因 `CA92.1`。用途為此 App 自己的主題偏好與本機收藏，不做追蹤、不傳出收藏紀錄。[Apple：Required reason API](https://developer.apple.com/documentation/bundleresources/app-privacy-configuration/nsprivacyaccessedapitypes/nsprivacyaccessedapitype)、[Apple：TN3183](https://developer.apple.com/documentation/technotes/tn3183-adding-required-reason-api-entries-to-your-privacy-manifest)。
