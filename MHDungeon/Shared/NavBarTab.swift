//
//  NavBarTab.swift
//  MHDungeon
//
//  Created by Collin Bowdoin on 2/27/25.
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
        Button {
            print("Navigation selected")
            
            // Bring up the Navigation Bar when touched
            // This animation controls the animation of the navigation bar as it appears
            withAnimation(.easeIn(duration: 0.5)) {
                navBarVisible = true
            }
        } label: {
            Rectangle()
                .frame(width: screenWidth * 0.2, height: 40, alignment: .bottom)
                .foregroundColor(Color.blue)
                .clipShape(
                    .rect(
                        topLeadingRadius: tabRadius,
                        topTrailingRadius: tabRadius
                    )
                )
                .ignoresSafeArea()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    @Previewable @State var visible: Bool = true
    
    NavBarTab(navBarVisible: $visible)
}
