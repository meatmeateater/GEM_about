import SwiftUI
import UIKit

struct GEMHeroView: View {
    @State private var appeared = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Spacer(minLength: 240)
            Text("THE ARTIST. THE SONGS. THE STORY.")
                .font(GEMFont.display(10)).tracking(1.6).foregroundStyle(GEMPalette.gold)
            Text("G.E.M.").font(GEMFont.display(70)).tracking(-3).foregroundStyle(.white)
                .minimumScaleFactor(0.6).lineLimit(1)
            Text("鄧紫棋").font(GEMFont.headline(32)).tracking(5).foregroundStyle(.white)
            Text("從一首歌，走進她的世界。")
                .font(GEMFont.body(17)).foregroundStyle(.white.opacity(0.88)).lineSpacing(4)
            NavigationLink(value: GEMRoute.timeline) {
                HStack(spacing: 12) {
                    Text("走進她的故事").font(GEMFont.headline(15))
                    Image(systemName: "arrow.right")
                }
                .foregroundStyle(Color(red: 0.13, green: 0.06, blue: 0.22))
                .padding(.horizontal, 7).padding(.vertical, 5)
            }.buttonStyle(.glassProminent).tint(GEMPalette.gold).controlSize(.large).padding(.top, 6)
            Text("BEYOND THE VOICE  /  FAN ARCHIVE")
                .font(GEMFont.display(10)).tracking(1.5).foregroundStyle(.white.opacity(0.60)).padding(.top, 10)
        }
        .padding(.horizontal, 28).padding(.top, 26).padding(.bottom, 80)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            ZStack {
                // Background cut shape projecting ambient shadow exclusively along the bottom diagonal stage cut
                GEMStageBottomShadowShape()
                    .fill(Color(red: 0.10, green: 0.04, blue: 0.19))
                    .shadow(
                        color: scheme == .dark
                            ? Color.black.opacity(0.70)
                            : Color(red: 0.25, green: 0.12, blue: 0.38).opacity(0.24),
                        radius: scheme == .dark ? 18 : 22,
                        x: 0,
                        y: 12
                    )

                GeometryReader { geometry in
                    ZStack(alignment: .top) {
                        Color(red: 0.12, green: 0.06, blue: 0.22)
                        if UIImage(named: "gem_portrait") != nil {
                            Image("gem_portrait").resizable().scaledToFill()
                                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
                                .clipped()
                        }
                        LinearGradient(stops: [.init(color: .black.opacity(0.03), location: 0),
                                               .init(color: Color(red: 0.10, green: 0.04, blue: 0.19).opacity(0.42), location: 0.38),
                                               .init(color: Color(red: 0.10, green: 0.04, blue: 0.19), location: 0.88)],
                                       startPoint: .top, endPoint: .bottom)
                    }
                }
                .clipShape(GEMStageCutShape())
            }
        }
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared || reduceMotion ? 0 : 10)
        .onAppear {
            guard !appeared else { return }
            withAnimation(reduceMotion ? nil : .easeOut(duration: 0.5)) { appeared = true }
        }
    }
}
