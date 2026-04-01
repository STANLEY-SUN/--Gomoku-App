import SwiftUI

struct VictoryEffectView: View {
    let winner: Player
    let onDismiss: () -> Void
    @State private var scale: CGFloat = 0
    @State private var opacity: Double = 0
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .opacity(opacity)
            
            VStack(spacing: 20) {
                Text(winner == .black ? "🏆 黑方获胜 🏆" : "🏆 白方获胜 🏆")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.yellow)
                    .shadow(color: .orange, radius: 10)
                    .scaleEffect(scale)
                    .rotationEffect(.degrees(rotation))
                
                if winner == .black {
                    ForEach(0..<5, id: \.self) { _ in
                        ConfettiView()
                    }
                }
            }
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                    scale = 1
                    opacity = 1
                }
                withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    onDismiss()
                }
            }
        }
    }
}

struct ConfettiView: View {
    @State private var xOffset: CGFloat = 0
    @State private var yOffset: CGFloat = -100
    @State private var rotation: Double = 0
    @State private var opacity: Double = 1
    let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink]
    let randomColor = Int.random(in: 0...6)
    let randomDelay = Double.random(in: 0...0.3)
    
    var body: some View {
        Circle()
            .fill(colors[randomColor])
            .frame(width: 10, height: 10)
            .offset(x: xOffset, y: yOffset)
            .rotationEffect(.degrees(rotation))
            .opacity(opacity)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + randomDelay) {
                    withAnimation(.easeOut(duration: 2)) {
                        xOffset = CGFloat.random(in: -150...150)
                        yOffset = CGFloat.random(in: 100...400)
                        rotation = Double.random(in: -360...360)
                    }
                    withAnimation(.easeIn(duration: 2).delay(1.5)) {
                        opacity = 0
                    }
                }
            }
    }
}