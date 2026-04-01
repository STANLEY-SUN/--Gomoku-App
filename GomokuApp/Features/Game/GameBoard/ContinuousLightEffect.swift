import SwiftUI

struct ContinuousLightEffect: View {
    let skin: Skin
    @State private var phase: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundColor
                    .ignoresSafeArea()
                
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(gradientColor.opacity(0.15))
                        .frame(width: geometry.size.width * 1.5)
                        .offset(
                            x: sin(phase + CGFloat(index) * .pi * 2 / 3) * geometry.size.width * 0.3,
                            y: cos(phase + CGFloat(index) * .pi * 2 / 3) * geometry.size.height * 0.3
                        )
                        .blur(radius: 60)
                        .animation(
                            Animation.linear(duration: 8 + Double(index) * 2)
                                .repeatForever(autoreverses: false),
                            value: phase
                        )
                }
            }
            .onAppear {
                phase = .pi * 2
            }
        }
    }
    
    private var backgroundColor: Color {
        skin.backgroundColor
    }
    
    private var gradientColor: Color {
        switch skin {
        case .mint:
            return .green
        case .warmOrange:
            return .orange
        case .sakura:
            return .pink
        case .otherWorld:
            return .purple
        case .futureTech:
            return .cyan
        case .dunhuang:
            return .yellow
        case .bronze:
            return .brown
        case .classic:
            return .clear
        }
    }
}