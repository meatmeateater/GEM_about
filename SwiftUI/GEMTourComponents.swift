import SwiftUI
import MapKit

/// Bespoke purple/gold on-map annotation, visually derived from the page's hero.
struct GEMTourSpotlightPin: View {
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 6) {
                Image(systemName: "waveform")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(GEMPalette.gold)

                Text("G.E.M. / TAIPEI")
                    .font(GEMFont.display(10))
                    .tracking(0.7)
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 11)
            .background(
                LinearGradient(
                    colors: [GEMPalette.violet, Color(red: 0.18, green: 0.09, blue: 0.32)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                in: Capsule()
            )
            .overlay {
                Capsule()
                    .strokeBorder(GEMPalette.gold.opacity(isSelected ? 0.95 : 0.60), lineWidth: isSelected ? 2 : 1)
            }
            .shadow(color: GEMPalette.violet.opacity(0.38), radius: 12, y: 6)

            Image(systemName: "triangle.fill")
                .font(.system(size: 10))
                .foregroundStyle(GEMPalette.violet)
                .rotationEffect(.degrees(180))
                .offset(y: -2)
        }
        .scaleEffect(isSelected ? 1.05 : 1)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

/// Reusable city selector; its selection property and action are controlled by the map section.
struct GEMTourCityChip: View {
    let stop: GEMTourStop
    let isSelected: Bool
    let onSelect: () -> Void

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 7) {
                Circle()
                    .fill(isSelected ? GEMPalette.gold : GEMPalette.purple)
                    .frame(width: 5, height: 5)

                Text(stop.englishCity)
                    .font(GEMFont.display(10))
                    .tracking(0.8)
                    .lineLimit(1)
            }
            .foregroundStyle(isSelected ? Color.white : GEMPalette.foreground(for: colorScheme))
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                isSelected ? GEMPalette.violet : GEMPalette.card(for: colorScheme),
                in: Capsule()
            )
            .overlay {
                Capsule()
                    .strokeBorder(
                        isSelected ? GEMPalette.gold.opacity(0.7) : GEMPalette.purple.opacity(0.22),
                        lineWidth: 1
                    )
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("查看\(stop.city)巡演資訊")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

struct GEMTourDetailCard: View {
    let stop: GEMTourStop

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 17) {
            HStack(alignment: .top, spacing: 15) {
                ZStack(alignment: .bottomLeading) {
                    Image("gem_stage")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 94, height: 145)
                        .clipped()

                    LinearGradient(
                        colors: [.clear, .black.opacity(0.76)],
                        startPoint: .center,
                        endPoint: .bottom
                    )

                    Image(systemName: "music.mic")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(GEMPalette.gold)
                        .padding(11)
                }
                .frame(width: 94, height: 145)
                .clipShape(GEMStageCutShape())

                VStack(alignment: .leading, spacing: 6) {
                    Text("I AM GLORIA  /  \(stop.region)")
                        .font(GEMFont.display(9))
                        .tracking(1)
                        .foregroundStyle(GEMPalette.purple)
                        .lineLimit(2)

                    Text(stop.city)
                        .font(GEMFont.headline(23))
                        .foregroundStyle(GEMPalette.foreground(for: colorScheme))

                    Text(stop.dates)
                        .font(GEMFont.display(11))
                        .foregroundStyle(colorScheme == .dark ? GEMPalette.gold : GEMPalette.violet)
                        .lineLimit(2)

                    Text(stop.venue)
                        .font(GEMFont.body(12))
                        .foregroundStyle(GEMPalette.foreground(for: colorScheme))
                        .fixedSize(horizontal: false, vertical: true)

                    Text(stop.caption)
                        .font(GEMFont.body(11))
                        .foregroundStyle(GEMPalette.secondary(for: colorScheme))
                        .fixedSize(horizontal: false, vertical: true)
                        .lineSpacing(3)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Rectangle()
                .fill(GEMPalette.purple.opacity(0.20))
                .frame(height: 1)

            HStack(spacing: 10) {
                Button {
                    // Opens the exact venue location in Apple Maps.
                    let item = MKMapItem(placemark: MKPlacemark(coordinate: stop.coordinate))
                    item.name = stop.venue
                    item.openInMaps()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "map.fill")
                        Text("APPLE MAPS")
                        Image(systemName: "arrow.up.right")
                    }
                    .font(GEMFont.display(10))
                    .foregroundStyle(colorScheme == .dark ? Color.black : Color(red: 0.16, green: 0.10, blue: 0.22))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .background(GEMPalette.gold, in: Capsule())
                }
                .buttonStyle(.plain)

                Link(destination: GEMTourContent.officialURL) {
                    HStack(spacing: 6) {
                        Text("OFFICIAL TOUR")
                        Image(systemName: "arrow.up.right")
                    }
                    .font(GEMFont.display(10))
                    .foregroundStyle(GEMPalette.foreground(for: colorScheme))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .background(GEMPalette.purple.opacity(0.13), in: Capsule())
                }
            }
        }
        .padding(17)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(GEMPalette.card(for: colorScheme), in: RoundedRectangle(cornerRadius: 23))
        .overlay {
            RoundedRectangle(cornerRadius: 23)
                .strokeBorder(GEMPalette.purple.opacity(colorScheme == .dark ? 0.27 : 0.14), lineWidth: 1)
        }
    }
}
