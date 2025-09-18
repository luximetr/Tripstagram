import SwiftUI
import AVKit

public struct PresentationView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @StateObject var viewModel: PresentationViewModel
    
    @State var posts: [any Post] = [
        ImagePost(id: UUID(), url: URL(string: "https://i.imgur.com/96vtL.png")!),
        ImagePost(id: UUID(), url: URL(string: "https://i.imgur.com/UUiBY.png")!),
        VideoPost(id: UUID(), url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!),
        VideoPost(id: UUID(), url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!)
    ]
    
    public init(viewModel: PresentationViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        List(posts, id: \.id) { post in
            if let imagePost = post as? ImagePost {
                ImagePostCell(post: imagePost)
            } else if let video = post as? VideoPost {
                VideoPostCell(post: video)
            } else {
                Text("Unsupported post type")
            }
        }
        .listStyle(.inset)
    }
}

private struct ImagePostCell: View {
    let post: ImagePost
    
    var body: some View {
        VStack {
            AsyncImage(url: post.url) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Rectangle().fill(.secondary.opacity(0.15))
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity)
                    .aspectRatio(1, contentMode: .fit)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                case .failure:
                    ZStack {
                        Rectangle().fill(.secondary.opacity(0.15))
                        Image(systemName: "photo")
                            .imageScale(.large)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .aspectRatio(1, contentMode: .fit)
                @unknown default:
                    EmptyView()
                }
            }
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
    }
}

private struct VideoPostCell: View {
    let post: VideoPost
    @State private var player: AVPlayer

    init(post: VideoPost) {
        self.post = post
        let player = AVPlayer(url: post.url)
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


protocol Post: Identifiable {
    var id: UUID { get }
}

struct ImagePost: Post {
    let id: UUID
    let url: URL
}

struct VideoPost: Post {
    let id: UUID
    let url: URL
}

private struct CustomVideoPlayer: UIViewRepresentable {
    let player: AVPlayer

    func makeUIView(context: Context) -> PlayerUIView {
        PlayerUIView(player: player)
    }

    func updateUIView(_ uiView: PlayerUIView, context: Context) {
        // This view does not need to be updated.
    }
}

private class PlayerUIView: UIView {
    private var playerLayer: AVPlayerLayer {
        layer as! AVPlayerLayer
    }

    var player: AVPlayer? {
        get {
            playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }

    override static var layerClass: AnyClass {
        AVPlayerLayer.self
    }
    
    init(player: AVPlayer) {
        super.init(frame: .zero)
        self.player = player
        playerLayer.videoGravity = .resizeAspect
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


#Preview {
    PresentationView(viewModel: PresentationViewModel())
}
