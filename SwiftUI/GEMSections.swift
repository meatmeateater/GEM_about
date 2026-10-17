import SwiftUI
import UIKit

struct GEMIntroSection: View {
    @Environment(\.colorScheme) private var scheme
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            Text("2025《I AM GLORIA》上海站巡演 ")
                .font(GEMFont.body(11)).foregroundStyle(GEMPalette.secondary(for: scheme))
            GEMSectionHeading(eyebrow: "01 / THE ARTIST", title: "認識歌聲背後的她。",
                              description: "從香港出發的唱作人，也是不斷改變表達方式的舞台表演者。")
            Text("2008 年，她以同名 EP《G.E.M.》展開音樂旅程。從早期粵語作品，到《我是歌手》的現場，再到《摩天動物園》的創作與製作，她的故事可以從許多入口開始。\n\n《啟示錄》讓歌曲走進連續的影像敘事；《I AM GLORIA》則重新詮釋熟悉的旋律。這裡把年代、作品與舞台連在一起，讓你從喜歡的一首歌，慢慢認識不同時期的鄧紫棋。")
                .font(GEMFont.body(16)).lineSpacing(7).foregroundStyle(GEMPalette.foreground(for: scheme))
                .textSelection(.enabled)
            VStack(spacing: 10) {
                GEMReadingPath(title: "從出道開始", subtitle: "沿著年代，看見每一次轉變", symbol: "clock", route: .timeline)
                GEMReadingPath(title: "從一首歌開始", subtitle: "找回熟悉旋律的作品與版本", symbol: "music.note", route: .library(.track))
                GEMReadingPath(title: "從現場開始", subtitle: "從節目與舞台，認識另一面", symbol: "music.mic", route: .library(.stage))
            }
        }
    }
}

private struct GEMReadingPath: View {
    let title: String
    let subtitle: String
    let symbol: String
    let route: GEMRoute
    @Environment(\.colorScheme) private var scheme
    var body: some View {
        NavigationLink(value: route) {
            HStack(spacing: 15) {
                Image(systemName: symbol).font(.system(size: 20, weight: .light))
                    .foregroundStyle(GEMPalette.purple).frame(width: 29)
                VStack(alignment: .leading, spacing: 5) {
                    Text(title).font(GEMFont.headline(17)).foregroundStyle(GEMPalette.foreground(for: scheme))
                    Text(subtitle).font(GEMFont.body(13)).foregroundStyle(GEMPalette.secondary(for: scheme))
                }
                Spacer(minLength: 4)
                Image(systemName: "arrow.up.right").font(.system(size: 13)).foregroundStyle(GEMPalette.purple)
            }.padding(18).frame(maxWidth: .infinity, alignment: .leading)
                .background(GEMPalette.card(for: scheme), in: RoundedRectangle(cornerRadius: 18))
        }.buttonStyle(GEMPressStyle())
    }
}

struct GEMJourneySection: View {
    @EnvironmentObject private var library: GEMLibrary
    @Environment(\.colorScheme) private var scheme
    private var highlights: [GEMEntry] {
        ["event-debut", "event-singer-2014", "event-city-zoo", "event-gma-jury", "event-revelation", "event-i-am-gloria"]
            .compactMap { library.entry(id: $0) }
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            GEMSectionHeading(eyebrow: "02 / THE JOURNEY", title: "沿著時間，聽見改變。",
                              description: "從第一張 EP 到重新詮釋經典，點開一個節點，接著走進當時的作品。")
            VStack(spacing: 0) {
                ForEach(highlights) { event in
                    HStack(alignment: .top, spacing: 15) {
                        VStack(spacing: 8) {
                            Text(String(event.year)).font(GEMFont.display(12)).foregroundStyle(GEMPalette.purple)
                            Circle().fill(GEMPalette.gold).frame(width: 7, height: 7)
                            Rectangle().fill(GEMPalette.purple.opacity(0.2)).frame(width: 1)
                        }.frame(width: 43).padding(.top, 15).accessibilityHidden(true)
                        GEMExplorationRow(entry: event)
                    }.fixedSize(horizontal: false, vertical: true)
                }
            }
            GEMBrowseLink(title: "探索完整成長史 · \(library.entries(of: .event).count) 個節點", route: .timeline)
        }
    }
}

struct GEMDiscographySection: View {
    @EnvironmentObject private var library: GEMLibrary
    private var releases: [GEMEntry] {
        ["release-i-am-gloria", "release-revelation", "release-city-zoo", "release-xposed"]
            .compactMap { library.entry(id: $0) }
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 21) {
            GEMSectionHeading(eyebrow: "03 / DISCOGRAPHY", title: "一張唱片，一個時期。",
                              description: "向左右滑動，從封面走進作品的概念、曲目與創作脈絡。")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 20) {
                    ForEach(releases) { GEMReleaseCard(entry: $0) }
                }.padding(.vertical, 4)
            }
            GEMBrowseLink(title: "瀏覽全部 \(library.entries(of: .release).count) 張發行作品", route: .library(.release))
        }
    }
}

struct GEMTracksSection: View {
    @EnvironmentObject private var library: GEMLibrary
    @Environment(\.colorScheme) private var scheme
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            GEMSectionHeading(eyebrow: "04 / SONGS THROUGH TIME", title: "同一首歌，新的回聲。",
                              description: "從原版到重生版，將不同年份的錄音與舞台放在一起閱讀。")
            if let bubble = library.entry(id: "track-bubble") {
                NavigationLink(value: GEMRoute.entry(bubble.id)) {
                    VStack(alignment: .leading, spacing: 13) {
                        HStack {
                            Text("版本對照").font(GEMFont.body(12)).foregroundStyle(GEMPalette.gold)
                            Spacer()
                            Image(systemName: "arrow.up.right").foregroundStyle(GEMPalette.gold)
                        }
                        Text("泡沫").font(GEMFont.headline(30)).foregroundStyle(.white)
                        Text("2012  →  2025").font(GEMFont.display(19)).foregroundStyle(GEMPalette.gold)
                        Text("回到《Xposed》，再走進《I AM GLORIA》的重生版本。")
                            .font(GEMFont.body(15)).foregroundStyle(.white.opacity(0.85)).lineSpacing(5)
                    }.padding(25).frame(maxWidth: .infinity, alignment: .leading)
                        .background(LinearGradient(colors: [GEMPalette.violet, Color(red: 0.15, green: 0.07, blue: 0.28)],
                                                   startPoint: .topLeading, endPoint: .bottomTrailing),
                                    in: RoundedRectangle(cornerRadius: 23))
                }.buttonStyle(GEMPressStyle())
            }
            ForEach(["track-free-to-be-you", "track-light-years-away", "track-my-secret"].compactMap { library.entry(id: $0) }) { entry in
                GEMExplorationRow(entry: entry)
            }
            GEMBrowseLink(title: "探索全部歌曲", route: .library(.track))
        }
    }
}

struct GEMStageSection: View {
    @EnvironmentObject private var library: GEMLibrary
    @Environment(\.colorScheme) private var scheme
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            GEMSectionHeading(eyebrow: "05 / ON STAGE", title: "在現場，遇見另一面。",
                              description: "有時是一首翻唱，有時是一次合作。從節目角色，再聽回歌曲。")
            if UIImage(named: "gem_live") != nil {
                VStack(alignment: .leading, spacing: 8) {
                    Image("gem_live").resizable().scaledToFit()
                        .clipShape(GEMStageCutShape())
                        .accessibilityLabel("鄧紫棋於 2014 年武漢演出彈奏鋼琴")
                    Text("2014 武漢演出 · 茂木木 / CC BY-SA 3.0")
                        .font(GEMFont.body(11)).foregroundStyle(GEMPalette.secondary(for: scheme))
                }
            }
            ForEach(library.entries(of: .program)) { program in GEMExplorationRow(entry: program) }
            GEMBrowseLink(title: "探索重要舞台", route: .library(.stage))
        }
    }
}

struct GEMHomeFavoritesSection: View {
    @EnvironmentObject private var library: GEMLibrary
    @Environment(\.colorScheme) private var scheme
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            GEMSectionHeading(eyebrow: "07 / YOUR COLLECTION", title: "留下想再聽的故事。",
                              description: library.favoriteEntries.isEmpty ? "點擊心形，保存一首歌、一個舞台或一段成長故事。" : "已收藏 \(library.favoriteEntries.count) 則內容，隨時回到喜歡的那一段。")
            ForEach(Array(library.favoriteEntries.prefix(2))) { GEMExplorationRow(entry: $0) }
            GEMBrowseLink(title: "我的收藏", route: .favorites)
        }
    }
}

struct GEMConnectSection: View {
    @EnvironmentObject private var library: GEMLibrary
    var body: some View {
        VStack(alignment: .leading, spacing: 19) {
            Text("THE STORY\nCONTINUES.").font(GEMFont.display(34)).foregroundStyle(.white)
            Text("從這裡出發，接著聽她自己的聲音。")
                .font(GEMFont.body(16)).foregroundStyle(.white.opacity(0.85))
            Text("前往 [G.E.M. 官方網站](https://www.iamgem.com/) 探索更多，或透過 [Spotify](https://open.spotify.com/artist/7aRC4L63dBn3CiLDuWaLSI) 聆聽她的作品。")
                .font(GEMFont.body(15)).foregroundStyle(.white.opacity(0.9)).tint(GEMPalette.gold).lineSpacing(6)
            NavigationLink(value: GEMRoute.sources) {
                Label("資料來源與影像署名", systemImage: "text.book.closed")
                    .font(GEMFont.body(14)).foregroundStyle(GEMPalette.gold).frame(minHeight: 44)
            }
            Divider().overlay(.white.opacity(0.2))
            Text("粉絲製作的音樂檔案 · 非官方 App\n內容核對：\(library.catalog.updatedAt)")
                .font(GEMFont.body(12)).foregroundStyle(.white.opacity(0.65)).lineSpacing(4)
        }
        .padding(26).frame(maxWidth: .infinity, alignment: .leading)
        .background(LinearGradient(colors: [Color(red: 0.31, green: 0.16, blue: 0.49), Color(red: 0.12, green: 0.06, blue: 0.24)],
                                   startPoint: .topLeading, endPoint: .bottomTrailing),
                    in: RoundedRectangle(cornerRadius: 25))
    }
}

private struct GEMBrowseLink: View {
    let title: String
    let route: GEMRoute
    var body: some View {
        NavigationLink(value: route) {
            HStack(spacing: 12) {
                Text(title).font(GEMFont.headline(15))
                Spacer(minLength: 8)
                Image(systemName: "arrow.right").font(.system(size: 14))
            }
            .padding(.vertical, 14).foregroundStyle(GEMPalette.purple)
        }.buttonStyle(GEMPressStyle())
    }
}

struct GEMSourcesView: View {
    @EnvironmentObject private var library: GEMLibrary
    @Environment(\.colorScheme) private var scheme
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                GEMSectionHeading(eyebrow: "CREDITS & REFERENCES", title: "每段故事，都有來處。",
                                  description: "人物與作品資料依下列來源整理；「編輯導讀」是本站的閱讀觀點。內容核對於 \(library.catalog.updatedAt)。")
                VStack(alignment: .leading, spacing: 16) {
                    Text("影像署名").font(GEMFont.headline(23))
                    ForEach(library.mediaCredits) { credit in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(credit.title).font(GEMFont.headline(17))
                            Text("攝影：\(credit.author) · \(credit.license)").font(GEMFont.body(14))
                            Text(credit.modifications).font(GEMFont.body(13)).foregroundStyle(GEMPalette.secondary(for: scheme))
                            GEMExternalLink(link: GEMLink(label: "原始照片與作者", url: credit.sourceURL))
                            GEMExternalLink(link: GEMLink(label: "\(credit.license) 授權條款", url: credit.licenseURL))
                        }.padding(18).background(GEMPalette.card(for: scheme), in: RoundedRectangle(cornerRadius: 18))
                    }
                    Text("發行作品圖像由相應官方網站或音樂平台載入，權利屬各權利人。封面未載入時以作品名稱與年份呈現，仍可閱讀內容與開啟官方頁面。")
                        .font(GEMFont.body(14)).lineSpacing(5).foregroundStyle(GEMPalette.secondary(for: scheme))
                }
                Text("內容來源").font(GEMFont.headline(23))
                GEMSourceList(sourceIDs: library.catalog.sources.map(\.id))
                Text("文字使用 Noto Sans TC，英文標題使用 Sora；字型授權隨專案附於 font 資料夾。")
                    .font(GEMFont.body(13)).foregroundStyle(GEMPalette.secondary(for: scheme))
            }.foregroundStyle(GEMPalette.foreground(for: scheme))
                .padding(22).frame(maxWidth: 740).frame(maxWidth: .infinity)
        }.background { GEMScreenBackground() }.navigationTitle("來源與署名").navigationBarTitleDisplayMode(.inline)
    }
}
