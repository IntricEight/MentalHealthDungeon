//
//  ProfileOverview.swift
//  MHDungeon
//
//  Created by Collin Bowdoin on 2/12/25.
//

import SwiftUI

struct ProfileView: View {
    // Control visiblity of navigation bar
    @State private var navBarVisible: Bool = false
    
    var body: some View {
        // Universal Screen traits
        // TODO: Turn these into a universal variable that all views can access
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        // Circle control
        let circleScreenPercentage = 0.6
        let circleDiameter = screenWidth * circleScreenPercentage
        
        // Tab controls
        let tabRadius: CGFloat = 30
        
        // Communication (and settings) button controls
        let buttonRadius: CGFloat = 20
        let buttonHeight: CGFloat = 40

        // One layer for the main app stuff, and one for the overlay tab feature
        ZStack {
            // Main screen view
            VStack {
                // User progress info section
                HStack {
                    // Profile Image button
                    Button {
                        print("Profile Image selected")
                    } label: {
                        Circle()
                            .frame(width: circleDiameter, height: circleDiameter, alignment: .leading)
                            .foregroundColor(Color.yellow)
                            .padding([.leading], 10)
                    }
                    
                    Spacer()
                    
                    // Account Progress tab button
                    // TODO: Figure out how to get the tab to align with the right edge of the screen
                    Button {
                        print("Progress Tab selected")
                    } label: {
                        Rectangle()
                            .frame(width: 50, alignment: .trailing)
                            .foregroundColor(Color.blue)
                            .clipShape(
                                .rect(
                                    topLeadingRadius: tabRadius,
                                    bottomLeadingRadius: tabRadius
                                )
                            )
                            .ignoresSafeArea(edges: .trailing)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: circleDiameter, alignment: .top)
                .padding(EdgeInsets(top: 64, leading: 30, bottom: 0, trailing: 0))
                
                
                Spacer(minLength: 30)
                
                
                // Connections section
                // TODO: Style the buttons
                HStack {
                    // Messages button
                    Button {
                        print("Messages menu selected")
                    } label: {
                        RoundedRectangle(cornerRadius: buttonRadius)
                            .frame(height: buttonHeight)
                            .foregroundColor(Color.brown)
                    }
                    
                    Spacer(minLength: 30)
                    
                    // Friends button
                    Button {
                        print("Friends menu selected")
                    } label: {
                        RoundedRectangle(cornerRadius: buttonRadius)
                            .frame(height: buttonHeight)
                            .foregroundColor(Color.indigo)
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                
                
                Spacer(minLength: 20)
                
                
                // Character Creation section
                // TODO: Place a WIP message over the top. This feature is unlikely to be implemented
                // TODO: Create a character system
                Button {
                    print("Character creation selected")
                } label: {
                    RoundedRectangle(cornerRadius: buttonRadius)
                        .foregroundColor(Color.green)
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                
                
                Spacer(minLength: 20)
                
                
                // Settings and Navigation section
                HStack {
                    Spacer()
                    
                    // Settings button
                    Button {
                        print("Settings selected")
                    } label: {
                        RoundedRectangle(cornerRadius: buttonRadius)
                            .frame(width: 200, height: 30, alignment: .top)
                            .foregroundColor(Color.orange)
                    }.padding(EdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 0))
                    
                    Spacer(minLength: 10)
                    
                    // Navigation tab button
                    Button {
                        print("Navigation selected")
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
                    }.padding(EdgeInsets(top: 0, leading: 0, bottom: -10, trailing: 32))
                }
            }.zIndex(0)
            
            // Overlayed tab features
            VStack {
                Spacer()
                
                NavigationBar()
                    .frame(alignment: .bottom)
            }.zIndex(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea()
    }
}

#Preview {
    ProfileView()
}
