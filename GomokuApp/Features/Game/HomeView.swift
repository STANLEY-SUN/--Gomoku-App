import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedMode: GameMode? = nil
    @State private var isAnimating = false
    
    private var currentSkin: Skin {
        appState.selectedSkin
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.theme.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerSection
                        .padding(.top, 40)
                    
                    Spacer()
                        .frame(height: 40)
                    
                    gameModeSection
                    
                    Spacer()
                    
                    statsSection
                        .padding(.bottom, 40)
                }
                .padding(.horizontal, 24)
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: Binding(
                get: { selectedMode != nil },
                set: { if !$0 { selectedMode = nil } }
            )) {
                if let mode = selectedMode {
                    GameView(mode: mode, skin: currentSkin)
                        .onDisappear {
                            selectedMode = nil
                        }
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.theme.primary.opacity(0.3), Color.theme.primary.opacity(0.1)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                            isAnimating = true
                        }
                    }
                
                VStack(spacing: 8) {
                    Image(systemName: "circle.grid.3x3.fill")
                        .font(.system(size: 50))
                        .foregroundColor(Color.theme.primary)
                }
            }
            
            VStack(spacing: 8) {
                Text("技能五子棋")
                    .font(AppFont.title())
                    .foregroundColor(Color.theme.text)
                
                Text("智能对弈，乐在棋中")
                    .font(AppFont.body())
                    .foregroundColor(Color.theme.textSecondary)
            }
        }
    }
    
    private var gameModeSection: some View {
        VStack(spacing: 16) {
            Button(action: {
                selectedMode = .pveMedium
            }) {
                HStack {
                    Image(systemName: "play.fill")
                        .font(.system(size: 18))
                    Text("开始游戏")
                        .font(AppFont.headline())
                }
                .foregroundColor(.white)
                .frame(width: 240, height: 56)
                .background(
                    LinearGradient(
                        colors: [Color.theme.primary, Color.theme.primary.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(28)
                .shadow(color: Color.theme.primary.opacity(0.4), radius: 8, x: 0, y: 4)
            }
            
            HStack(spacing: 12) {
                ModeButton(title: "简单", mode: .pveEasy, color: .green)
                ModeButton(title: "中等", mode: .pveMedium, color: .orange)
                ModeButton(title: "困难", mode: .pveHard, color: .red)
            }
        }
    }
    
    private var statsSection: some View {
        HStack(spacing: 0) {
            StatItem(icon: "bitcoinsign.circle.fill", value: "\(appState.coins)", label: "金币", color: Color.theme.accent)
            
            Divider()
                .frame(height: 40)
                .background(Color.theme.textSecondary.opacity(0.3))
            
            StatItem(icon: "flame.fill", value: "\(appState.checkInDays)", label: "签到天数", color: Color.theme.secondary)
            
            Divider()
                .frame(height: 40)
                .background(Color.theme.textSecondary.opacity(0.3))
            
            StatItem(icon: "star.fill", value: "\(appState.totalWins)", label: "胜场", color: Color.theme.primary)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 24)
        .background(Color.theme.surface)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}

struct ModeButton: View {
    let title: String
    let mode: GameMode
    let color: Color
    @State private var selectedMode: GameMode? = nil
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Button(action: {
            selectedMode = mode
        }) {
            Text(title)
                .font(AppFont.body())
                .foregroundColor(color)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(color.opacity(0.15))
                .cornerRadius(20)
        }
        .fullScreenCover(isPresented: Binding(
            get: { selectedMode != nil },
            set: { if !$0 { selectedMode = nil } }
        )) {
            if let mode = selectedMode {
                GameView(mode: mode, skin: appState.selectedSkin)
                    .onDisappear {
                        selectedMode = nil
                    }
            }
        }
    }
}

struct StatItem: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(color)
            
            Text(value)
                .font(AppFont.headline())
                .foregroundColor(Color.theme.text)
            
            Text(label)
                .font(AppFont.caption())
                .foregroundColor(Color.theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}