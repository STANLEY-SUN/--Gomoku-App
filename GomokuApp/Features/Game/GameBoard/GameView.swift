import SwiftUI

struct GameView: View {
    @StateObject private var gameEngine: GameEngine
    @State private var showModeSelection = false
    @State private var showResult = false
    @State private var showVictoryEffect = false
    @Environment(\.dismiss) private var dismiss
    @StateObject private var soundManager = SoundManager.shared
    @StateObject private var dataManager = DataManager.shared
    @EnvironmentObject var appState: AppState
    var skin: Skin = .classic
    
    init(mode: GameMode = .pveMedium, skin: Skin = .classic) {
        _gameEngine = StateObject(wrappedValue: GameEngine(mode: mode))
        self.skin = skin
    }
    
    private var gameBackground: Color { skin.backgroundColor }
    
    var body: some View {
        NavigationStack {
            VStack(spacing:0) {
                topBar
                
                gameInfo
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                
                Spacer()
                
                boardView
                    .padding(16)
                
                Spacer()
                
                bottomBar
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
            }
            .background(
            ZStack {
                gameBackground
                if skin != .classic {
                    ContinuousLightEffect(skin: skin)
                        .ignoresSafeArea()
                }
            }
        )
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("退出") {
                    dismiss()
                }
                    .foregroundColor(Color.theme.primary),
                trailing: Button(action: { gameEngine.reset() }) {
                    Image(systemName: "arrow.counterclockwise")
                        .foregroundColor(Color.theme.primary)
                }
            )
        }
        .onChange(of: gameEngine.gameResult) { newValue in
            if case .ongoing = newValue {
                showResult = false
                showVictoryEffect = false
            } else {
                showResult = true
                switch newValue {
                case .win(let player):
                    if player == .black {
                        soundManager.playWin()
                        dataManager.recordGameResult(winner: .black)
                        appState.totalWins += 1
                        appState.saveUserData()
                        showVictoryEffect = true
                    } else {
                        soundManager.playLose()
                        dataManager.recordGameResult(winner: .white)
                    }
                case .draw:
                    soundManager.playLose()
                    dataManager.recordGameResult(winner: nil)
                case .ongoing:
                    break
                }
            }
        }
        .alert("游戏结束", isPresented: $showResult) {
            Button("再来一局") {
                gameEngine.reset()
            }
            Button("返回", role: .cancel) {
            }
        } message: {
            switch gameEngine.gameResult {
            case .win(let player):
                Text(player == .black ? "黑方获胜！" : "白方获胜！")
            case .draw:
                Text("平局！")
            case .ongoing:
                Text("")
            }
        }
        .fullScreenCover(isPresented: $showVictoryEffect) {
            if case .win(let player) = gameEngine.gameResult {
                VictoryEffectView(winner: player) {
                    showVictoryEffect = false
                }
            }
        }
    }
    
    private var topBar: some View {
        HStack {
            Text("当前：\(gameEngine.currentPlayer == .black ? "黑方" : "白方")")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color.theme.text)
            
            Spacer()
            
            if gameEngine.isAIThinking {
                ProgressView()
                    .scaleEffect(0.8)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
    
    private var gameInfo: some View {
        HStack {
            Text("步数：\(gameEngine.board.moveCount)")
                .font(.system(size: 14))
                .foregroundColor(Color.theme.textSecondary)
            
            Spacer()
            
            Text(modeText)
                .font(.system(size: 14))
                .foregroundColor(Color.theme.textSecondary)
        }
    }
    
    private var modeText: String {
        switch gameEngine.gameMode {
        case .pvp: return "双人对战"
        case .pveEasy: return "简单AI"
        case .pveMedium: return "中等AI"
        case .pveHard: return "��难AI"
        }
    }
    
    private var boardView: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let cellSize = size / CGFloat(GameBoard.boardSize)
            
            ZStack {
                boardBackground(size: size, cellSize: cellSize)
                
                piecesView(cellSize: cellSize)
                
                skinElementsOverlay(size: size)
            }
            .frame(width: size, height: size)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .onTapGesture { location in
                handleTap(location: location, cellSize: cellSize)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .background(gameSkin.boardColor)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private var gameSkin: Skin { skin }
    
    private func skinElementsOverlay(size: CGFloat) -> some View {
        switch gameSkin {
        case .classic:
            return AnyView(EmptyView())
        case .mint:
            return AnyView(MintLeafView(size: size))
        case .warmOrange:
            return AnyView(SunRaysView(size: size))
        case .sakura:
            return AnyView(SakuraElementsView(size: size))
        case .otherWorld:
            return AnyView(MagicCircleView(size: size))
        case .futureTech:
            return AnyView(CircuitBoardView(size: size))
        case .dunhuang:
            return AnyView(CloudPatternView(size: size))
        case .bronze:
            return AnyView(BronzePatternView(size: size))
        }
    }
    
    private func boardBackground(size: CGFloat, cellSize: CGFloat) -> some View {
        let boardColor = gameSkin.boardColor
        let lineColor = gameSkin.lineColor
        return ZStack {
            boardColor
            
            ForEach(0..<GameBoard.boardSize, id: \.self) { row in
                ForEach(0..<GameBoard.boardSize, id: \.self) { col in
                    Rectangle()
                        .stroke(lineColor, lineWidth: 0.5)
                        .frame(width: cellSize, height: cellSize)
                        .position(
                            x: CGFloat(col) * cellSize + cellSize / 2,
                            y: CGFloat(row) * cellSize + cellSize / 2
                        )
                }
            }
            
            if let starPoints = starPoints() {
                ForEach(starPoints, id: \.self) { point in
                    Circle()
                        .fill(Color.boardLine)
                        .frame(width: 6, height: 6)
                        .position(
                            x: CGFloat(point.col) * cellSize + cellSize / 2,
                            y: CGFloat(point.row) * cellSize + cellSize / 2
                        )
                }
            }
        }
    }
    
    private func piecesView(cellSize: CGFloat) -> some View {
        ZStack {
            ForEach(0..<GameBoard.boardSize, id: \.self) { row in
                ForEach(0..<GameBoard.boardSize, id: \.self) { col in
                    let pos = Position(row: row, col: col)
                    if let player = gameEngine.board.getPlayer(at: pos) {
                        AnimatedPieceView(player: player, size: cellSize * 0.85, skin: skin)
                            .id("\(row)-\(col)-\(gameEngine.board.moveHistory.count)")
                            .position(
                                x: CGFloat(col) * cellSize + cellSize / 2,
                                y: CGFloat(row) * cellSize + cellSize / 2
                            )
                    }
                }
            }
            
            if let lastMove = gameEngine.board.lastMove() {
                let cellSize2 = cellSize * 0.3
                Circle()
                    .stroke(Color.theme.accent, lineWidth: 2)
                    .frame(width: cellSize2, height: cellSize2)
                    .position(
                        x: CGFloat(lastMove.col) * cellSize + cellSize / 2,
                        y: CGFloat(lastMove.row) * cellSize + cellSize / 2
                    )
            }
        }
    }
    
    private func pieceView(player: Player, size: CGFloat) -> some View {
        let blackColor = skin.blackStoneColor
        let whiteColor = skin.whiteStoneColor
        return Circle()
            .fill(
                RadialGradient(
                    colors: player == .black 
                        ? [blackColor.opacity(0.8), blackColor]
                        : [whiteColor.opacity(0.9), whiteColor.opacity(0.7)],
                    center: .center,
                    startRadius: 0,
                    endRadius: size / 2
                )
            )
            .frame(width: size, height: size)
            .shadow(color: .black.opacity(0.3), radius: 2, x: 1, y: 1)
    }
    
    private var bottomBar: some View {
        HStack {
            Button(action: {
                if gameEngine.undo() {
                }
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.uturn.backward")
                    Text("悔棋")
                }
                .font(.system(size: 14))
                .foregroundColor(gameEngine.board.moveCount > 0 ? Color.theme.primary : Color.theme.textSecondary)
            }
            .disabled(gameEngine.board.moveCount == 0)
            
            Spacer()
        }
    }
    
    private func handleTap(location: CGPoint, cellSize: CGFloat) {
        guard case .ongoing = gameEngine.gameResult else { return }
        guard !gameEngine.isAIThinking else { return }
        
        let col = Int(location.x / cellSize)
        let row = Int(location.y / cellSize)
        
        let position = Position(row: row, col: col)
        
        if gameEngine.board.isValidPosition(position) && gameEngine.board.isEmpty(at: position) {
            let placed = gameEngine.placePiece(at: position)
            if placed {
                soundManager.playPlacePiece()
            }
        }
    }
    
    private func starPoints() -> [Position]? {
        guard GameBoard.boardSize == 15 else { return nil }
        return [
            Position(row: 3, col: 3),
            Position(row: 3, col: 11),
            Position(row: 7, col: 7),
            Position(row: 11, col: 3),
            Position(row: 11, col: 11)
        ]
    }
}