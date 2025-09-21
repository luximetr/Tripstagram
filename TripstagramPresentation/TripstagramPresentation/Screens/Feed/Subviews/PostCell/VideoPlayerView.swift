import SwiftUI
import AVFoundation

struct VideoPlayerView: UIViewRepresentable {
    let player: AVPlayer

    func makeUIView(context: Context) -> VideoPlayerUIView {
        VideoPlayerUIView(player: player)
    }

    func updateUIView(_ uiView: VideoPlayerUIView, context: Context) {
        
    }
}
