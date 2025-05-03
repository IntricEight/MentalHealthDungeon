//
//  NavBarTab.swift
//  MHDungeon
//

import SwiftUI

/// A button to be placed on the bottom of the screen which controls the visibility of an external feature, such as the `NavigationBar`.
struct NavBarTab: View {
    // TODO: Generic-ify this function to not use navBar naming. This includes the Binding variable and console printing.
    /// The visibility toggle for the external feature.
    @Binding var navBarVisible: Bool
    
    var body: some View {
        // Tab controls
        let tabRadius: CGFloat = 30
        
        // Navigation tab button
        HStack {
            // TODO: Place an icon with upward arrows here to show the functionality
        }
        .frame(width: screenWidth * 0.2, height: 40)
        .background(Color.blue)
        .clipShape(
            .rect(
                topLeadingRadius: tabRadius,
                topTrailingRadius: tabRadius
            )
        )
        .ignoresSafeArea()
        .contentShape(Rectangle())   // makes the padded area tappable
        .onTapGesture {
            print("Navigation selected")
            
            // Bring up the Navigation Bar when touched
            // This animation controls the animation of the navigation bar as it appears
            withAnimation(.easeInOut(duration: 0.5)) {
                navBarVisible = true
            }
        }
    }
}

#Preview {
    @Previewable @State var visible: Bool = true
    
    NavBarTab(navBarVisible: $visible)
}
