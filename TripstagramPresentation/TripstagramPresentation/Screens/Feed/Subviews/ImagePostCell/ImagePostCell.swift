import SwiftUI

struct ImagePostCell: View {
    let post: ImageOnlyPost
    
    @StateObject var viewModel: ImagePostCellViewModel
    
    init(post: ImageOnlyPost, viewModel: ImagePostCellViewModel) {
        self.post = post
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            if let imageURL = viewModel.imageURL {
                LocalImageView(fileURL: imageURL)
            } else {
                ProgressView()
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
        .onAppear {
            viewModel.onAppear()
        }
    }
}

#Preview {
    guard let imageURL = URL(string: "https://i.imgur.com/UUiBY.png") else { return Text("Invalid URL") }
    let post = ImageOnlyPost(id: "1", attachmentRemoteURL: imageURL)
    return ImagePostCell(
        post: post,
        viewModel: ImagePostCellViewModel(post: post)
    )
}
