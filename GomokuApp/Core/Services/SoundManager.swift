import AVFoundation
import SwiftUI

enum GameSound: String, CaseIterable {
    case placePiece = "place_piece"
    case win = "win"
    case lose = "lose"
    
    var systemSoundID: SystemSoundID {
        switch self {
        case .placePiece: return 1104
        case .win: return 1025
        case .lose: return 1053
        }
    }
}

class SoundManager: ObservableObject {
    static let shared = SoundManager()
    
    @AppStorage("soundEnabled") var soundEnabled: Bool = true
    @AppStorage("musicEnabled") var musicEnabled: Bool = true
    
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    
    private init() {
        configureAudioSession()
    }
    
    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }
    
    func play(_ sound: GameSound) {
        guard soundEnabled else { return }
        AudioServicesPlaySystemSound(sound.systemSoundID)
    }
    
    func playWin() {
        guard soundEnabled else { return }
        AudioServicesPlaySystemSound(1025)
    }
    
    func playLose() {
        guard soundEnabled else { return }
        AudioServicesPlaySystemSound(1053)
    }
    
    func playPlacePiece() {
        guard soundEnabled else { return }
        AudioServicesPlaySystemSound(1104)
    }
}