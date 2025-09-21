import SwiftUI
import AVFoundation

struct VideoPostCell: View {
    let post: VideoOnlyPost
    @State private var player: AVPlayer

    init(post: VideoOnlyPost) {
        self.post = post
        let player = AVPlayer(url: post.source.url)
        player.isMuted = true
        self._player = State(wrappedValue: player)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            CustomVideoPlayer(player: player)
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            HStack {
                Image(systemName: "heart")
                Image(systemName: "message")
                Image(systemName: "arrow.2.squarepath")
                Image(systemName: "arrowshape.turn.up.forward")
                Spacer()
                Image(systemName: "bookmark")
            }
            HStack {
                Text("Comment")
                Text("more")
                    .foregroundStyle(.secondary)
                Spacer()
            }
            HStack {
                Text("12 hours ago")
                Spacer()
            }
        }
        .onAppear {
            player.play()
        }
        .onDisappear {
            player.pause()
        }
    }
}
