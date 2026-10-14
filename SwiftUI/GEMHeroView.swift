import SwiftUI

struct GEMHeroView: View {
    private let officialWebsite = URL(string: "https://www.iamgem.com/")!

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            GeometryReader { geometry in
                Image("gem_hero")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            }

            LinearGradient(
                stops: [
                    .init(color: .black.opacity(0.12), location: 0),
                    .init(color: Color(red: 0.11, green: 0.04, blue: 0.23).opacity(0.31), location: 0.38),
                    .init(color: Color(red: 0.09, green: 0.03, blue: 0.18).opacity(0.98), location: 1)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            // Editorial / concert-light motif.
            Circle()
                .strokeBorder(.white.opacity(0.16), lineWidth: 1)
                .frame(width: 330, height: 330)
                .offset(x: 166, y: -175)
                .allowsHitTesting(false)

            Circle()
                .strokeBorder(GEMPalette.gold.opacity(0.50), lineWidth: 1)
                .frame(width: 270, height: 270)
                .offset(x: 197, y: -202)
                .allowsHitTesting(false)

            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 9) {
                    Circle()
                        .fill(GEMPalette.gold)
                        .frame(width: 6, height: 6)
                    Text("THE VOICE OF A GENERATION")
                        .font(GEMFont.display(10))
                        .tracking(1.8)
                        .foregroundStyle(GEMPalette.gold)
                }

                Text("G.E.M.")
                    .font(GEMFont.display(66))
                    .tracking(-3)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.25), radius: 10, y: 5)

                Text("鄧 紫 棋")
                    .font(GEMFont.headline(30))
                    .tracking(5)
                    .foregroundStyle(.white)

                Text("BEYOND THE VOICE")
                    .font(GEMFont.display(11))
                    .tracking(2.4)
                    .foregroundStyle(.white.opacity(0.79))
                    .padding(.top, 4)

                Text("不只是聲音，更是一種力量。")
                    .font(GEMFont.body(13))
                    .foregroundStyle(.white.opacity(0.85))
                    .padding(.top, 2)

                Link(destination: officialWebsite) {
                    HStack(spacing: 9) {
                        Text("EXPLORE G.E.M.")
                            .font(GEMFont.display(11))
                            .tracking(1.2)
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 12, weight: .bold))
                    }
                    .foregroundStyle(Color(red: 0.14, green: 0.08, blue: 0.23))
                    .padding(.horizontal, 18)
                    .padding(.vertical, 13)
                    .background(GEMPalette.gold, in: Capsule())
                }
                .padding(.top, 12)
            }
            .padding(.horizontal, 25)
            .padding(.bottom, 75)
        }
        .frame(height: 490)
        .clipShape(GEMStageCutShape())
        .accessibilityLabel("G.E.M. 鄧紫棋，BEYOND THE VOICE 藝人形象視覺")
    }
}
