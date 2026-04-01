import SwiftUI

class AppState: ObservableObject {
    @Published var currentUser: User?
    @Published var selectedSkin: Skin = .classic
    @Published var coins: Int = 0
    @Published var checkInDays: Int = 0
    @Published var isPremium: Bool = false
    @Published var totalWins: Int = 0
    
    init() {
        loadUserData()
    }
    
    private func loadUserData() {
        coins = UserDefaults.standard.integer(forKey: Keys.coins)
        checkInDays = UserDefaults.standard.integer(forKey: Keys.checkInDays)
        isPremium = UserDefaults.standard.bool(forKey: Keys.isPremium)
        totalWins = UserDefaults.standard.integer(forKey: Keys.totalWins)
        if let skinId = UserDefaults.standard.string(forKey: Keys.selectedSkin) {
            selectedSkin = Skin(rawValue: skinId) ?? .classic
        }
    }
    
    func saveUserData() {
        UserDefaults.standard.set(coins, forKey: Keys.coins)
        UserDefaults.standard.set(checkInDays, forKey: Keys.checkInDays)
        UserDefaults.standard.set(isPremium, forKey: Keys.isPremium)
        UserDefaults.standard.set(selectedSkin.rawValue, forKey: Keys.selectedSkin)
        UserDefaults.standard.set(totalWins, forKey: Keys.totalWins)
    }
}

struct User: Identifiable {
    let id: String
    var username: String
    var wins: Int
    var losses: Int
    var winStreak: Int
}

struct Keys {
    static let coins = "user_coins"
    static let checkInDays = "check_in_days"
    static let isPremium = "is_premium"
    static let selectedSkin = "selected_skin"
    static let lastCheckInDate = "last_check_in_date"
    static let unlockedSkins = "unlocked_skins"
    static let totalWins = "total_wins"
}