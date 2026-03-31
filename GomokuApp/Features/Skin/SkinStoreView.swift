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
                                appState.selectedSkin = skin
                                appState.saveUserData()
                            }
                    }
                }
                .padding()
            }
            .navigationTitle("皮肤商店")
            .background(Color.theme.background)
        }
    }
}

struct SkinCard: View {
    let skin: Skin
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.theme.boardBackground)
                    .frame(height: 80)
                
                VStack(spacing: 4) {
                    Circle()
                        .fill(Color.theme.blackStone)
                        .frame(width: 20, height: 20)
                    Circle()
                        .fill(Color.theme.whiteStone)
                        .frame(width: 20, height: 20)
                }
            }
            
            Text(skin.name)
                .font(AppFont.caption())
                .foregroundColor(Color.theme.textPrimary)
            
            if skin.isDefault {
                Text("免费")
                    .font(AppFont.small())
                    .foregroundColor(Color.theme.secondary)
            } else {
                Text("¥\(skin.price ?? 0)")
                    .font(AppFont.small())
                    .foregroundColor(Color.theme.accent)
            }
        }
        .padding(12)
        .background(Color.theme.surface)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.theme.primary : Color.clear, lineWidth: 2)
        )
    }
}