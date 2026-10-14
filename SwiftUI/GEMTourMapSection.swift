import SwiftUI
import MapKit

/// Integrated into the About page between The Journey and Discography.
/// Demonstrates SwiftUI Map, Marker, Annotation, animated camera movement,
/// custom data-driven Views, and a detail card synchronized with map selection.
struct GEMTourMapSection: View {
    @State private var selectedStopID: String? = "taipei"
    @State private var cameraPosition: MapCameraPosition = .region(GEMTourContent.overviewRegion)
    @Environment(\.colorScheme) private var colorScheme

    private var selectedStop: GEMTourStop {
        GEMTourContent.stops.first(where: { $0.id == selectedStopID }) ?? GEMTourContent.stops[0]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 17) {
            GEMSectionHeading(
                eyebrow: "03  /  WORLD TOUR",
                title: "每一座城市，都是一首歌。",
                description: "FOLLOW HER FOOTSTEPS · 探索 I AM GLORIA 世界巡演足跡。點擊地標或切換城市，看見舞台背後的故事。"
            )

            HStack(spacing: 7) {
                Image(systemName: "globe.asia.australia.fill")
                    .foregroundStyle(GEMPalette.gold)
                    .font(.system(size: 12))
                Text("THE WORLD IS OUR STAGE")
                    .font(GEMFont.display(10))
                    .tracking(1.0)
                    .foregroundStyle(GEMPalette.secondary(for: colorScheme))
                Spacer(minLength: 0)
                Text("2026 ARCHIVE")
                    .font(GEMFont.display(9))
                    .foregroundStyle(GEMPalette.purple)
            }
            .padding(.top, 1)

            ZStack {
                Map(position: $cameraPosition, selection: $selectedStopID) {
                    ForEach(GEMTourContent.stops) { stop in
                        if stop.id == "taipei" {
                            // Required custom Annotation; tap is a real camera interaction.
                            Annotation(stop.city, coordinate: stop.coordinate, anchor: .bottom) {
                                Button {
                                    select(stop)
                                } label: {
                                    GEMTourSpotlightPin(isSelected: selectedStop.id == stop.id)
                                }
                                .buttonStyle(.plain)
                            }
                            .tag(stop.id)
                        } else {
                            // Required MapKit Marker; selection is bound to selectedStopID.
                            Marker(stop.city, systemImage: "music.mic", coordinate: stop.coordinate)
                                .tint(GEMPalette.violet)
                                .tag(stop.id)
                        }
                    }
                }
                .mapStyle(.standard(elevation: .flat, emphasis: .muted, pointsOfInterest: .excludingAll))
                .mapControlVisibility(.hidden)
                .onChange(of: selectedStopID) { _, newID in
                    guard let stop = GEMTourContent.stops.first(where: { $0.id == newID }) else { return }
                    focusCamera(on: stop)
                }

                // Lightweight editorial map HUD matches the hero/album overlays.
                VStack {
                    HStack(alignment: .top) {
                        Label("GLORIA / LIVE", systemImage: "waveform")
                            .font(GEMFont.display(10))
                            .tracking(0.8)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 13)
                            .padding(.vertical, 11)
                            .background(Color(red: 0.13, green: 0.07, blue: 0.26).opacity(0.93), in: Capsule())

                        Spacer()

                    }

                    Spacer()

                    HStack {
                        Image(systemName: "hand.draw")
                        Text("點擊城市，探索巡演記憶")
                        Spacer()
                        Text("04 STOPS")
                            .foregroundStyle(GEMPalette.gold)
                    }
                    .font(GEMFont.body(10))
                    .foregroundStyle(.white.opacity(0.95))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 11)
                    .background(Color(red: 0.13, green: 0.07, blue: 0.26).opacity(0.93), in: Capsule())
                }
                .padding(14)
                .allowsHitTesting(false) // Do not block map gestures or pins.
                // The real reset button is layered above this decorative HUD.
            }
            .frame(height: 330)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay {
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(GEMPalette.purple.opacity(colorScheme == .dark ? 0.36 : 0.18), lineWidth: 1)
            }
            .shadow(color: GEMPalette.violet.opacity(colorScheme == .dark ? 0.22 : 0.10), radius: 16, y: 8)
            .overlay(alignment: .topTrailing) {
                // An active control above the non-hit-testing decorative HUD.
                Button {
                    withAnimation(.easeInOut(duration: 0.85)) {
                        cameraPosition = .region(GEMTourContent.overviewRegion)
                    }
                } label: {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 39, height: 39)
                        .background(Color(red: 0.13, green: 0.07, blue: 0.26).opacity(0.93), in: Circle())
                }
                .buttonStyle(.plain)
                .padding(14)
                .accessibilityLabel("查看所有巡演城市")
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(GEMTourContent.stops) { stop in
                        GEMTourCityChip(
                            stop: stop,
                            isSelected: selectedStop.id == stop.id,
                            onSelect: { select(stop) }
                        )
                    }
                }
                .padding(.vertical, 3)
            }

            GEMTourDetailCard(stop: selectedStop)
                .id(selectedStop.id)
                .transition(.opacity.combined(with: .move(edge: .bottom)))
                .animation(.easeInOut(duration: 0.25), value: selectedStopID)

            Text("* 巡演站點與日期來自 G.E.M. 官方巡演頁面；地標為對應場館位置。此區塊為巡演回顧，非售票或即時場次資訊。")
                .font(GEMFont.body(10))
                .foregroundStyle(GEMPalette.secondary(for: colorScheme))
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(3)
        }
    }

    private func select(_ stop: GEMTourStop) {
        withAnimation(.easeInOut(duration: 0.55)) {
            selectedStopID = stop.id
            cameraPosition = .region(stop.focusedRegion)
        }
    }

    private func focusCamera(on stop: GEMTourStop) {
        withAnimation(.easeInOut(duration: 0.65)) {
            cameraPosition = .region(stop.focusedRegion)
        }
    }
}
