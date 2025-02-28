//
//  DungeonView.swift
//  MHDungeon
//

import SwiftUI

struct DungeonLandingView: View {
    // Control visiblity of various features
    @State private var navBarVisible: Bool = false      //Control the visibility of the navigation bar
    
    var body: some View {
        // Dungeon button controls
        let buttonRadius: CGFloat = 20
        
        // Tab controls
        let tabRadius: CGFloat = 30
        
        // One layer for the main app stuff, and one for the overlay tab feature
        ZStack {
            // Main screen view
            VStack {
                // Account details section
                HStack {
                    // Dungeon selection button
                    // TODO: Implement Dungeon selection feature (Popup or new page?)
                    Button {
                        print("Dungeon Selection selected")
                    } label: {
                        RoundedRectangle(cornerRadius: buttonRadius)
                            .frame(height: 50)
                            .foregroundColor(Color.red)
                            .padding(EdgeInsets(top: 0, leading: 48, bottom: 0, trailing: 32))
                    }
                    
                    Spacer()
                    
                    // Profile image
                    SmallProfileImage()
                        .frame(alignment: .trailing)
                }
                .padding(EdgeInsets(top: 64, leading: 0, bottom: 10, trailing: 16))
                
                
                // Perhaps add a title line for the level name + stage #?
                
                
                // Dungeon Unlock Progress section
                // TODO: Implement a series of images that show how much IP has been collected through the light on a lamp.
                Button {
                    print("Dungeon unlock (Visual progress) selected")
                } label: {
                    RoundedRectangle(cornerRadius: buttonRadius)
                        .foregroundColor(Color.green)
                        .frame(height: 400)
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 24, trailing: 16))
                
                
                // Enter Dungeon section
                // TODO: Implement gradually filling the bar based on current IP score
                Button {
                    print("Enter dungeon selected")
                } label: {
                    RoundedRectangle(cornerRadius: buttonRadius)
                        .frame(height: 70)
                        .foregroundColor(Color.orange)
                        .padding(EdgeInsets(top: 0, leading: 48, bottom: 0, trailing: 48))
                }
                
                
                Spacer(minLength: 20)
                
                
                // Navigation section
                HStack {
                    Spacer()
                    
                    
                    // Navigation tab button
                    NavBarTab(navBarVisible: $navBarVisible)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 32))
                }
                
            }.zIndex(0)
            
            // Overlayed tab features
            VStack {
                Spacer()
                
                // Show or hide the navigation bar
                if navBarVisible {
                    NavigationBar(visible: $navBarVisible)
                        .transition(.move(edge: .bottom))
                        .frame(alignment: .bottom)
                }
            }.zIndex(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

#Preview("Dungeon") {
    DungeonLandingView()
}
