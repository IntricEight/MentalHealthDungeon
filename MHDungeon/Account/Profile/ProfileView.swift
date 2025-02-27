//
//  ProfileOverview.swift
//  MHDungeon
//

import SwiftUI

struct ProfileView: View {
    // Control visiblity of various features
    @State private var progressBarVisible: Bool = false     //Control the visibility of the progress stats bar
    @State private var navBarVisible: Bool = false      //Control the visibility of the navigation bar
    
    var body: some View {
        // Circle controls
        let circleScreenPercentage = 0.6
        let circleDiameter = screenWidth * circleScreenPercentage
        
        // Tab controls
        let tabRadius: CGFloat = 30
        
        // Communication (and settings) button controls
        let buttonRadius: CGFloat = 20
        let buttonHeight: CGFloat = 40

        
        NavigationStack {
            // One layer for the main app stuff, and one for the overlay tab feature
            ZStack {
                // Main screen view
                VStack {
                    // User progress info section
                    HStack {
                        // Profile Image button
                        // TODO: Implement selection of an image to use as a profile image. Current plan is to create premade images to choose from
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
                        // TODO: Implement popout bar with details about the user's adventure
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
                    .frame(maxHeight: circleDiameter)
                    .padding(EdgeInsets(top: 64, leading: 30, bottom: 0, trailing: 0))
                    
                    
                    Spacer(minLength: 30)
                    
                    
                    // Connections section
                    HStack {
                        // Messages button
                        // TODO: Implement Messaging system through database.
                        // TODO: Implement navigation to Message view
                        Button {
                            print("Messages menu selected")
                        } label: {
                            RoundedRectangle(cornerRadius: buttonRadius)
                                .frame(height: buttonHeight)
                                .foregroundColor(Color.brown)
                        }
                        
                        Spacer(minLength: 30)
                        
                        // Friends button
                        // TODO: Implement friendship system through database
                        // TODO: Implement navigation to Friends page
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
                    CharacterPreview()
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    
                    
                    Spacer(minLength: 20)
                    
                    
                    // Settings and Navigation section
                    HStack {
                        Spacer()
                        
                        // Settings button
                        NavigationLink(destination: SettingsView()) {
                            RoundedRectangle(cornerRadius: buttonRadius)
                                .frame(width: 200, height: 30, alignment: .top)
                                .foregroundColor(Color.orange)
                                .padding(EdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 0))
                        }
                        
                        Spacer(minLength: 10)
                        
                        // Navigation tab button
                        NavBarTab(navBarVisible: $navBarVisible)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: -10, trailing: 32))
                    }
                }.zIndex(0)
                
                // Overlayed tab features
                VStack {
                    // Show or hide the progress details bar
                    if progressBarVisible {
                        //TODO: Implement ProgressDetails subview, and implement it here
                    }
                    
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
}

#Preview("Profile") {
    ProfileView()
}
