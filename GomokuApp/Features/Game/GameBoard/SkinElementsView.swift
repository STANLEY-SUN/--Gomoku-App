import SwiftUI

struct MintLeafView: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            ForEach(0..<6, id: \.self) { i in
                Image(systemName: "leaf.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.green.opacity(0.3))
                    .frame(width: size * 0.08, height: size * 0.08)
                    .rotationEffect(.degrees(Double(i) * 60 + 30))
                    .position(
                        x: size * (i % 2 == 0 ? 0.12 : 0.88),
                        y: size * (CGFloat(i) / 6.0 + 0.1)
                    )
            }
        }
    }
}

struct SunRaysView: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            ForEach(0..<12, id: \.self) { i in
                Rectangle()
                    .fill(Color.orange.opacity(0.25))
                    .frame(width: 2, height: size * 0.12)
                    .offset(y: -size * 0.38)
                    .rotationEffect(.degrees(Double(i) * 30))
            }
            
            Circle()
                .fill(Color.orange.opacity(0.3))
                .frame(width: size * 0.08, height: size * 0.08)
                .offset(y: -size * 0.42)
        }
    }
}

struct SakuraElementsView: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            ForEach(0..<8, id: \.self) { i in
                Image(systemName: "petal.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.pink.opacity(0.4))
                    .frame(width: size * 0.06, height: size * 0.06)
                    .rotationEffect(.degrees(Double.random(in: 0...360)))
                    .position(
                        x: size * CGFloat.random(in: 0.1...0.9),
                        y: size * CGFloat.random(in: 0.1...0.9)
                    )
            }
        }
    }
}

struct MagicCircleView: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.purple.opacity(0.25), lineWidth: 1)
                .frame(width: size * 0.35, height: size * 0.35)
            
            Circle()
                .stroke(Color.cyan.opacity(0.2), lineWidth: 0.5)
                .frame(width: size * 0.55, height: size * 0.55)
            
            Circle()
                .stroke(Color.purple.opacity(0.4), lineWidth: 0.5)
                .frame(width: size * 0.75, height: size * 0.75)
            
            ForEach(0..<6, id: \.self) { i in
                Image(systemName: "star.fill")
                    .font(.system(size: size * 0.018))
                    .foregroundColor(.yellow.opacity(0.5))
                    .position(
                        x: size * 0.5 + size * 0.35 * cos(.pi / 3 * CGFloat(i)),
                        y: size * 0.5 + size * 0.35 * sin(.pi / 3 * CGFloat(i))
                    )
            }
        }
    }
}

struct CircuitBoardView: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            Path { path in
                path.move(to: CGPoint(x: 0, y: size * 0.3))
                path.addLine(to: CGPoint(x: size * 0.2, y: size * 0.3))
                path.addLine(to: CGPoint(x: size * 0.2, y: size * 0.5))
                path.addLine(to: CGPoint(x: size * 0.4, y: size * 0.5))
            }
            .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
            
            Path { path in
                path.move(to: CGPoint(x: size, y: size * 0.7))
                path.addLine(to: CGPoint(x: size * 0.8, y: size * 0.7))
                path.addLine(to: CGPoint(x: size * 0.8, y: size * 0.2))
                path.addLine(to: CGPoint(x: size * 0.6, y: size * 0.2))
            }
            .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
            
            Path { path in
                path.move(to: CGPoint(x: size * 0.5, y: 0))
                path.addLine(to: CGPoint(x: size * 0.5, y: size * 0.15))
                path.addLine(to: CGPoint(x: size * 0.3, y: size * 0.15))
            }
            .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
            
            Path { path in
                path.move(to: CGPoint(x: size * 0.3, y: size))
                path.addLine(to: CGPoint(x: size * 0.3, y: size * 0.85))
                path.addLine(to: CGPoint(x: size * 0.7, y: size * 0.85))
            }
            .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
            
            ForEach(0..<5, id: \.self) { _ in
                Circle()
                    .fill(Color.cyan.opacity(0.5))
                    .frame(width: size * 0.025, height: size * 0.025)
                    .position(
                        x: size * CGFloat.random(in: 0.1...0.9),
                        y: size * CGFloat.random(in: 0.1...0.9)
                    )
            }
        }
    }
}

struct CloudPatternView: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { i in
                Image(systemName: "cloud.fill")
                    .font(.system(size: size * 0.07))
                    .foregroundColor(.yellow.opacity(0.35))
                    .position(
                        x: size * (CGFloat(i) * 0.3 + 0.2),
                        y: size * 0.15
                    )
            }
            
            ForEach(0..<4, id: \.self) { _ in
                Image(systemName: "sparkle")
                    .font(.system(size: size * 0.035))
                    .foregroundColor(.orange.opacity(0.5))
                    .position(
                        x: size * CGFloat.random(in: 0.2...0.8),
                        y: size * CGFloat.random(in: 0.5...0.85)
                    )
            }
            
            Image(systemName: "cloud.fill")
                .font(.system(size: size * 0.05))
                .foregroundColor(.yellow.opacity(0.25))
                .offset(x: size * 0.35, y: size * 0.35)
        }
    }
}

struct BronzePatternView: View {
    let size: CGFloat
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.clear)
                .frame(width: size * 0.9, height: size * 0.015)
                .overlay(
                    Rectangle()
                        .fill(Color.yellow.opacity(0.2))
                )
                .offset(y: -size * 0.38)
            
            Rectangle()
                .fill(Color.clear)
                .frame(width: size * 0.9, height: size * 0.015)
                .overlay(
                    Rectangle()
                        .fill(Color.yellow.opacity(0.2))
                )
                .offset(y: size * 0.38)
            
            ForEach(0..<5, id: \.self) { i in
                Image(systemName: "triangle.fill")
                    .font(.system(size: size * 0.025))
                    .foregroundColor(.orange.opacity(0.25))
                    .rotationEffect(.degrees(180))
                    .position(
                        x: size * 0.12,
                        y: size * (CGFloat(i) * 0.2 + 0.15)
                    )
                
                Image(systemName: "triangle.fill")
                    .font(.system(size: size * 0.025))
                    .foregroundColor(.orange.opacity(0.25))
                    .position(
                        x: size * 0.88,
                        y: size * (CGFloat(i) * 0.2 + 0.25)
                    )
            }
            
            Rectangle()
                .fill(Color.clear)
                .frame(width: size * 0.015, height: size * 0.7)
                .overlay(
                    Rectangle()
                        .fill(Color.yellow.opacity(0.15))
                )
                .offset(x: -size * 0.4)
            
            Rectangle()
                .fill(Color.clear)
                .frame(width: size * 0.015, height: size * 0.7)
                .overlay(
                    Rectangle()
                        .fill(Color.yellow.opacity(0.15))
                )
                .offset(x: size * 0.4)
        }
    }
}