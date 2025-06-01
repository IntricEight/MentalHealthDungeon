//
//  NavBarArrows.swift
//  MHDungeon
//

import SwiftUI

/// A suvbiew containing a set of chevron arrows that indicate which direction their button will cause the navigation bar to move.
///
/// - Parameters:
///   - iconDirection: A `String` of either "up" or "down" which controls the arrow directions.
struct NavBarArrows: View {
    /// The visibility toggle for the external feature.
//    @Binding var navBarVisible: Bool
    let iconDirection: String

    var body: some View {
        // Control the display of the icons
        let IMAGE_SIZE = Image.Scale.large
        let CHEVRON_COLOR = Color.white
        
        VStack {
            Image(systemName: "chevron.compact.\(iconDirection)")
                .imageScale(IMAGE_SIZE)
                .foregroundColor(CHEVRON_COLOR)
                .bold()
            Image(systemName: "chevron.compact.\(iconDirection)")
                .imageScale(IMAGE_SIZE)
                .foregroundColor(CHEVRON_COLOR)
                .bold()
        }
        
        // TODO: Figure out a way to get the arrows to change on click, so that there doesn't seem to be issues with overlapping
        // Hide the icons once clicked to prevent the weird overlap visual with the navigation bar
//        ZStack {
//            // Down Arrows
//            VStack {
//                Image(systemName: "chevron.compact.down")
//                    .imageScale(IMAGE_SIZE)
//                    .foregroundStyle(CHEVRON_COLOR)
//                    .bold()
//                Image(systemName: "chevron.compact.down")
//                    .imageScale(IMAGE_SIZE)
//                    .foregroundStyle(CHEVRON_COLOR)
//                    .bold()
//            }
//            .opacity(navBarVisible ? 1 : 0)
//
//            // Up Arrows
//            VStack {
//                Image(systemName: "chevron.compact.up")
//                    .imageScale(IMAGE_SIZE)
//                    .foregroundStyle(CHEVRON_COLOR)
//                    .bold()
//                Image(systemName: "chevron.compact.up")
//                    .imageScale(IMAGE_SIZE)
//                    .foregroundStyle(CHEVRON_COLOR)
//                    .bold()
//            }
//            .opacity(navBarVisible ? 0 : 1)
//        }
//        .animation(.easeInOut(duration: 0.5), value: navBarVisible)
    }
}

#Preview {
//    @Previewable @State var visible: Bool = true
    
//    NavBarArrows(navBarVisible: $visible)
    NavBarArrows(iconDirection: "up")
}
