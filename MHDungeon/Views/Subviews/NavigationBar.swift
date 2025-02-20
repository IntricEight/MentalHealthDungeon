//
//  NavigationBar.swift
//  MHDungeon
//
//  Created by Collin Bowdoin on 2/12/25.
//

import SwiftUI

struct NavigationBar: View {
    var currentView: Binding<AppPage>?      // Allows this view to change the current dominant view
    
    var visible: Binding<Bool>?     // Allow the navigation bar to reset the host's NavBar state before leaving
    
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        
        // Tab controls
        let tabRadius: CGFloat = 30
        
        VStack (spacing: 0) {
            HStack {
                Spacer()    // Moves the tab to the far right
                
                // Close Navigation tab button
                Button {
                    print("Close Navigation selected")
                    
                    // Signal to close the navigation bar with an animation
                    if let binding = visible {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            binding.wrappedValue = false
                        }
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
            }
            
            // Navigation bar with buttons
            Rectangle()
                .foregroundColor(Color.blue)
                .frame(height: 100, alignment: .bottom)
                .overlay {
                    HStack {
                        Spacer()
                        
                        // Tasks Navigation button
                        navButtonRectangle(icon: "circle.circle.fill", destination: AppPage.taskList, visible: visible, consoleMessage: "Task Nav selected")
                        
                        Spacer()
                        
                        // Dungeon Navigation button
                        navButtonRectangle(icon: "triangle.circle.fill", destination: AppPage.dungeon, visible: visible, consoleMessage: "Dungeon Nav selected")
                        
                        Spacer()
                        
                        // Profile Navigation button
                        navButtonRectangle(icon: "square.circle.fill", destination: AppPage.profile, visible: visible, consoleMessage: "Profile Nav selected")
                        
                        Spacer()
                    }
                }
        }.frame(height: 140)
    }
    
    // A function to create a navigation button on the NavigationBar
    func navButtonRectangle(icon: String, destination dest: AppPage, visible: Binding<Bool>?, consoleMessage message: String) -> some View {
        
        // The button which contains the action and visual display for the operation
        Button {
            //Print the destination notification message to the console
            print(message)
            
            // Signal to close the navigation bar without an animation
            if let binding = visible {
                withTransaction(Transaction(animation: nil)) {
                    binding.wrappedValue = false
                }
            }
            
            // Navigate to the Profile view
            currentView?.wrappedValue = dest
            
        } label: {
            // A slightly rounded rectangle with an icon from SF Symbols in the center
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color.red)
                .frame(width: 80, height: 80)
                .overlay {
                    Image(systemName: icon)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60, alignment: .center)
                        .foregroundColor(Color.white)
                }
        }
        
    }
}

#Preview {
    NavigationBar()
}
