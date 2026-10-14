import SwiftUI

/// A custom five-point polygon designed first with Keynote's Pen tool.
/// Keynote coordinates, expressed as percentages of the bounding box:
/// (0%, 0%) → (100%, 0%) → (100%, 83%) → (38%, 100%) → (0%, 90%).
/// The same geometry is recreated here using SwiftUI Path and used to clip photos.
struct GEMStageCutShape: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height

        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: w, y: 0))
        path.addLine(to: CGPoint(x: w, y: h * 0.83))
        path.addLine(to: CGPoint(x: w * 0.38, y: h))
        path.addLine(to: CGPoint(x: 0, y: h * 0.90))
        path.closeSubpath()
        return path
    }
}
