import Foundation

enum Player: Int, CaseIterable {
    case black = 1
    case white = 2
    
    var opponent: Player {
        self == .black ? .white : .black
    }
}

struct Position: Equatable, Hashable {
    let row: Int
    let col: Int
    
    static let invalid = Position(row: -1, col: -1)
}

enum GameResult: Equatable {
    case ongoing
    case win(Player)
    case draw
}