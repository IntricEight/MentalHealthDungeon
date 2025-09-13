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
    @EnvironmentObject var authModel: AuthModel
    
    /// Allow the progress bar to reset this popout's appearance state before leaving
    @Binding var visible: Bool
    
    var body: some View {
        // Tab controls
        let tabRadius: CGFloat = 30
        
        HStack {
            HStack {
                // Arrows to display which direction you can slide the view
                TabArrows(direction: "forward")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .contentShape(Rectangle())  // ContentShape and width/height required for the hitbox to expand to fill the desired space
            }
            .frame(width: 50, alignment: .leading)
            .onTapGesture {
                print("Closing progress tab")
                
                // Tell the parent view to close the progress tab
                withAnimation(.easeInOut(duration: 0.5)) {
                    visible = false
                }
            }
            
            Spacer()
            
            // Statistics on the user's account history
            VStack (alignment: .leading, spacing: 0) {
                // Total Inspiration Points
                Text("Lifetime Inspiration Points earned:")
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(Font.title3)
                Text("\(authModel.currentAccount?.lifetimeIP ?? -5)")
                    .foregroundColor(Color.white)
                    .padding(.leading, 24)
                    .padding(.bottom, 8)
                
                // Total Task Completions
                Text("Lifetime Tasks completed:")
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(Font.title3)
                Text("\(authModel.currentAccount?.tasksCompleted ?? 0)")
                    .foregroundColor(Color.white)
                    .padding(.leading, 24)
                    .padding(.bottom, 8)
                
                // Total Dungeon Completions
                Text("Lifetime Dungeons completed:")
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(Font.title3)
                Text("\(authModel.currentAccount?.dungeonsCompleted ?? 0)")
                    .foregroundColor(Color.white)
                    .padding(.leading, 24)
                    .padding(.bottom, 8)
            }
            .frame(maxHeight: screenHeight * 0.5)
            
            Spacer()
        }
        .ignoresSafeArea(edges: .trailing)
        .frame(width: screenWidth * 0.9, height: screenWidth * 0.6)
        .background(Color.blue)
        .clipShape(
            .rect(topLeadingRadius: tabRadius, bottomLeadingRadius: tabRadius)
        )
        
        
    }
}
