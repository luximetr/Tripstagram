import SwiftUI

struct PostActionsView: View {
    
    // MARK: - Appearance
    
    @Environment(\.appearance) private var appearance
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            appearance.images.like
                .foregroundStyle(appearance.colors.primaryText)
            appearance.images.comment
                .foregroundStyle(appearance.colors.primaryText)
            appearance.images.repost
                .foregroundStyle(appearance.colors.primaryText)
            appearance.images.forward
                .foregroundStyle(appearance.colors.primaryText)
            Spacer()
            appearance.images.bookmark
                .foregroundStyle(appearance.colors.primaryText)
        }
    }
}

#Preview {
    @Previewable @Environment(\.colorScheme) var colorScheme
    
    PostActionsView()
        .environment(\.appearance, CompositeAppearance(colorScheme: colorScheme))
}
