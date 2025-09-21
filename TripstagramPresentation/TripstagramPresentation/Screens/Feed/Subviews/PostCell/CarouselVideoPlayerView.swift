import SwiftUI
import AVFoundation

struct CarouselVideoPlayerView: View {
    let source: PostVideoSource
    let isVisible: Bool
    @State private var player: AVPlayer

    init(source: PostVideoSource, isVisible: Bool) {
        self.source = source
        self.isVisible = isVisible
        _player = State(wrappedValue: AVPlayer(url: source.url))
    }

    var body: some View {
        VideoPlayerView(player: player)
            .onAppear {
                player.isMuted = true
                if isVisible {
                    player.play()
                }
            }
            .onDisappear {
                player.pause()
            }
            .onChange(of: isVisible) {
                if isVisible {
                    player.seek(to: .zero)
                    player.play()
                } else {
                    player.pause()
                }
            }
    }
}
