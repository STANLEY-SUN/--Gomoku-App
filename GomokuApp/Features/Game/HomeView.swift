import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var showGameMode = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                
                VStack(spacing: 12) {
                    Text("技能五子棋")
                        .font(AppFont.title())
                        .foregroundColor(Color.theme.textPrimary)
                    
                    Text("来一局吧")
                        .font(AppFont.body())
                        .foregroundColor(Color.theme.textSecondary)
                }
                
                Button(action: {
                    showGameMode = true
                }) {
                    Text("开始游戏")
                        .font(AppFont.headline())
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.theme.primary)
                        .cornerRadius(25)
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
            .sheet(isPresented: $showGameMode) {
                GameModeView()
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppState())
}