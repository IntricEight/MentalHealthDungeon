//
//  NavBarTab.swift
//  MHDungeon
//
//  Created by Collin Bowdoin on 2/27/25.
//

import SwiftUI

struct NavBarTab: View {
    @Binding var navBarVisible: Bool
    
    var body: some View {
        // Tab controls
        let tabRadius: CGFloat = 30
        
        // Navigation tab button
        Button {
            print("Navigation selected")
            
            // Bring up the Navigation Bar when touched
            withAnimation(.easeInOut(duration: 0.5)) {
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
    }
}

#Preview {
    @Previewable @State var visible: Bool = true
    
    NavBarTab(navBarVisible: $visible)
}
