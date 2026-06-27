import SwiftUI

/// A monochrome vector rendering of the app's logo — a plate with a fork and
/// knife, wrapped by two curved "cycle" arrows. Drawn as a shape rather than a
/// bitmap so it stays crisp at any size and renders cleanly under the iOS
/// lock-screen accessory tint, where only the alpha of the artwork is used.
///
/// Geometry is authored in a 100x100 space and scaled to the available size.
struct PlateLogoMark: View {
  var body: some View {
    Canvas { context, size in
      let side = min(size.width, size.height)
      let scale = side / 100
      let originX = (size.width - side) / 2
      let originY = (size.height - side) / 2

      func point(_ x: Double, _ y: Double) -> CGPoint {
        CGPoint(x: originX + CGFloat(x) * scale, y: originY + CGFloat(y) * scale)
      }
      func length(_ value: Double) -> CGFloat { CGFloat(value) * scale }

      // ── Cycle arrows ── two arcs on a radius-43 circle, each capped with an
      // arrowhead pointing along its direction of travel.
      let arrowCenter = (x: 50.0, y: 50.0)
      let arrowRadius = 43.0

      func arcPoint(_ degrees: Double) -> CGPoint {
        let radians = degrees * .pi / 180
        return point(
          arrowCenter.x + arrowRadius * cos(radians),
          arrowCenter.y + arrowRadius * sin(radians)
        )
      }

      func drawArrow(from startDeg: Double, to endDeg: Double) {
        var arc = Path()
        let steps = 48
        for i in 0...steps {
          let t = Double(i) / Double(steps)
          let p = arcPoint(startDeg + (endDeg - startDeg) * t)
          if i == 0 { arc.move(to: p) } else { arc.addLine(to: p) }
        }
        context.stroke(
          arc, with: .foreground,
          style: StrokeStyle(lineWidth: length(3.1), lineCap: .round)
        )

        let end = arcPoint(endDeg)
        let radians = endDeg * .pi / 180
        let tangent = CGVector(dx: -sin(radians), dy: cos(radians))
        let radial = CGVector(dx: cos(radians), dy: sin(radians))
        let tip = CGPoint(x: end.x + tangent.dx * length(4.5), y: end.y + tangent.dy * length(4.5))
        let back = CGPoint(x: end.x - tangent.dx * length(6.5), y: end.y - tangent.dy * length(6.5))
        var head = Path()
        head.move(to: tip)
        head.addLine(to: CGPoint(x: back.x + radial.dx * length(5.2), y: back.y + radial.dy * length(5.2)))
        head.addLine(to: CGPoint(x: back.x - radial.dx * length(5.2), y: back.y - radial.dy * length(5.2)))
        head.closeSubpath()
        context.fill(head, with: .foreground)
      }

      drawArrow(from: 188, to: 352)
      drawArrow(from: 8, to: 172)

      // ── Plate ── two concentric rings.
      func ring(radius: Double, lineWidth: Double) {
        let center = point(50, 50)
        let r = length(radius)
        context.stroke(
          Path(ellipseIn: CGRect(x: center.x - r, y: center.y - r, width: r * 2, height: r * 2)),
          with: .foreground, lineWidth: length(lineWidth)
        )
      }
      ring(radius: 19, lineWidth: 3.4)
      ring(radius: 9.5, lineWidth: 2.3)

      // ── Fork ── three tines over a handle.
      var fork = Path()
      for tineX in [19.7, 23, 26.3] {
        fork.move(to: point(tineX, 33))
        fork.addLine(to: point(tineX, 42))
      }
      context.stroke(
        fork, with: .foreground,
        style: StrokeStyle(lineWidth: length(2.2), lineCap: .round)
      )
      var forkHandle = Path()
      forkHandle.move(to: point(23, 42))
      forkHandle.addLine(to: point(23, 67))
      context.stroke(
        forkHandle, with: .foreground,
        style: StrokeStyle(lineWidth: length(2.9), lineCap: .round)
      )

      // ── Knife ── a rounded-top blade over a handle.
      var blade = Path()
      blade.move(to: point(74.4, 53))
      blade.addLine(to: point(74.4, 38))
      blade.addQuadCurve(to: point(79.6, 38), control: point(77, 32.8))
      blade.addLine(to: point(79.6, 53))
      blade.closeSubpath()
      context.fill(blade, with: .foreground)
      var knifeHandle = Path()
      knifeHandle.move(to: point(77, 53))
      knifeHandle.addLine(to: point(77, 67))
      context.stroke(
        knifeHandle, with: .foreground,
        style: StrokeStyle(lineWidth: length(2.8), lineCap: .round)
      )
    }
  }
}
