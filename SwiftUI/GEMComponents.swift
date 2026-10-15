import SwiftUI
import UIKit
import Foundation

private enum GEMArtworkTransport {
    static let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = URLCache(memoryCapacity: 24 * 1024 * 1024,
                                          diskCapacity: 128 * 1024 * 1024,
                                          diskPath: "gem-artwork-v1")
        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.timeoutIntervalForRequest = 20
        return URLSession(configuration: configuration)
    }()
}

struct GEMScreenBackground: View {
    @Environment(\.colorScheme) private var scheme
    var body: some View { GEMPalette.background(dark: scheme == .dark).ignoresSafeArea() }
}

struct GEMSectionHeading: View {
    let eyebrow: String
    let title: String
    let description: String
    @Environment(\.colorScheme) private var scheme
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(eyebrow).font(GEMFont.display(11)).tracking(1.6).foregroundStyle(GEMPalette.purple)
            Text(title).font(GEMFont.headline(28)).foregroundStyle(GEMPalette.foreground(for: scheme))
                .fixedSize(horizontal: false, vertical: true)
            if !description.isEmpty {
                Text(description).font(GEMFont.body(15)).lineSpacing(5)
                    .foregroundStyle(GEMPalette.secondary(for: scheme))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct GEMArtwork: View {
    let entry: GEMEntry
    @Environment(\.colorScheme) private var scheme
    var body: some View {
        Group {
            if let name = entry.imageAsset, UIImage(named: name) != nil {
                Image(name).resizable().scaledToFit()
            } else if let rawURL = entry.artworkURL, let url = GEMURL.https(rawURL) {
                AsyncImage(request: URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20)) { phase in
                    switch phase {
                    case .success(let image): image.resizable().scaledToFit()
                    case .failure: fallback
                    case .empty:
                        fallback.overlay(alignment: .bottomTrailing) {
                            ProgressView().controlSize(.mini).padding(10)
                        }
                    @unknown default: fallback
                    }
                }.asyncImageURLSession(GEMArtworkTransport.session)
            } else { fallback }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(GEMPalette.card(for: scheme))
        .aspectRatio(1, contentMode: .fit)
        .clipped()
        .accessibilityLabel(entry.kind == .release ? "\(entry.title)作品圖像" : entry.title)
    }

    private var fallback: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(colors: [GEMPalette.violet.opacity(0.85), Color(red: 0.13, green: 0.07, blue: 0.23)],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                Circle().stroke(.white.opacity(0.12), lineWidth: 1).padding(geometry.size.width * 0.12)
                Circle().stroke(GEMPalette.gold.opacity(0.24), lineWidth: 1).padding(geometry.size.width * 0.22)
                VStack(spacing: 7) {
                    Image(systemName: entry.kind.symbol).font(.system(size: max(16, geometry.size.width * 0.14)))
                    if geometry.size.width > 100 {
                        Text(entry.title).font(GEMFont.headline(16)).multilineTextAlignment(.center).lineLimit(3)
                        Text(String(entry.year)).font(GEMFont.display(11)).foregroundStyle(GEMPalette.gold)
                    }
                }.foregroundStyle(.white).padding(12)
            }
        }
    }
}

struct GEMEntryRow: View {
    let entry: GEMEntry
    @Environment(\.colorScheme) private var scheme
    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            GEMArtwork(entry: entry).frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 12)).accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 6) {
                Text("\(String(entry.year))  /  \(entry.kind.title)")
                    .font(GEMFont.body(12)).foregroundStyle(GEMPalette.purple)
                Text(entry.title).font(GEMFont.headline(17))
                    .foregroundStyle(GEMPalette.foreground(for: scheme)).fixedSize(horizontal: false, vertical: true)
                Text(entry.summary).font(GEMFont.body(13)).lineLimit(2)
                    .foregroundStyle(GEMPalette.secondary(for: scheme))
            }.frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: "chevron.right").font(.system(size: 12, weight: .semibold))
                .foregroundStyle(GEMPalette.secondary(for: scheme)).accessibilityHidden(true)
        }
        .padding(.vertical, 12)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
    }
}

struct GEMFavoriteButton: View {
    let id: String
    @EnvironmentObject private var library: GEMLibrary
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    var body: some View {
        Button {
            library.toggleFavorite(id)
        } label: {
            Image(systemName: library.isFavorite(id) ? "heart.fill" : "heart")
                .font(.system(size: 19, weight: .medium))
                .foregroundStyle(GEMPalette.purple)
                .symbolEffect(.bounce, options: .nonRepeating, value: reduceMotion ? false : library.isFavorite(id))
                .symbolEffectsRemoved(reduceMotion)
                .frame(minWidth: 44, minHeight: 44)
                .background(GEMPalette.purple.opacity(0.09), in: Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(library.isFavorite(id) ? "取消收藏" : "收藏")\(library.entry(id: id)?.title ?? "內容")")
        .accessibilityValue(library.isFavorite(id) ? "已收藏" : "未收藏")
        .accessibilityIdentifier("favorite-\(id)")
    }
}

struct GEMFilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) private var scheme
    var body: some View {
        Button(action: action) {
            Text(title).font(GEMFont.body(14)).fixedSize(horizontal: true, vertical: false)
                .foregroundStyle(isSelected ? .white : GEMPalette.foreground(for: scheme))
                .padding(.horizontal, 16).frame(minHeight: 44)
                .background(isSelected ? GEMPalette.violet : GEMPalette.card(for: scheme), in: Capsule())
                .overlay(Capsule().strokeBorder(GEMPalette.purple.opacity(isSelected ? 0.65 : 0.18)))
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

struct GEMEmptyState: View {
    let title: String
    let message: String
    let symbol: String
    @Environment(\.colorScheme) private var scheme
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: symbol).font(.system(size: 34, weight: .light)).foregroundStyle(GEMPalette.purple)
            Text(title).font(GEMFont.headline(22)).foregroundStyle(GEMPalette.foreground(for: scheme))
            Text(message).font(GEMFont.body(15)).foregroundStyle(GEMPalette.secondary(for: scheme)).lineSpacing(5)
        }
        .multilineTextAlignment(.center).frame(maxWidth: .infinity).padding(.vertical, 45).padding(.horizontal, 24)
    }
}

struct GEMExternalLink: View {
    let link: GEMLink
    @Environment(\.openURL) private var openURL
    @State private var couldNotOpen = false
    var body: some View {
        if let url = link.destination {
            Button {
                openURL(url) { accepted in couldNotOpen = !accepted }
            } label: {
                HStack(spacing: 10) {
                    Text(link.label).font(GEMFont.body(15)).multilineTextAlignment(.leading)
                    Spacer(minLength: 8)
                    Image(systemName: "arrow.up.right").font(.system(size: 13, weight: .semibold))
                }
                .foregroundStyle(GEMPalette.purple).padding(15)
                .background(GEMPalette.purple.opacity(0.08), in: RoundedRectangle(cornerRadius: 14))
                .frame(minHeight: 44)
            }
            .buttonStyle(.plain).accessibilityHint("在外部 App 或瀏覽器開啟")
            .alert("暫時無法開啟連結", isPresented: $couldNotOpen) {
                Button("好", role: .cancel) { }
            } message: { Text("請確認裝置連線，稍後再試。") }
        }
    }
}

struct GEMSourceList: View {
    let sourceIDs: [String]
    @EnvironmentObject private var library: GEMLibrary
    @Environment(\.colorScheme) private var scheme
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(sourceIDs.compactMap { library.source(id: $0) }) { source in
                VStack(alignment: .leading, spacing: 6) {
                    GEMExternalLink(link: GEMLink(label: source.title, url: source.url))
                    Text("\(source.publisher) · 核對於 \(source.verifiedAt)")
                        .font(GEMFont.body(12)).foregroundStyle(GEMPalette.secondary(for: scheme))
                    Text(source.scope).font(GEMFont.body(12)).lineSpacing(3)
                        .foregroundStyle(GEMPalette.secondary(for: scheme))
                }
            }
        }
    }
}

struct GEMPressStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.opacity(configuration.isPressed ? 0.83 : 1)
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.985 : 1)
            .animation(reduceMotion ? nil : .easeOut(duration: 0.16), value: configuration.isPressed)
    }
}

struct GEMReleaseCard: View {
    let entry: GEMEntry
    @Environment(\.colorScheme) private var scheme
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            NavigationLink(value: GEMRoute.entry(entry.id)) {
                VStack(alignment: .leading, spacing: 12) {
                    GEMArtwork(entry: entry).frame(width: 220, height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    Text("\(String(entry.year))  /  \(entry.category)").font(GEMFont.body(12)).foregroundStyle(GEMPalette.purple)
                    Text(entry.title).font(GEMFont.headline(20)).foregroundStyle(GEMPalette.foreground(for: scheme))
                        .fixedSize(horizontal: false, vertical: true)
                    Text(entry.summary).font(GEMFont.body(14)).foregroundStyle(GEMPalette.secondary(for: scheme))
                        .lineLimit(3).multilineTextAlignment(.leading)
                }.frame(width: 220, alignment: .leading)
            }.buttonStyle(GEMPressStyle())
            HStack {
                Text("查看作品").font(GEMFont.body(13)).foregroundStyle(GEMPalette.secondary(for: scheme))
                Spacer()
                GEMFavoriteButton(id: entry.id)
            }
        }.frame(width: 220, alignment: .leading)
    }
}
