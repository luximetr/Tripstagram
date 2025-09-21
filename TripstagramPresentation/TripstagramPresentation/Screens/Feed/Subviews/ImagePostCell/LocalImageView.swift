import SwiftUI

struct LocalImageView: View {
    let fileURL: URL

    var body: some View {
        if let uiImage = UIImage(contentsOfFile: fileURL.path) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
        } else {
            Color.gray
        }
    }
}
