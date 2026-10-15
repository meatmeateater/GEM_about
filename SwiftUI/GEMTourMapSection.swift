import SwiftUI
import MapKit

struct GEMTourMapSection: View {
    @State private var selectedStopID: String? = nil
    @State private var cameraPosition: MapCameraPosition = .region(GEMTourContent.overviewRegion)
    @Environment(\.colorScheme) private var scheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var selectedStop: GEMTourStop? {
        GEMTourContent.stops.first { $0.id == selectedStopID }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            GEMSectionHeading(eyebrow: "06 / TOUR ARCHIVE", title: "歌聲，走過的城市。",
                              description: "探索 I AM GLORIA 的精選巡演公告。點擊城市，在地圖與場館資訊之間切換。")
            if GEMTourContent.stops.isEmpty {
                GEMEmptyState(title: "巡演紀錄整理中", message: "先到作品區，認識這段旅程的音樂。", symbol: "map")
            } else {
                map
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(GEMTourContent.stops) { stop in
                            GEMTourCityChip(stop: stop, isSelected: selectedStopID == stop.id,
                                            onSelect: { select(stop) })
                        }
                    }.padding(.vertical, 4)
                }
                if let stop = selectedStop {
                    GEMTourDetailCard(stop: stop)
                        .id(stop.id).transition(.opacity)
                } else {
                    Label("選擇一座城市，查看場館與公告日期。", systemImage: "hand.tap")
                        .font(GEMFont.body(15)).foregroundStyle(GEMPalette.secondary(for: scheme))
                        .padding(.vertical, 10)
                }
                Text("收錄範圍：2026 年 \(GEMTourContent.stops.count) 座城市的官方公告精選，核對於 2026-10-15。排期不等於實際舉行證明，亦非即時售票資訊。")
                    .font(GEMFont.body(12)).lineSpacing(4).foregroundStyle(GEMPalette.secondary(for: scheme))
                NavigationLink(value: GEMRoute.entry("release-i-am-gloria")) {
                    Label("延伸閱讀：《I AM GLORIA》音樂篇章", systemImage: "opticaldisc")
                        .font(GEMFont.body(15)).foregroundStyle(GEMPalette.purple).frame(minHeight: 44)
                }.buttonStyle(GEMPressStyle())
            }
        }
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.22), value: selectedStopID)
    }

    private var map: some View {
        Map(position: $cameraPosition, selection: $selectedStopID) {
            ForEach(GEMTourContent.stops) { stop in
                if stop.id == "taipei" {
                    Annotation(stop.city, coordinate: stop.coordinate, anchor: .bottom) {
                        Button { select(stop) } label: {
                            GEMTourSpotlightPin(isSelected: selectedStopID == stop.id)
                        }.buttonStyle(.plain).accessibilityLabel("查看台北巡演公告")
                    }.tag(stop.id)
                } else {
                    Marker(stop.city, systemImage: "music.mic", coordinate: stop.coordinate)
                        .tint(GEMPalette.violet).tag(stop.id)
                }
            }
        }
        .mapStyle(.standard(elevation: .flat, emphasis: .muted, pointsOfInterest: .excludingAll))
        .mapControlVisibility(.hidden)
        .onChange(of: selectedStopID) { _, _ in updateCamera() }
        .frame(height: 320)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(alignment: .topLeading) {
            Text("GLORIA / \(GEMTourContent.stops.count) CITIES")
                .font(GEMFont.display(10)).foregroundStyle(.white)
                .padding(13).background(GEMPalette.violet, in: Capsule()).padding(13)
                .allowsHitTesting(false)
        }
        .overlay(alignment: .topTrailing) {
            Button {
                if selectedStopID == nil { updateCamera() } else { selectedStopID = nil }
            } label: {
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                    .frame(width: 44, height: 44)
            }.buttonStyle(.glass).padding(12).accessibilityLabel("返回所有城市概覽")
        }
        .accessibilityHint("也可使用地圖下方的城市按鈕選擇場館")
    }

    private func select(_ stop: GEMTourStop) {
        if selectedStopID == stop.id { updateCamera() } else { selectedStopID = stop.id }
    }

    private func updateCamera() {
        withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.55)) {
            cameraPosition = .region(selectedStop?.focusedRegion ?? GEMTourContent.overviewRegion)
        }
    }
}
