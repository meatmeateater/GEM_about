import SwiftUI

struct GEMAboutView: View {
    @AppStorage("gemUsesDarkMode") private var usesDarkMode = true
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack {
            GEMPalette.background(dark: usesDarkMode)
                .ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    GEMHeroView()

                    VStack(alignment: .leading, spacing: 42) {
                        GEMIntroSection()
                        GEMJourneySection()
                        GEMTourMapSection()
                        GEMDiscographySection()
                        GEMTracksSection()
                        GEMConnectSection()
                    }
                    .padding(.horizontal, 21)
                    .padding(.top, 10)
                    .padding(.bottom, 36)
                }
                .frame(maxWidth: 740)
                .frame(maxWidth: .infinity)
            }
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            navigationBar
        }
        .preferredColorScheme(usesDarkMode ? .dark : .light)
    }

    private var navigationBar: some View {
        HStack(spacing: 9) {
            Image(systemName: "waveform")
                .font(.system(size: 19, weight: .semibold))
                .foregroundStyle(GEMPalette.purple)

            Text("G.E.M. / ABOUT")
                .font(GEMFont.display(12))
                .tracking(1.2)
                .foregroundStyle(GEMPalette.foreground(for: colorScheme))

            Spacer()

            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    usesDarkMode.toggle()
                }
            } label: {
                Image(systemName: usesDarkMode ? "sun.max.fill" : "moon.stars.fill")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(GEMPalette.foreground(for: colorScheme))
                    .frame(width: 38, height: 38)
                    .background(GEMPalette.purple.opacity(0.12), in: Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(usesDarkMode ? "切換為一般模式" : "切換為深色模式")
        }
        .padding(.horizontal, 21)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
    }
}

#Preview("Dark") {
    GEMAboutView()
        .preferredColorScheme(.dark)
}
