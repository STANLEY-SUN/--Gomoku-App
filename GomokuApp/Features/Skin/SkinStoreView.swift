import SwiftUI

struct SkinStoreView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(Skin.allCases) { skin in
                        SkinCard(skin: skin, isSelected: appState.selectedSkin == skin)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    appState.selectedSkin = skin
                                    appState.saveUserData()
                                }
                            }
                    }
                }
                .padding()
            }
            .background(Color.theme.background)
            .navigationTitle("皮肤商店")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct SkinCard: View {
    let skin: Skin
    let isSelected: Bool
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [skin.boardColor.opacity(0.8), skin.boardColor.opacity(0.5)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 100)
                
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(skin.blackStoneColor)
                            .frame(width: 28, height: 28)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                        
                        Circle()
                            .strokeBorder(Color.white.opacity(0.3), lineWidth: 2)
                            .frame(width: 28, height: 28)
                    }
                    
                    Circle()
                        .fill(skin.whiteStoneColor)
                        .frame(width: 28, height: 28)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
                }
                
                if isSelected {
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .background(
                                    Circle()
                                        .fill(Color.theme.primary)
                                        .frame(width: 28, height: 28)
                                )
                                .padding(8)
                        }
                        Spacer()
                    }
                }
            }
            
            VStack(spacing: 4) {
                Text(skin.name)
                    .font(AppFont.body())
                    .foregroundColor(Color.theme.text)
                
                if skin.isDefault {
                    Text("免费")
                        .font(AppFont.small())
                        .foregroundColor(Color.theme.secondary)
                } else {
                    HStack(spacing: 4) {
                        Image(systemName: "bitcoinsign.circle.fill")
                            .font(.system(size: 12))
                        Text("\(Int((skin.price ?? 0) * 100))")
                            .font(AppFont.small())
                    }
                    .foregroundColor(Color.theme.accent)
                }
            }
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Color.theme.surface.opacity(0.8))
        }
        .background(Color.theme.surface)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? Color.theme.primary : Color.clear, lineWidth: 2)
                .shadow(color: isSelected ? Color.theme.primary.opacity(0.3) : Color.clear, radius: 8)
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
    }
}