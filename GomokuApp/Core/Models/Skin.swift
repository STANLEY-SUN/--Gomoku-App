import Foundation
import SwiftUI

enum Skin: String, CaseIterable, Identifiable, Codable {
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
    
    var blackStoneColor: Color {
        switch self {
        case .classic: return Color(hex: "1A1A1A")
        case .mint: return Color(hex: "2E8B57")
        case .warmOrange: return Color(hex: "FF8C00")
        case .sakura: return Color(hex: "FF69B4")
        case .otherWorld: return Color(hex: "6A0DAD")
        case .futureTech: return Color(hex: "00FFFF")
        case .dunhuang: return Color(hex: "DAA520")
        case .bronze: return Color(hex: "CD7F32")
        }
    }
    
    var whiteStoneColor: Color {
        switch self {
        case .classic: return Color(hex: "F5F5F5")
        case .mint: return Color(hex: "98FB98")
        case .warmOrange: return Color(hex: "FFE4B5")
        case .sakura: return Color(hex: "FFC0CB")
        case .otherWorld: return Color(hex: "E6E6FA")
        case .futureTech: return Color(hex: "FF00FF")
        case .dunhuang: return Color(hex: "FFD700")
        case .bronze: return Color(hex: "B8860B")
        }
    }
    
    var boardColor: Color {
        switch self {
        case .classic: return Color(hex: "DEB887")
        case .mint: return Color(hex: "98FB98")
        case .warmOrange: return Color(hex: "FFDEAD")
        case .sakura: return Color(hex: "FFB7C5")
        case .otherWorld: return Color(hex: "2E2E2E")
        case .futureTech: return Color(hex: "0A0A0A")
        case .dunhuang: return Color(hex: "8B4513")
        case .bronze: return Color(hex: "8B4513")
        }
    }
    
    var lineColor: Color {
        switch self {
        case .classic: return Color(hex: "5C4033")
        case .mint: return Color(hex: "228B22")
        case .warmOrange: return Color(hex: "FF8C00")
        case .sakura: return Color(hex: "DB7093")
        case .otherWorld: return Color(hex: "9370DB")
        case .futureTech: return Color(hex: "00CED1")
        case .dunhuang: return Color(hex: "FFD700")
        case .bronze: return Color(hex: "B8860B")
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .classic: return Color(hex: "F5F5F5")
        case .mint: return Color(hex: "E0FFE0")
        case .warmOrange: return Color(hex: "FFF8DC")
        case .sakura: return Color(hex: "FFF0F5")
        case .otherWorld: return Color(hex: "1A1A2E")
        case .futureTech: return Color(hex: "000000")
        case .dunhuang: return Color(hex: "2F1810")
        case .bronze: return Color(hex: "2F1810")
        }
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