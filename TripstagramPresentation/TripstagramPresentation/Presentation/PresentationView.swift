import SwiftUI
import AVKit

public struct PresentationView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @StateObject var viewModel: PresentationViewModel
    
    @State var posts: [any Post] = [
        ImageOnlyPost(id: UUID(), source: .init(url: URL(string: "https://i.imgur.com/96vtL.png")!)),
        ImageOnlyPost(id: UUID(), source: .init(url: URL(string: "https://i.imgur.com/UUiBY.png")!)),
        MultiSourcePost(id: UUID(), sources: [
            PostImageSource(url: URL(string: "https://i.imgur.com/ZXs3p5F.png")!),
            PostVideoSource(url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4")!),
            PostImageSource(url: URL(string: "https://i.imgur.com/h5T2a8G.jpeg")!)
        ]),
        VideoOnlyPost(id: UUID(), source: .init(url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!)),
        VideoOnlyPost(id: UUID(), source: .init(url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!))
    ]
    
    public init(viewModel: PresentationViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        List(posts, id: \.id) { post in
            if let imagePost = post as? ImageOnlyPost {
                ImagePostCell(post: imagePost)
            } else if let video = post as? VideoOnlyPost {
                VideoPostCell(post: video)
            } else if let multiSource = post as? MultiSourcePost {
                MultiSourceCarouselPostCell(post: multiSource)
            } else {
                Text("Unsupported post type")
            }
        }
        .listStyle(.inset)
    }
}

private struct ImagePostCell: View {
    let post: ImageOnlyPost
    
    var body: some View {
        VStack {
            AsyncImage(url: post.source.url) { phase in
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

private struct MultiSourceCarouselPostCell: View {
    let post: MultiSourcePost
    @State private var selection: Int = 0

    var body: some View {
        VStack(spacing: 8) {
            TabView(selection: $selection) {
                ForEach(Array(post.sources.enumerated()), id: \.offset) { index, source in
                    Group {
                        if let imageSource = source as? PostImageSource {
                            AsyncImage(url: imageSource.url) { phase in
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
                        } else if let videoSource = source as? PostVideoSource {
                            CarouselVideoPlayer(source: videoSource, isVisible: selection == index)
                        }
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page)
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
    }

    private struct CarouselVideoPlayer: View {
        let source: PostVideoSource
        let isVisible: Bool
        @State private var player: AVPlayer

        init(source: PostVideoSource, isVisible: Bool) {
            self.source = source
            self.isVisible = isVisible
            _player = State(wrappedValue: AVPlayer(url: source.url))
        }

        var body: some View {
            CustomVideoPlayer(player: player)
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
}


protocol Post: Identifiable {
    var id: UUID { get }
}

struct ImageOnlyPost: Post {
    let id: UUID
    let source: PostImageSource
}

struct VideoOnlyPost: Post {
    let id: UUID
    let source: PostVideoSource
}

struct MultiSourcePost: Post {
    let id: UUID
    let sources: [PostSource]
}

protocol PostSource {
    
}

struct PostImageSource: PostSource {
    let url: URL
}

struct PostVideoSource: PostSource {
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
