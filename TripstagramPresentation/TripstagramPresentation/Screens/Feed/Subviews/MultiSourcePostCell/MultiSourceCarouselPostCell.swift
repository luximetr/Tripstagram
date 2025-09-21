import SwiftUI
import AVFoundation

struct MultiSourceCarouselPostCell: View {
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

    struct CarouselVideoPlayer: View {
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
