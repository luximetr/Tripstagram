import SwiftUI

public struct PresentationView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @StateObject var viewModel: PresentationViewModel
    
    @State var posts: [any Post] = [
        ImagePost(id: UUID(), url: URL(string: "https://i.imgur.com/96vtL.png")!),
        ImagePost(id: UUID(), url: URL(string: "https://i.imgur.com/UUiBY.png")!)
    ]
    
    public init(viewModel: PresentationViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        List(posts, id: \.id) { post in
            if let imagePost = post as? ImagePost {
                ImagePostCell(post: imagePost)
            } else if let video = post as? VideoPost {
                Text("Video: \(video.url.absoluteString)")
            } else {
                Text("Unsupported post type")
            }
        }
        .listStyle(.inset)
    }
    
    func ImagePostCell(post: ImagePost) -> some View {
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

#Preview {
    PresentationView(viewModel: PresentationViewModel())
}
