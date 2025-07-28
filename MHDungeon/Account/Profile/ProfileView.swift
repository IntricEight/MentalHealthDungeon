//
//  ProfileOverview.swift
//  MHDungeon
//

import SwiftUI

/// A view page that provides the user an interface menu that they can use to interact with various account-related systems.
///
/// Acts as a central page for account-related actions. These include:
/// - The profile picture and account settings of the user's account.
/// - A tab of dungeon progress details.
/// - The messaging system.
/// - The friendship system.
/// - Access to and a preview of the user's character cosmetics.
struct ProfileView: View {
    // Control visiblity of various features
    /// Controls visibility of dungeon progress statistics tab that overlays profile image.
    @State private var progressTabVisible: Bool = false
    /// Controls visibility of app navigation bar.
    @State private var navBarVisible: Bool = false
    
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
                        // TODO: Implement selection of an image to use as a profile image.
                        // Current plan is to create a list of premade images to choose from, so I don't need to implement proper image storage
                        Button {
                            print("Profile Image selected")
                        } label: {
                            Circle()
                                .frame(width: circleDiameter, height: circleDiameter, alignment: .leading)
                                .foregroundColor(Color.black)
                                .overlay {
                                    Image("blank-profile")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(.circle)
                                }
                        }
                        .padding([.leading], 10)
                        .contentShape(Circle())

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
                                .contentShape(Rectangle())
                                .overlay {
                                    HStack (spacing: 0) {
                                        Image(systemName: "chevron.compact.backward")
                                            .imageScale(.large)
                                            .foregroundColor(.white)
                                            .bold()
                                        Image(systemName: "chevron.compact.backward")
                                            .imageScale(.large)
                                            .foregroundColor(.white)
                                            .bold()
                                    }
                                }
                        }
                    }
                    .frame(maxHeight: circleDiameter)
                    .padding(EdgeInsets(top: 64, leading: 30, bottom: 0, trailing: 0))
                    
                    
                    Spacer(minLength: 30)
                    
                    
                    // Connections section
                    HStack {
                        // Messages button
                        // TODO: Implement Messaging system through database
                        // TODO: Implement navigation to Message view through NavigationLink
                        Button {
                            print("Messages menu selected")
                        } label: {
                            RoundedRectangle(cornerRadius: buttonRadius)
                                .frame(height: buttonHeight)
                                .foregroundColor(Color.brown)
                                .contentShape(Rectangle())
                                .overlay {
                                    HStack {
                                        Image(systemName: "envelope.fill")
                                            .foregroundColor(.white)
                                        
                                        Text("Messages")
                                            .foregroundColor(.white)
                                            .fontWeight(.heavy)
                                    }
                                }
                        }
                        
                        
                        Spacer(minLength: 30)
                        
                        
                        // Friends button
                        // TODO: Implement friendship system through database
                        // TODO: Implement navigation to Friends page through NavigationLink
                        Button {
                            print("Friends menu selected")
                        } label: {
                            RoundedRectangle(cornerRadius: buttonRadius)
                                .frame(height: buttonHeight)
                                .foregroundColor(Color.indigo)
                                .contentShape(Rectangle())
                                .overlay {
                                    HStack {
                                        Image(systemName: "person.2.fill")
                                            .foregroundColor(.white)
                                        
                                        Text("Friends")
                                            .foregroundColor(.white)
                                            .fontWeight(.heavy)
                                    }
                                }
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    
                    
                    Spacer(minLength: 20)
                    
                    
                    // Character Creation section
                    // TODO: Wrap in a button to navigate to Cosmetics page
                    // The Character Preview is only a created image - Don't built the Cosmetics page in this view, use a new one
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
                                .contentShape(Rectangle())
                                .overlay {
                                    HStack {
                                        Image(systemName: "gearshape.fill")
                                            .foregroundColor(.white)
                                        
                                        Text("Settings")
                                            .foregroundColor(.white)
                                            .fontWeight(.heavy)
                                    }
                                }
                        }.padding(EdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 0))
                        
                        Spacer(minLength: 10)
                        
                        // Navigation tab button
                        NavBarTab(navBarVisible: $navBarVisible)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: -10, trailing: 32))
                    }
                }.zIndex(0)
                
                // Overlayed tab features
                VStack {
                    // Show or hide the progress details bar
                    if progressTabVisible {
                        //TODO: Implement ProgressDetails subview, and implement it here
                    }
                    
                    Spacer()
                    
                    // Show or hide the navigation bar
                    if navBarVisible {
                        NavigationBar(visible: $navBarVisible)
                            .frame(alignment: .bottom)
                            .transition(.move(edge: .bottom))
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
