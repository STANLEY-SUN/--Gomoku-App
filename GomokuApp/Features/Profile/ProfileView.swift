import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var dataManager = DataManager.shared
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    headerSection
                    
                    statsSection
                    
                    menuSection
                    
                    if !appState.isPremium {
                        premiumSection
                    }
                }
                .padding()
            }
            .background(Color.theme.background)
            .navigationTitle("我的")
            .navigationBarTitleDisplayMode(.inline)
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
                            endRadius: 60
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: appState.isPremium ? "star.circle.fill" : "person.circle.fill")
                    .font(.system(size: 70))
                    .foregroundColor(appState.isPremium ? Color.theme.accent : Color.theme.primary)
            }
            
            VStack(spacing: 4) {
                Text(appState.isPremium ? "Premium 会员" : "棋手")
                    .font(AppFont.title())
                    .foregroundColor(Color.theme.text)
                
                if appState.isPremium {
                    Text("尊享全部特权")
                        .font(AppFont.caption())
                        .foregroundColor(Color.theme.accent)
                }
            }
        }
        .padding(.vertical, 20)
    }
    
    private var statsSection: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                StatBox(value: "\(dataManager.gameStats.wins)", label: "胜场", icon: "checkmark.seal.fill", color: .green)
                
                Divider()
                    .frame(height: 50)
                    .background(Color.theme.textSecondary.opacity(0.2))
                
                StatBox(value: "\(dataManager.gameStats.losses)", label: "负场", icon: "xmark.circle.fill", color: .red)
                
                Divider()
                    .frame(height: 50)
                    .background(Color.theme.textSecondary.opacity(0.2))
                
                StatBox(value: "\(dataManager.gameStats.draws)", label: "平局", icon: "hand.raised.fill", color: .orange)
            }
            
            Divider()
                .background(Color.theme.textSecondary.opacity(0.2))
            
            HStack(spacing: 0) {
                StatBox(value: String(format: "%.1f%%", dataManager.gameStats.winRate), label: "胜率", icon: "chart.line.uptrend.xyaxis", color: Color.theme.primary)
                
                Divider()
                    .frame(height: 50)
                    .background(Color.theme.textSecondary.opacity(0.2))
                
                StatBox(value: "\(appState.totalWins)", label: "总胜场", icon: "cup.and.saucer.fill", color: Color.theme.accent)
                
                Divider()
                    .frame(height: 50)
                    .background(Color.theme.textSecondary.opacity(0.2))
                
                StatBox(value: "\(appState.coins)", label: "金币", icon: "bitcoinsign.circle.fill", color: .yellow)
            }
        }
        .padding(.vertical, 16)
        .background(Color.theme.surface)
        .cornerRadius(16)
    }
    
    private var menuSection: some View {
        VStack(spacing: 0) {
            MenuItemRow(icon: "gearshape.fill", title: "设置", color: .gray)
            Divider().padding(.leading, 44)
            MenuItemRow(icon: "star.fill", title: "成就", color: .yellow)
            Divider().padding(.leading, 44)
            MenuItemRow(icon: "chart.bar.fill", title: "排行榜", color: Color.theme.primary)
            Divider().padding(.leading, 44)
            MenuItemRow(icon: "questionmark.circle.fill", title: "帮助与反馈", color: .blue)
        }
        .background(Color.theme.surface)
        .cornerRadius(16)
    }
    
    private var premiumSection: some View {
        Button(action: {
            appState.isPremium = true
            appState.saveUserData()
        }) {
            HStack {
                Image(systemName: "crown.fill")
                    .font(.system(size: 20))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("升级 Premium")
                        .font(AppFont.headline())
                        .foregroundColor(.white)
                    
                    Text("解锁全部皮肤和功能")
                        .font(AppFont.caption())
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [Color.theme.accent, Color.theme.accent.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .shadow(color: Color.theme.accent.opacity(0.4), radius: 8, x: 0, y: 4)
        }
    }
}

struct StatBox: View {
    let value: String
    let label: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 18))
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

struct MenuItemRow: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(title)
                .font(AppFont.body())
                .foregroundColor(Color.theme.textPrimary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(Color.theme.textSecondary)
                .font(.system(size: 14))
        }
        .padding()
    }
}