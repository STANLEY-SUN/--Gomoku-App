import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let primary = Color(hex: "4A90D9")
    let secondary = Color(hex: "7CB342")
    let accent = Color(hex: "FF9800")
    let background = Color(hex: "F5F5F5")
    let surface = Color.white
    let textPrimary = Color(hex: "333333")
    let textSecondary = Color(hex: "999999")
    let boardBackground = Color(hex: "DEB887")
    let blackStone = Color(hex: "1A1A1A")
    let whiteStone = Color(hex: "F5F5F5")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct AppFont {
    static func title() -> Font {
        .system(size: 24, weight: .bold)
    }
    
    static func headline() -> Font {
        .system(size: 18, weight: .semibold)
    }
    
    static func body() -> Font {
        .system(size: 16, weight: .regular)
    }
    
    static func caption() -> Font {
        .system(size: 14, weight: .regular)
    }
    
    static func small() -> Font {
        .system(size: 12, weight: .regular)
    }
}