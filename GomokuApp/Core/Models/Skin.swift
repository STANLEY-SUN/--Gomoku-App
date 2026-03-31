import Foundation

enum Skin: String, CaseIterable, Identifiable {
    case classic = "classic"
    case mint = "mint"
    case warmOrange = "warm_orange"
    case sakura = "sakura"
    case otherWorld = "other_world"
    case futureTech = "future_travel"
    case dunhuang = "dunhuang"
    case bronze = "bronze"
    
    var id: String { rawValue }
    
    var name: String {
        switch self {
        case .classic: return "经典黑白"
        case .mint: return "清新薄荷"
        case .warmOrange: return "暖阳橙日"
        case .sakura: return "樱花物语"
        case .otherWorld: return "异世界冒险"
        case .futureTech: return "未来科技"
        case .dunhuang: return "敦煌飞天"
        case .bronze: return "青铜古韵"
        }
    }
    
    var isDefault: Bool {
        switch self {
        case .classic, .mint, .warmOrange: return true
        default: return false
        }
    }
    
    var price: Double? {
        isDefault ? nil : 0.99
    }
}

struct SkinData: Identifiable {
    let id: String
    let name: String
    let description: String
    let price: Double?
    let isDefault: Bool
    
    init(skin: Skin) {
        self.id = skin.rawValue
        self.name = skin.name
        self.description = ""
        self.price = skin.price
        self.isDefault = skin.isDefault
    }
}