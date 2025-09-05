//
//  ProgressDetails.swift
//  MHDungeon
//

import SwiftUI

// Displayed features (Find 3):
//  - Total dungeon adventures completed.   Variable: dungeonsCompleted
//  - Tasks completed.                      Variable: tasksCompleted
//  - Lifetime points acquired.             Variable: lifetimeIP

/// A subview which displays several details about the user's progression through the application.
struct ProgressDetails: View {
    /// Allow the progress bar to reset this popout's appearance state before leaving
    @Binding var visible: Bool
    
    var body: some View {
        // Tab controls
        let tabRadius: CGFloat = 30
        
        HStack {
            HStack (spacing: 0) {
                Button {
                    print("Closing progress tab")
                    
                    // Tell the parent view to close the progress tab
                    withAnimation(.easeInOut(duration: 0.5)) {
                        visible = false
                    }
                    
                    // TODO: Implement the animation on popping in and out of activeness. Use NavBar for reference.
                } label: {
                    // Arrows to display which direction you can slide the view
                    TabArrows(direction: "forward")
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .contentShape(Rectangle())
                }
            }
            .frame(width: 50, alignment: .leading)
            
            Spacer()
            
            // Statistics on the user's account history
            VStack {
                
            }.frame(alignment: .center)
            
            Spacer()
        }
        .ignoresSafeArea(edges: .trailing)
        .frame(width: screenWidth * 0.9, height: screenWidth * 0.6)
        .background(Color.red)
        .clipShape(
            .rect(topLeadingRadius: tabRadius, bottomLeadingRadius: tabRadius)
        )
        
        
    }
}
