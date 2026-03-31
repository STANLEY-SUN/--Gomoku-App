import Foundation

struct GameBoard {
    static let boardSize = 15
    static let winCount = 5
    
    private var cells: [[Player?]]
    private(set) var moveHistory: [Position]
    
    init() {
        cells = Array(repeating: Array(repeating: nil, count: GameBoard.boardSize), count: GameBoard.boardSize)
        moveHistory = []
    }
    
    func getPlayer(at position: Position) -> Player? {
        guard isValidPosition(position) else { return nil }
        return cells[position.row][position.col]
    }
    
    mutating func placePiece(_ player: Player, at position: Position) -> Bool {
        guard isValidPosition(position) else { return false }
        guard cells[position.row][position.col] == nil else { return false }
        
        cells[position.row][position.col] = player
        moveHistory.append(position)
        return true
    }
    
    mutating func removePiece(at position: Position) -> Bool {
        guard isValidPosition(position) else { return false }
        guard cells[position.row][position.col] != nil else { return false }
        
        cells[position.row][position.col] = nil
        if let index = moveHistory.lastIndex(of: position) {
            moveHistory.remove(at: index)
        }
        return true
    }
    
    mutating func reset() {
        cells = Array(repeating: Array(repeating: nil, count: GameBoard.boardSize), count: GameBoard.boardSize)
        moveHistory = []
    }
    
    func isValidPosition(_ position: Position) -> Bool {
        return position.row >= 0 && position.row < GameBoard.boardSize &&
               position.col >= 0 && position.col < GameBoard.boardSize
    }
    
    func isEmpty(at position: Position) -> Bool {
        guard isValidPosition(position) else { return false }
        return cells[position.row][position.col] == nil
    }
    
    var isFull: Bool {
        return moveHistory.count >= GameBoard.boardSize * GameBoard.boardSize
    }
    
    var moveCount: Int {
        return moveHistory.count
    }
    
    func lastMove() -> Position? {
        return moveHistory.last
    }
}