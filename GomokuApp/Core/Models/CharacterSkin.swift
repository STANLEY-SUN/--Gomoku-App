import Foundation

struct CharacterSkin: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let description: String
    let rarity: Rarity
    let primaryColor: String
    let secondaryColor: String
    let isDefault: Bool
    
    enum Rarity: String, Codable {
        case common
        case rare
        case epic
        case legendary
    }
    
    static let defaultSkin = CharacterSkin(
        id: "default",
        name: "棋士",
        description: "默认皮肤",
        rarity: .common,
        primaryColor: "4A90D9",
        secondaryColor: "FFFFFF",
        isDefault: true
    )
    
    static let allSkins: [CharacterSkin] = [
        defaultSkin,
        CharacterSkin(
            id: "sakura",
            name: "樱花",
            description: "春日樱花",
            rarity: .common,
            primaryColor: "FFB7C5",
            secondaryColor: "FFFFFF",
            isDefault: false
        ),
        CharacterSkin(
            id: "ocean",
            name: "海风",
            description: "清新海风",
            rarity: .rare,
            primaryColor: "00CED1",
            secondaryColor: "87CEEB",
            isDefault: false
        ),
        CharacterSkin(
            id: "dragon",
            name: "青龙",
            description: "东方神龙",
            rarity: .epic,
            primaryColor: "228B22",
            secondaryColor: "FFD700",
            isDefault: false
        ),
        CharacterSkin(
            id: "phoenix",
            name: "朱雀",
            description: "浴火重生",
            rarity: .legendary,
            primaryColor: "FF4500",
            secondaryColor: "FFD700",
            isDefault: false
        )
    ]
}