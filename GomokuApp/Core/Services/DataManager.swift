import Foundation
import SwiftUI

struct GameStats: Codable {
    var totalGames: Int = 0
    var wins: Int = 0
    var losses: Int = 0
    var draws: Int = 0
    
    var winRate: Double {
        guard totalGames > 0 else { return 0 }
        return Double(wins) / Double(totalGames) * 100
    }
}

struct UserSettings: Codable {
    var lastGameMode: String = "pveMedium"
    var lastSkin: String = "classic"
    var soundEnabled: Bool = true
    var musicEnabled: Bool = true
}

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @AppStorage("gameStats") private var gameStatsData: Data = Data()
    @AppStorage("ownedSkins") private var ownedSkinsData: Data = Data()
    @AppStorage("userSettings") private var userSettingsData: Data = Data()
    @AppStorage("checkInData") private var checkInData: Data = Data()
    
    @Published var gameStats: GameStats = GameStats() {
        didSet { saveGameStats() }
    }
    @Published var ownedSkins: [Skin] = [.classic, .mint, .warmOrange, .sakura] {
        didSet { saveOwnedSkins() }
    }
    @Published var userSettings: UserSettings = UserSettings() {
        didSet { saveUserSettings() }
    }
    @Published var checkInDates: [Date] = [] {
        didSet { saveCheckInDates() }
    }
    
    private init() {
        loadAllData()
    }
    
    private func loadAllData() {
        if let data = try? JSONDecoder().decode(GameStats.self, from: gameStatsData) {
            gameStats = data
        }
        if let data = try? JSONDecoder().decode([Skin].self, from: ownedSkinsData) {
            ownedSkins = data
        } else {
            ownedSkins = [.classic, .mint, .warmOrange, .sakura]
        }
        if let data = try? JSONDecoder().decode(UserSettings.self, from: userSettingsData) {
            userSettings = data
        }
        if let data = try? JSONDecoder().decode([Date].self, from: checkInData) {
            checkInDates = data
        }
    }
    
    private func saveGameStats() {
        gameStatsData = (try? JSONEncoder().encode(gameStats)) ?? Data()
    }
    
    private func saveOwnedSkins() {
        ownedSkinsData = (try? JSONEncoder().encode(ownedSkins)) ?? Data()
    }
    
    private func saveUserSettings() {
        userSettingsData = (try? JSONEncoder().encode(userSettings)) ?? Data()
    }
    
    private func saveCheckInDates() {
        checkInData = (try? JSONEncoder().encode(checkInDates)) ?? Data()
    }
    
    func recordGameResult(winner: Player?) {
        gameStats.totalGames += 1
        switch winner {
        case .black:
            gameStats.wins += 1
        case .white:
            gameStats.losses += 1
        case .none:
            gameStats.draws += 1
        }
    }
    
    func purchaseSkin(_ skin: Skin) {
        if !ownedSkins.contains(skin) {
            ownedSkins.append(skin)
        }
    }
    
    func canUseSkin(_ skin: Skin) -> Bool {
        return ownedSkins.contains(skin)
    }
    
    func checkInToday() -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return checkInDates.contains { calendar.isDate($0, inSameDayAs: today) }
    }
    
    func performCheckIn() {
        let today = Calendar.current.startOfDay(for: Date())
        if !checkInDates.contains(where: { Calendar.current.isDate($0, inSameDayAs: today) }) {
            checkInDates.append(today)
        }
    }
    
    func getConsecutiveCheckInDays() -> Int {
        let calendar = Calendar.current
        let sortedDates = checkInDates.sorted(by: >)
        guard !sortedDates.isEmpty else { return 0 }
        
        var consecutiveDays = 0
        var currentDate = calendar.startOfDay(for: Date())
        
        for date in sortedDates {
            let startOfDate = calendar.startOfDay(for: date)
            if calendar.isDate(startOfDate, inSameDayAs: currentDate) {
                consecutiveDays += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else {
                break
            }
        }
        return consecutiveDays
    }
}