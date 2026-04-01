import SwiftUI

struct AnimatedPieceView: View {
    let player: Player
    let size: CGFloat
    let skin: Skin
    @State private var animateIn = false
    @State private var bounce = false
    
    var body: some View {
        Circle()
            .fill(pieceGradient)
            .frame(width: size, height: size)
            .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)
            .scaleEffect(animateIn ? 1 : 0.01)
            .scaleEffect(bounce ? 1.15 : 1.0)
            .onAppear {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    animateIn = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.spring(response: 0.15, dampingFraction: 0.5)) {
                        bounce = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        bounce = false
                    }
                }
            }
    }
    
    private var pieceGradient: RadialGradient {
        let blackColor = skin.blackStoneColor
        let whiteColor = skin.whiteStoneColor
        return RadialGradient(
            colors: player == .black 
                ? [blackColor.opacity(0.8), blackColor]
                : [whiteColor.opacity(0.9), whiteColor.opacity(0.7)],
            center: .center,
            startRadius: 0,
            endRadius: size / 2
        )
    }
}