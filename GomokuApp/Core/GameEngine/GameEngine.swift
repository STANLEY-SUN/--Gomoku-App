import Foundation

enum GameMode {
    case pvp
    case pveEasy
    case pveMedium
    case pveHard
}

class GameEngine: ObservableObject {
    @Published var board: GameBoard
    @Published var currentPlayer: Player
    @Published var gameResult: GameResult
    @Published var gameMode: GameMode
    @Published var isAIThinking: Bool
    
    private let directions: [(Int, Int)] = [
        (0, 1),   // horizontal
        (1, 0),   // vertical
        (1, 1),   // diagonal \
        (1, -1)   // diagonal /
    ]
    
    init(mode: GameMode = .pveMedium) {
        board = GameBoard()
        currentPlayer = .black
        gameResult = .ongoing
        gameMode = mode
        isAIThinking = false
    }
    
    func placePiece(at position: Position) -> Bool {
        guard case .ongoing = gameResult else { return false }
        guard !isAIThinking else { return false }
        
        let success = board.placePiece(currentPlayer, at: position)
        if success {
            checkWin(at: position)
            if case .ongoing = gameResult {
                switchPlayer()
            }
        }
        return success
    }
    
    func undo() -> Bool {
        guard board.moveCount > 0 else { return false }
        
        if let lastPos = board.lastMove() {
            _ = board.removePiece(at: lastPos)
            switchPlayer()
            gameResult = .ongoing
            return true
        }
        return false
    }
    
    func reset() {
        board.reset()
        currentPlayer = .black
        gameResult = .ongoing
        isAIThinking = false
    }
    
    private func switchPlayer() {
        currentPlayer = currentPlayer.opponent
        
        if case .ongoing = gameResult, isPVE {
            if currentPlayer == .white {
                performAIMove()
            }
        }
    }
    
    var isPVE: Bool {
        switch gameMode {
        case .pveEasy, .pveMedium, .pveHard:
            return true
        case .pvp:
            return false
        }
    }
    
    private func checkWin(at position: Position) {
        guard let player = board.getPlayer(at: position) else { return }
        
        let directions: [(Int, Int)] = [
            (0, 1),   // horizontal
            (1, 0),   // vertical
            (1, 1),   // diagonal \
            (1, -1)    // diagonal /
        ]
        
        for (dr, dc) in directions {
            var count = 1
            
            // positive direction
            var r = position.row + dr
            var c = position.col + dc
            while let p = board.getPlayer(at: Position(row: r, col: c)), p == player {
                count += 1
                r += dr
                c += dc
            }
            
            // negative direction
            r = position.row - dr
            c = position.col - dc
            while let p = board.getPlayer(at: Position(row: r, col: c)), p == player {
                count += 1
                r -= dr
                c -= dc
            }
            
            if count >= GameBoard.winCount {
                gameResult = .win(player)
                return
            }
        }
        
        if board.isFull {
            gameResult = .draw
        }
    }
    
    private func performAIMove() {
        isAIThinking = true
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            let move = self.calculateAIMove()
            
            Thread.sleep(forTimeInterval: 0.5)
            
            DispatchQueue.main.async {
                self.isAIThinking = false
                _ = self.board.placePiece(.white, at: move)
                self.checkWin(at: move)
                if case .ongoing = self.gameResult {
                    self.currentPlayer = .black
                }
            }
        }
    }
    
    private func calculateAIMove() -> Position {
        switch gameMode {
        case .pveEasy:
            return randomMove()
        case .pveMedium:
            return smartMove(depth: 2)
        case .pveHard:
            return smartMove(depth: 3)
        default:
            return randomMove()
        }
    }
    
    private func randomMove() -> Position {
        var availableMoves: [Position] = []
        for r in 0..<GameBoard.boardSize {
            for c in 0..<GameBoard.boardSize {
                let pos = Position(row: r, col: c)
                if board.isEmpty(at: pos) {
                    if hasNeighbor(pos) {
                        availableMoves.append(pos)
                    }
                }
            }
        }
        
        if availableMoves.isEmpty {
            for r in 0..<GameBoard.boardSize {
                for c in 0..<GameBoard.boardSize {
                    let pos = Position(row: r, col: c)
                    if board.isEmpty(at: pos) {
                        availableMoves.append(pos)
                    }
                }
            }
        }
        
        return availableMoves.randomElement() ?? Position(row: 7, col: 7)
    }
    
    private func hasNeighbor(_ pos: Position) -> Bool {
        for dr in -2...2 {
            for dc in -2...2 {
                if dr == 0 && dc == 0 { continue }
                let neighbor = Position(row: pos.row + dr, col: pos.col + dc)
                if board.getPlayer(at: neighbor) != nil {
                    return true
                }
            }
        }
        return false
    }
    
    private func smartMove(depth: Int) -> Position {
        if board.moveCount < 2 {
            return strategicMove()
        }
        
        var bestScore = Int.min
        var bestMove = Position(row: 7, col: 7)
        
        for r in 0..<GameBoard.boardSize {
            for c in 0..<GameBoard.boardSize {
                let pos = Position(row: r, col: c)
                if board.isEmpty(at: pos) && hasNeighbor(pos) {
                    let score = evaluatePosition(pos, for: .white, depth: depth)
                    if score > bestScore {
                        bestScore = score
                        bestMove = pos
                    }
                }
            }
        }
        
        if bestMove == Position.invalid || !hasNeighbor(bestMove) {
            return strategicMove()
        }
        
        return bestMove
    }
    
    private func strategicMove() -> Position {
        let center = Position(row: 7, col: 7)
        if board.isEmpty(at: center) {
            return center
        }
        
        let ring1: [Position] = [
            Position(row: 6, col: 6), Position(row: 6, col: 7), Position(row: 6, col: 8),
            Position(row: 7, col: 6), Position(row: 7, col: 8),
            Position(row: 8, col: 6), Position(row: 8, col: 7), Position(row: 8, col: 8)
        ]
        
        for pos in ring1 {
            if board.isEmpty(at: pos) {
                return pos
            }
        }
        
        return randomMove()
    }
    
    private func evaluatePosition(_ pos: Position, for player: Player, depth: Int) -> Int {
        var score = 0
        
        score += evaluateLine(at: pos, player: player)
        score += evaluateLine(at: pos, player: player.opponent) / 2
        
        return score
    }
    
    private func evaluateLine(at pos: Position, player: Player) -> Int {
        var totalScore = 0
        
        for (dr, dc) in directions {
            var count = 1
            var openEnds = 0
            
            var r = pos.row + dr
            var c = pos.col + dc
            while let p = board.getPlayer(at: Position(row: r, col: c)), p == player {
                count += 1
                r += dr
                c += dc
            }
            if board.isEmpty(at: Position(row: r, col: c)) && board.isValidPosition(Position(row: r, col: c)) {
                openEnds += 1
            }
            
            r = pos.row - dr
            c = pos.col - dc
            while let p = board.getPlayer(at: Position(row: r, col: c)), p == player {
                count += 1
                r -= dr
                c -= dc
            }
            if board.isEmpty(at: Position(row: r, col: c)) && board.isValidPosition(Position(row: r, col: c)) {
                openEnds += 1
            }
            
            if count >= 5 {
                return 100000
            } else if count == 4 && openEnds == 2 {
                totalScore += 10000
            } else if count == 4 && openEnds == 1 {
                totalScore += 1000
            } else if count == 3 && openEnds == 2 {
                totalScore += 1000
            } else if count == 3 && openEnds == 1 {
                totalScore += 100
            } else {
                totalScore += count * count * 10
            }
        }
        
        return totalScore
    }
}