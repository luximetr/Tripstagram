import Foundation
import AVFoundation

@MainActor
class VideoPostCellViewModel: ObservableObject, @MainActor PostCellViewModel {
    
    // MARK: - Init
    
    init(post: VideoOnlyPost) {
        self.post = post
        let player = AVPlayer(url: post.attachmentRemoteURL)
        player.isMuted = true
        self._player = Published(wrappedValue: player)
    }
    
    // MARK: - View life cycle
    
    func onAppear() {
        player.play()
    }
    
    func onDisappear() {
        player.pause()
    }
    
    // MARK: - Post
    
    var id: String { post.id }
    let post: VideoOnlyPost
    
    @Published var player: AVPlayer
}
