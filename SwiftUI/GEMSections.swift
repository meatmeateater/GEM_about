import SwiftUI

struct GEMIntroSection: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            GEMSectionHeading(
                eyebrow: "01  /  THE ARTIST",
                title: "讓聲音，成為光。",
                description: "從充滿力量的高音，到細膩真摯的創作，G.E.M. 鄧紫棋用音樂記錄成長，也讓更多人聽見勇氣。"
            )

            HStack(alignment: .top, spacing: 9) {
                GEMStatView(value: "2008", label: "正式出道")
                Rectangle()
                    .fill(GEMPalette.purple.opacity(0.22))
                    .frame(width: 1, height: 45)
                GEMStatView(value: "2022", label: "《啟示錄》")
                Rectangle()
                    .fill(GEMPalette.purple.opacity(0.22))
                    .frame(width: 1, height: 45)
                GEMStatView(value: "2025", label: "《I AM GLORIA》")
            }
            .padding(18)
            .background(GEMPalette.card(for: colorScheme), in: RoundedRectangle(cornerRadius: 22))
        }
    }
}

struct GEMJourneySection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 17) {
            GEMSectionHeading(
                eyebrow: "02  /  THE JOURNEY",
                title: "每一段旅程，都有回聲。",
                description: "她以創作寫下生命的片段，讓音樂不只是旋律，更是一次次真誠的對話。"
            )

            ZStack(alignment: .bottomLeading) {
                GeometryReader { geometry in
                    Image("gem_stage")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                }
                LinearGradient(
                    colors: [.black.opacity(0.08), .black.opacity(0.83)],
                    startPoint: .top,
                    endPoint: .bottom
                )

                VStack(alignment: .leading, spacing: 8) {
                    Image(systemName: "quote.opening")
                        .font(.system(size: 28, weight: .light))
                        .foregroundStyle(GEMPalette.gold)

                    Text("從舞台到心裡，\n每一首歌都是一束光。")
                        .font(GEMFont.headline(23))
                        .foregroundStyle(.white)
                        .lineSpacing(5)

                    Text("THE MUSIC NEVER STOPS")
                        .font(GEMFont.display(10))
                        .tracking(1.6)
                        .foregroundStyle(GEMPalette.gold)
                        .padding(.top, 4)
                }
                .padding(22)
            }
            .frame(height: 285)
            .clipShape(RoundedRectangle(cornerRadius: 22))

            VStack(alignment: .leading, spacing: 0) {
                ForEach(GEMContent.milestones) { milestone in
                    GEMTimelineRow(
                        milestone: milestone,
                        isLast: milestone.id == GEMContent.milestones.last?.id
                    )
                }
            }
            .padding(.top, 5)
        }
    }
}

struct GEMDiscographySection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            GEMSectionHeading(
                eyebrow: "04  /  DISCOGRAPHY",
                title: "值得反覆聆聽的篇章。",
                description: "精選三張具代表性的作品，一起走進她不同階段的音樂世界。左右滑動探索更多。"
            )

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 15) {
                    ForEach(GEMContent.albums) { album in
                        GEMAlbumCard(album: album)
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
}

struct GEMTracksSection: View {
    private let spotify = URL(string: "https://open.spotify.com/artist/7aRC4L63dBn3CiLDuWaLSI")!

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            GEMSectionHeading(
                eyebrow: "05  /  ICONIC TRACKS",
                title: "一聽，就認得的聲音。",
                description: "那些陪伴無數人走過青春、深夜與重新出發的旋律。"
            )

            ForEach(GEMContent.tracks) { track in
                GEMTrackRow(track: track)
            }

            Link(destination: spotify) {
                HStack(spacing: 7) {
                    Text("LISTEN ON SPOTIFY")
                        .font(GEMFont.display(11))
                        .tracking(1)
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundStyle(GEMPalette.purple)
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity)
            }
            .padding(.top, 4)
        }
    }
}

struct GEMConnectSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 9) {
                Image(systemName: "sparkles")
                    .foregroundStyle(GEMPalette.gold)
                Text("06  /  CONNECT")
                    .font(GEMFont.display(11))
                    .tracking(1.7)
                    .foregroundStyle(GEMPalette.gold)
            }

            Text("THE STORY\nCONTINUES.")
                .font(GEMFont.display(32))
                .foregroundStyle(.white)
                .lineSpacing(3)

            Text("音樂還在繼續。下一段故事，一起聆聽。")
                .font(GEMFont.body(13))
                .foregroundStyle(.white.opacity(0.82))

            // This literal Markdown text creates genuinely tappable links in SwiftUI.
            Text("前往 [G.E.M. 官方網站](https://www.iamgem.com/) 探索更多，或透過 [Spotify](https://open.spotify.com/artist/7aRC4L63dBn3CiLDuWaLSI) 聆聽她的作品。")
                .font(GEMFont.body(13))
                .foregroundStyle(.white.opacity(0.90))
                .tint(GEMPalette.gold)
                .lineSpacing(7)
                .fixedSize(horizontal: false, vertical: true)

            Rectangle()
                .fill(.white.opacity(0.19))
                .frame(height: 1)
                .padding(.top, 3)

            HStack {
                Text("G.E.M.  ·  BEYOND THE VOICE")
                    .font(GEMFont.display(9))
                    .tracking(1.0)
                Spacer()
                Image(systemName: "heart.fill")
                    .font(.system(size: 11))
            }
            .foregroundStyle(.white.opacity(0.64))
        }
        .padding(25)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.37, green: 0.20, blue: 0.66),
                                 Color(red: 0.12, green: 0.06, blue: 0.26)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
        .overlay {
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(GEMPalette.purple.opacity(0.35), lineWidth: 1)
        }
    }
}
