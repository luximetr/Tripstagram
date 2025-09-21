import SwiftUI

struct DarkAppearanceColors: AppearanceColors {
    
    var primaryBackground: Color { .init(red: 0.106, green: 0.11, blue: 0.118, opacity: 1) }
    var secondaryBackground: Color { .init(red: 0.158, green: 0.158, blue: 0.158, opacity: 1) }
    var primaryBackgroundMaterial: UIBlurEffect.Style { .systemUltraThinMaterialDark }
    var primaryText: Color { .init(red: 0.977, green: 0.977, blue: 0.977, opacity: 1) }
    var secondaryText: Color { .init(red: 0.658, green: 0.658, blue: 0.658, opacity: 1) }
    var tertiaryText: Color { .init(red: 0.383, green: 0.383, blue: 0.383, opacity: 1) }
    var accent: Color { .init(red: 0.429, green: 0.657, blue: 1, opacity: 1) }
    
}
