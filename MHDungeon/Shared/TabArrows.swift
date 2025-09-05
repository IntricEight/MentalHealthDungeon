//
//  TabArrows.swift
//  MHDungeon
//

import SwiftUI

/// A suvbiew containing a set of chevron arrows that indicate which direction their button will cause the attached tab to move.
///
/// - Parameters:
///   - iconDirection: A `String` of either "up", "down", "forward", or "backward" which controls the arrow directions.
struct TabArrows: View {
    /// The direction of the displayed icon.
    private let iconDirection: String

    /// Create a pair of chevron arrows placed closely together.
    ///
    /// - Parameters:
    ///   - iconDirection: A `String` of either "up", "down", "forward", or "backward" which controls the arrow directions. 
    init(direction: String) {
        // Only allow the 4 supported directions
        precondition(["up", "down", "forward", "backward"].contains(direction), "Invalid icon direction provided: \(direction)")
        
        self.iconDirection = direction
    }
    
    var body: some View {
        // Control the display of the icons
        let IMAGE_SIZE = Image.Scale.large
        let CHEVRON_COLOR = Color.white
        
        // Control the layout stack using the arrow directions
        let layout: AnyLayout = (iconDirection == "up" || iconDirection == "down") ? AnyLayout(VStackLayout(spacing: 0)) : AnyLayout(HStackLayout(spacing: 0))
        
        // If the chevrons would line up best stacked vertically
        layout {
            Image(systemName: "chevron.compact.\(iconDirection)")
                .imageScale(IMAGE_SIZE)
                .foregroundColor(CHEVRON_COLOR)
                .bold()
            Image(systemName: "chevron.compact.\(iconDirection)")
                .imageScale(IMAGE_SIZE)
                .foregroundColor(CHEVRON_COLOR)
                .bold()
        }
    }
}

#Preview {
    TabArrows(direction: "up")
}
