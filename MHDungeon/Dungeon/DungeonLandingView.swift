//
//  DungeonView.swift
//  MHDungeon
//

import SwiftUI

/// A view page that provides the user an interface menu that they can use to interact with various dungeon-related systems.
///
/// Acts as a landing page for dungeon-related actions. These include:
/// - Choosing which dungeon level the user wants to adventure through.
/// - Entering a dungeon once the user has enough Inspiration Points.
struct DungeonLandingView: View {
    @Environment(DungeonState.self) private var dungeonState: DungeonState
    
    /// Controls visibility of app navigation bar.
    @State private var navBarVisible: Bool = false
    
//    var testDungeon = try! Dungeon(name: "Dark Cave")
    
    var body: some View {
        // Dungeon button controls
        let buttonRadius: CGFloat = 20
        
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
                        
                        // Navigate to the Dungeon Selection page
                        dungeonState.ChangeView(to: DungeonPage.selection)
                    } label: {
                        RoundedRectangle(cornerRadius: buttonRadius)
                            .frame(height: 50)
                            .foregroundColor(Color.red)
                            .contentShape(Rectangle())
                    }.padding(EdgeInsets(top: 0, leading: 48, bottom: 0, trailing: 32))
                    
                    Spacer()
                    
                    // Profile image
                    SmallProfileImage()
                        .frame(alignment: .trailing)
                }
                .padding(EdgeInsets(top: 64, leading: 0, bottom: 10, trailing: 16))
                
                
                // Perhaps add a title line for the level name + stage #?
                
                
                // Dungeon Unlock Progress section
                DungeonImage()
                
                
                // Enter Dungeon section
                // TODO: Implement gradually filling the bar based on current IP score
                Button {
                    print("Enter dungeon selected")
                } label: {
                    RoundedRectangle(cornerRadius: buttonRadius)
                        .frame(height: 70)
                        .foregroundColor(Color.orange)
                        .overlay {
                            Text("\(dungeonState.currentDungeon?.name ?? "No dungeon connected!")")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .font(.title)
                                .frame(alignment: .center)
                        }
                        .contentShape(Rectangle())
                }.padding(EdgeInsets(top: 0, leading: 48, bottom: 0, trailing: 48))
                
                
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
