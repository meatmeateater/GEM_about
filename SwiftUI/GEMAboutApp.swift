import SwiftUI

@main
@MainActor
struct GEMAboutApp: App {
    @StateObject private var library = GEMLibrary()
    var body: some Scene {
        WindowGroup {
            GEMAboutView()
                .environmentObject(library)
        }
    }
}
