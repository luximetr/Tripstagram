import SwiftUI

struct DefaultAppearanceImages: AppearanceImages {
    
    var like: Image { .init(systemName: "heart") }
    var comment: Image { .init(systemName: "message") }
    var repost: Image { .init(systemName: "arrow.2.squarepath") }
    var forward: Image { .init(systemName: "arrowshape.turn.up.forward") }
    var bookmark: Image { .init(systemName: "bookmark") }
    
}
