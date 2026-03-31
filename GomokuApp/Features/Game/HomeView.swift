import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedMode: GameMode? = nil
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                
                VStack(spacing: 12) {
                    Text("技能五子棋")
                        .font(AppFont.title())
                        .foregroundColor(Color.theme.text)
                    
                    Text("来一局吧")
                        .font(AppFont.body())
                        .foregroundColor(Color.theme.textSecondary)
                }
                
                Button(action: {
                    selectedMode = .pveMedium
                }) {
                    Text("开始游戏")
                        .font(AppFont.headline())
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.theme.primary)
                        .cornerRadius(25)
                }
                
                Button(action: {
                    selectedMode = .pveEasy
                }) {
                    Text("简单模式")
                        .font(AppFont.body())
                        .foregroundColor(Color.theme.primary)
                        .frame(width: 200, height: 44)
                        .background(Color.theme.primary.opacity(0.1))
                        .cornerRadius(22)
                }
                
                Spacer()
                
                HStack(spacing: 40) {
                    VStack {
                        Text("\(appState.coins)")
                            .font(AppFont.headline())
                            .foregroundColor(Color.theme.accent)
                        Text("金币")
                            .font(AppFont.caption())
                            .foregroundColor(Color.theme.textSecondary)
                    }
                    
                    VStack {
                        Text("\(appState.checkInDays)")
                            .font(AppFont.headline())
                            .foregroundColor(Color.theme.secondary)
                        Text("签到天数")
                            .font(AppFont.caption())
                            .foregroundColor(Color.theme.textSecondary)
                    }
                }
                .padding()
            }
            .padding()
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: Binding(
                get: { selectedMode != nil },
                set: { if !$0 { selectedMode = nil } }
            )) {
                if let mode = selectedMode {
                    GameView(mode: mode)
                        .onDisappear {
                            selectedMode = nil
                        }
                }
            }
        }
    }
}