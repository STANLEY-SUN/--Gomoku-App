import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(Color.theme.primary)
                    
                    Text(appState.isPremium ? "Premium 会员" : "普通用户")
                        .font(AppFont.headline())
                        .foregroundColor(Color.theme.textPrimary)
                }
                .padding(.top, 20)
                
                VStack(spacing: 16) {
                    ProfileRow(icon: "cup.and.saucer.fill", title: "胜场", value: "0")
                    ProfileRow(icon: "chart.line.uptrend.xyaxis", title: "胜率", value: "0%")
                    ProfileRow(icon: "flame.fill", title: "连胜", value: "0")
                }
                .padding()
                .background(Color.theme.surface)
                .cornerRadius(12)
                .padding(.horizontal)
                
                VStack(spacing: 0) {
                    ProfileItemRow(icon: "gearshape.fill", title: "设置", showArrow: true)
                    ProfileItemRow(icon: "star.fill", title: "成就", showArrow: true)
                    ProfileItemRow(icon: "chart.bar.fill", title: "排行榜", showArrow: true)
                    ProfileItemRow(icon: "questionmark.circle.fill", title: "帮助与反馈", showArrow: true)
                }
                .background(Color.theme.surface)
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
                
                if !appState.isPremium {
                    Button(action: {
                        appState.isPremium = true
                        appState.saveUserData()
                    }) {
                        Text("升级 Premium")
                            .font(AppFont.headline())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.theme.accent)
                            .cornerRadius(25)
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.theme.background)
            .navigationTitle("我的")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ProfileRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color.theme.primary)
                .frame(width: 24)
            
            Text(title)
                .font(AppFont.body())
                .foregroundColor(Color.theme.textPrimary)
            
            Spacer()
            
            Text(value)
                .font(AppFont.headline())
                .foregroundColor(Color.theme.textSecondary)
        }
    }
}

struct ProfileItemRow: View {
    let icon: String
    let title: String
    let showArrow: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color.theme.primary)
                .frame(width: 24)
            
            Text(title)
                .font(AppFont.body())
                .foregroundColor(Color.theme.textPrimary)
            
            Spacer()
            
            if showArrow {
                Image(systemName: "chevron.right")
                    .foregroundColor(Color.theme.textSecondary)
            }
        }
        .padding()
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppState())
}