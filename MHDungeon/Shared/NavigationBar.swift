//
//  NavigationBar.swift
//  MHDungeon
//

import SwiftUI

/// A subview that provides users with buttons to control the major section of the application that they are on.
struct NavigationBar: View {
    /// Allow the navigation bar to reset the host's NavBar state before leaving
    @Binding var visible: Bool
    
    var body: some View {
        /// The screen width of the user's device
        let screenWidth = UIScreen.main.bounds.width
        
        // Tab Controls
        /// The radius of the tab that closes the navigation bar
        let tabRadius: CGFloat = 30
        
        VStack (spacing: 0) {
            HStack {
                Spacer()    // Moves the tab to the far right
                
                // Close Navigation tab button
                Button {
                    print("Close Navigation selected")
                    
                    // Signal to close the navigation bar with an animation
                    withAnimation(.easeOut(duration: 0.5)) {
                        visible = false
                    }
                } label: {
                    Rectangle()
                        .frame(width: screenWidth * 0.2, height: 40, alignment: .bottomTrailing)
                        .foregroundColor(Color.blue)
                        .clipShape(
                            .rect(
                                topLeadingRadius: tabRadius,
                                topTrailingRadius: tabRadius
                            )
                        )
                        .padding([.trailing], 32)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Navigation bar with buttons
            Rectangle()
                .foregroundColor(Color.blue)
                .frame(height: 100, alignment: .bottom)
                .overlay {
                    HStack {
                        Spacer()
                        
                        // Tasks Navigation button
                        NavBarButton(icon: "circle.circle.fill", destination: AppPage.taskList, consoleMessage: "Task Nav selected")
                        
                        Spacer()
                        
                        // Dungeon Navigation button
                        NavBarButton(icon: "triangle.circle.fill", destination: AppPage.dungeon, consoleMessage: "Dungeon Nav selected")
                        
                        Spacer()
                        
                        // Profile Navigation button
                        NavBarButton(icon: "square.circle.fill", destination: AppPage.profile, consoleMessage: "Profile Nav selected")
                        
                        Spacer()
                    }
                }
        }.frame(height: 140)
    }
}

#Preview("Navigation Bar") {
    @Previewable @State var visible: Bool = true
    NavigationBar(visible: $visible)
}
