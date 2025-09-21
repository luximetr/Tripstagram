import Foundation
import SwiftUI

protocol AppearanceColors {

    var primaryBackground: Color { get }
    var secondaryBackground: Color { get }
    var primaryBackgroundMaterial: UIBlurEffect.Style { get }
    var primaryText: Color { get }
    var secondaryText: Color { get }
    var tertiaryText: Color { get }
    var accent: Color { get }
    
}
