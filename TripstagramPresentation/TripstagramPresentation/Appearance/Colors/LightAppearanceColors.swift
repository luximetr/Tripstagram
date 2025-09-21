import Foundation
import SwiftUI

struct LightAppearanceColors: AppearanceColors {
    
    var primaryBackground: Color { .init(red: 0.977, green: 0.977, blue: 0.977, opacity: 1) }
    var secondaryBackground: Color { .init(red: 0.913, green: 0.913, blue: 0.913, opacity: 1) }
    var primaryBackgroundMaterial: UIBlurEffect.Style { .systemUltraThinMaterialLight }
    var primaryText: Color { .init(red: 0.106, green: 0.11, blue: 0.118, opacity: 1) }
    var secondaryText: Color { .init(red: 0.342, green: 0.342, blue: 0.342, opacity: 1) }
    var tertiaryText: Color { .init(red: 0.561, green: 0.561, blue: 0.604, opacity: 1) }
    var accent: Color { .init(red: 0.167, green: 0.404, blue: 0.758, opacity: 1) }
    
}
