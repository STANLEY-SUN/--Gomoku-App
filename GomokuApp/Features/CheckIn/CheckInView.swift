import SwiftUI

struct CheckInView: View {
    @EnvironmentObject var appState: AppState
    @State private var todayChecked = false
    
    private let rewards = [10, 20, 30, 40, 50, 60, 100]
    private let specialRewards = ["", "", "", "", "1天体验卡", "", "限定头像框"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("每日签到")
                    .font(AppFont.title())
                    .padding(.top, 20)
                
                HStack(spacing: 20) {
                    ForEach(0..<7, id: \.self) { day in
                        DayRewardView(
                            day: day + 1,
                            reward: rewards[day],
                            specialReward: specialRewards[day],
                            isChecked: day < appState.checkInDays,
                            isToday: day == appState.checkInDays
                        )
                    }
                }
                .padding()
                
                if !todayChecked && appState.checkInDays < 7 {
                    Button(action: checkIn) {
                        Text("立即签到")
                            .font(AppFont.headline())
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color.theme.primary)
                            .cornerRadius(25)
                    }
                } else {
                    Text("今日已签到")
                        .font(AppFont.body())
                        .foregroundColor(Color.theme.secondary)
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    Text("签到说明")
                        .font(AppFont.caption())
                        .foregroundColor(Color.theme.textSecondary)
                    Text("连续签到7天可获得全部奖励\n断签将重新计算")
                        .font(AppFont.small())
                        .foregroundColor(Color.theme.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
            .background(Color.theme.background)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func checkIn() {
        if appState.checkInDays < 7 {
            appState.coins += rewards[appState.checkInDays]
            appState.checkInDays += 1
            appState.saveUserData()
            todayChecked = true
        }
    }
}

struct DayRewardView: View {
    let day: Int
    let reward: Int
    let specialReward: String
    let isChecked: Bool
    let isToday: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Text("Day \(day)")
                .font(AppFont.small())
                .foregroundColor(isToday ? Color.theme.primary : Color.theme.textSecondary)
            
            ZStack {
                Circle()
                    .fill(isChecked ? Color.theme.secondary : Color.theme.surface)
                    .frame(width: 40, height: 40)
                
                if isChecked {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                } else {
                    Text("\(reward)")
                        .font(AppFont.caption())
                        .foregroundColor(Color.theme.textPrimary)
                }
            }
            .overlay(
                Circle()
                    .stroke(isToday ? Color.theme.primary : Color.clear, lineWidth: 2)
            )
            
            if !specialReward.isEmpty {
                Text(specialReward)
                    .font(.system(size: 8))
                    .foregroundColor(Color.theme.accent)
            }
        }
    }
}

#Preview {
    CheckInView()
        .environmentObject(AppState())
}