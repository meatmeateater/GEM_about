import SwiftUI

/// A five-point polygon specified for the accompanying Keynote drawing guide.
/// A real Keynote drawing and evidence must be completed separately on a Mac.
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

/// An upward-extended version of GEMStageCutShape that ensures ambient shadows
/// project exclusively along the bottom diagonal stage cut edges.
struct GEMStageBottomShadowShape: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height

        var path = Path()
        path.move(to: CGPoint(x: 0, y: -200))
        path.addLine(to: CGPoint(x: w, y: -200))
        path.addLine(to: CGPoint(x: w, y: h * 0.83))
        path.addLine(to: CGPoint(x: w * 0.38, y: h))
        path.addLine(to: CGPoint(x: 0, y: h * 0.90))
        path.closeSubpath()
        return path
    }
}
