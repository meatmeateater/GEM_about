import SwiftUI
import MapKit
import CoreLocation

struct GEMTourSpotlightPin: View {
    let isSelected: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    var body: some View {
        VStack(spacing: 0) {
            Label("G.E.M. / TAIPEI", systemImage: "waveform")
                .font(GEMFont.display(10)).foregroundStyle(.white).padding(13)
                .background(GEMPalette.violet, in: Capsule())
                .overlay(Capsule().strokeBorder(GEMPalette.gold.opacity(isSelected ? 1 : 0.6), lineWidth: isSelected ? 2 : 1))
            Image(systemName: "triangle.fill").font(.system(size: 10)).rotationEffect(.degrees(180))
                .foregroundStyle(GEMPalette.violet).offset(y: -2)
        }
        .scaleEffect(isSelected && !reduceMotion ? 1.05 : 1)
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.2), value: isSelected)
    }
}

struct GEMTourCityChip: View {
    let stop: GEMTourStop
    let isSelected: Bool
    let onSelect: () -> Void
    var body: some View {
        GEMFilterChip(title: stop.city, isSelected: isSelected, action: onSelect)
            .accessibilityLabel("查看\(stop.city)巡演公告")
    }
}

struct GEMTourDetailCard: View {
    let stop: GEMTourStop
    @Environment(\.colorScheme) private var scheme
    @State private var couldNotOpenMaps = false
    var body: some View {
        VStack(alignment: .leading, spacing: 17) {
            Text("I AM GLORIA / \(stop.region)")
                .font(GEMFont.display(11)).tracking(1).foregroundStyle(GEMPalette.purple)
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "mappin.and.ellipse").font(.system(size: 25, weight: .light))
                    .foregroundStyle(GEMPalette.purple).accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 8) {
                    Text(stop.city).font(GEMFont.headline(25))
                    Text(stop.dates).font(GEMFont.body(16)).foregroundStyle(GEMPalette.purple)
                    Text(stop.venue).font(GEMFont.body(16)).textSelection(.enabled)
                }.fixedSize(horizontal: false, vertical: true)
            }
            Divider()
            Button {
                let item = MKMapItem(location: CLLocation(latitude: stop.latitude, longitude: stop.longitude), address: nil)
                item.name = stop.venue
                couldNotOpenMaps = !item.openInMaps(launchOptions: nil)
            } label: {
                Label("在 Apple Maps 查看場館", systemImage: "map")
                    .font(GEMFont.body(15)).frame(maxWidth: .infinity, alignment: .leading).frame(minHeight: 44)
            }.buttonStyle(.plain).foregroundStyle(GEMPalette.purple)
            GEMExternalLink(link: GEMLink(label: "官方巡演公告", url: GEMTourContent.officialURL.absoluteString))
        }
        .foregroundStyle(GEMPalette.foreground(for: scheme))
        .padding(22).frame(maxWidth: .infinity, alignment: .leading)
        .background(GEMPalette.card(for: scheme), in: RoundedRectangle(cornerRadius: 22))
        .alert("暫時無法開啟地圖", isPresented: $couldNotOpenMaps) {
            Button("好", role: .cancel) { }
        } message: { Text("你仍可查看本頁場館名稱，或開啟官方巡演公告。") }
    }
}
