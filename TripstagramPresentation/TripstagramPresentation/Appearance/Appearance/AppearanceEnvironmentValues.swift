import SwiftUI

extension EnvironmentValues {
    
    var appearance: Appearance {
        get { self[AppearanceKey.self] }
        set { self[AppearanceKey.self] = newValue }
    }
    
}

private struct AppearanceKey: @preconcurrency EnvironmentKey {
    @MainActor static let defaultValue: Appearance = CompositeAppearance(colors: LightAppearanceColors(), fonts: DefaultAppearanceFonts(), images: DefaultAppearanceImages())
}
