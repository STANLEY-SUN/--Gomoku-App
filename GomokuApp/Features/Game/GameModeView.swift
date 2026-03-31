import SwiftUI

struct GameModeView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedMode: LocalGameMode?
    
    enum LocalGameMode: String, CaseIterable {
        case aiEasy = "ai_easy"
        case aiMedium = "ai_medium"
        case aiHard = "ai_hard"
        case twoPlayer = "two_player"
        
        var name: String {
            switch self {
            case .aiEasy: return "简单"
            case .aiMedium: return "中等"
            case .aiHard: return "困难"
            case .twoPlayer: return "双人对战"
            }
        }
        
        var icon: String {
            switch self {
            case .aiEasy, .aiMedium, .aiHard: return "brain"
            case .twoPlayer: return "person.2"
            }
        }
        
        var description: String {
            switch self {
            case .aiEasy: return "适合初学者"
            case .aiMedium: return "需要动点脑筋"
            case .aiHard: return "高手挑战"
            case .twoPlayer: return "和朋友对战"
            }
        }
        
        func toGameMode() -> GameMode {
            switch self {
            case .aiEasy: return .pveEasy
            case .aiMedium: return .pveMedium
            case .aiHard: return .pveHard
            case .twoPlayer: return .pvp
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("选择游戏模式")
                    .font(AppFont.headline())
                    .padding(.top, 20)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(LocalGameMode.allCases, id: \.self) { mode in
                        GameModeCard(mode: mode, isSelected: selectedMode == mode)
                            .onTapGesture {
                                selectedMode = mode
                            }
                    }
                }
                .padding()
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    Text("开始")
                        .font(AppFont.headline())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(selectedMode != nil ? Color.theme.primary : Color.gray)
                        .cornerRadius(25)
                }
                .disabled(selectedMode == nil)
                .padding()
            }
            .navigationTitle("游戏模式")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                    .foregroundColor(Color.theme.primary)
                }
            }
            .fullScreenCover(isPresented: .constant(false)) {
            }
        }
    }
}

struct GameModeCard: View {
    let mode: GameModeView.LocalGameMode
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: mode.icon)
                .font(.system(size: 32))
                .foregroundColor(isSelected ? Color.theme.primary : Color.theme.text)
            
            Text(mode.name)
                .font(AppFont.headline())
                .foregroundColor(isSelected ? Color.theme.primary : Color.theme.text)
            
            Text(mode.description)
                .font(.system(size: 12))
                .foregroundColor(Color.theme.textSecondary)
        }
        .frame(height: 120)
        .frame(maxWidth: .infinity)
        .background(isSelected ? Color.theme.primary.opacity(0.1) : Color.theme.surface)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.theme.primary : Color.clear, lineWidth: 2)
        )
    }
}