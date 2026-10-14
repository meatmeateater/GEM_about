import SwiftUI

struct GEMSectionHeading: View {
    let eyebrow: String
    let title: String
    let description: String

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 11) {
            HStack(spacing: 8) {
                Capsule()
                    .fill(GEMPalette.purple)
                    .frame(width: 24, height: 2)
                Text(eyebrow)
                    .font(GEMFont.display(10))
                    .tracking(2.1)
                    .foregroundStyle(GEMPalette.purple)
            }

            Text(title)
                .font(GEMFont.headline(29))
                .foregroundStyle(GEMPalette.foreground(for: colorScheme))
                .fixedSize(horizontal: false, vertical: true)

            Text(description)
                .font(GEMFont.body(13))
                .foregroundStyle(GEMPalette.secondary(for: colorScheme))
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct GEMStatView: View {
    let value: String
    let label: String

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(value)
                .font(GEMFont.display(23))
                .minimumScaleFactor(0.7)
                .lineLimit(1)
                .foregroundStyle(GEMPalette.foreground(for: colorScheme))

            Text(label)
                .font(GEMFont.body(10))
                .foregroundStyle(GEMPalette.secondary(for: colorScheme))
                .lineLimit(2)
                .frame(height: 32, alignment: .topLeading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct GEMAlbumCard: View {
    let album: GEMAlbum

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .topLeading) {
                Image(album.assetName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 215, height: 218)
                    .clipped()
                    .clipShape(GEMStageCutShape())

                Text(album.year)
                    .font(GEMFont.display(11))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 11)
                    .padding(.vertical, 7)
                    .background(.black.opacity(0.46), in: Capsule())
                    .padding(12)
            }

            Text(album.title)
                .font(GEMFont.headline(17))
                .foregroundStyle(GEMPalette.foreground(for: colorScheme))
                .lineLimit(1)

            Text(album.description)
                .font(GEMFont.body(11))
                .foregroundStyle(GEMPalette.secondary(for: colorScheme))
                .lineLimit(2)
                .frame(height: 34, alignment: .topLeading)
        }
        .frame(width: 215, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}

struct GEMTrackRow: View {
    let track: GEMTrack

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack(spacing: 14) {
            Text(String(format: "%02d", track.number))
                .font(GEMFont.display(15))
                .foregroundStyle(GEMPalette.purple)
                .frame(width: 30, alignment: .leading)

            Image(systemName: track.symbol)
                .font(.system(size: 18, weight: .light))
                .foregroundStyle(GEMPalette.purple)
                .frame(width: 27)

            VStack(alignment: .leading, spacing: 4) {
                Text(track.title)
                    .font(GEMFont.headline(15))
                    .foregroundStyle(GEMPalette.foreground(for: colorScheme))

                Text(track.description)
                    .font(GEMFont.display(9))
                    .tracking(1)
                    .foregroundStyle(GEMPalette.secondary(for: colorScheme))
                    .lineLimit(1)
            }

            Spacer(minLength: 4)
            Image(systemName: "waveform")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(GEMPalette.purple.opacity(0.85))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(GEMPalette.card(for: colorScheme), in: RoundedRectangle(cornerRadius: 18))
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .strokeBorder(GEMPalette.purple.opacity(colorScheme == .dark ? 0.16 : 0.08), lineWidth: 1)
        }
    }
}

struct GEMTimelineRow: View {
    let milestone: GEMMilestone
    let isLast: Bool

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(spacing: 0) {
                Circle()
                    .fill(GEMPalette.purple)
                    .frame(width: 10, height: 10)
                    .overlay(Circle().strokeBorder(GEMPalette.purple.opacity(0.30), lineWidth: 5))
                Rectangle()
                    .fill(GEMPalette.purple.opacity(0.23))
                    .frame(width: 1, height: isLast ? 0 : 85)
            }
            .frame(width: 20)

            VStack(alignment: .leading, spacing: 5) {
                Text(milestone.year)
                    .font(GEMFont.display(11))
                    .tracking(1)
                    .foregroundStyle(GEMPalette.purple)
                Text(milestone.title)
                    .font(GEMFont.headline(16))
                    .foregroundStyle(GEMPalette.foreground(for: colorScheme))
                Text(milestone.detail)
                    .font(GEMFont.body(12))
                    .foregroundStyle(GEMPalette.secondary(for: colorScheme))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.bottom, isLast ? 0 : 25)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
