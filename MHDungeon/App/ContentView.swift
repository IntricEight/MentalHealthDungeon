//
//  ContentView.swift
//  MHDungeon
//

// TODO: Style the application views. This includes spacings, colors, etc. Make it pretty before the submission
// TODO: Clear or comment out the host of print(*Useful for navigation checking) lines throughout the code

import SwiftUI

// Global screen traits
// TODO: See if the usage of these can be modified to allow the removal of depreciated code
/// The width of the user's screen.
let screenWidth = UIScreen.main.bounds.width
/// The height of the user's screen.
let screenHeight = UIScreen.main.bounds.height
/// The primary character font used in the app.
// TODO: Find a good font for the app.
let appFont1 = 0

/// The view page that manages the view display of the application through the navigation status of `AppState`.
struct ContentView: View {
    @EnvironmentObject private var authModel: AuthModel
    @Environment(AppState.self) private var appState: AppState
    @State private var dungeonState: DungeonState = DungeonState()
    
    var body: some View {
        // 0xbababa was the prefered grey, moving to white until the issue with list backgrounds is fixed
        Color(0xffffff).ignoresSafeArea()
            .overlay {
                Group {
                    // If the user is logged in, allow them to navigate around the app
                    if authModel.userSession != nil && authModel.currentAccount != nil {
                        //Select the view to display using appState's navigation status
                        switch appState.currentView {
                            // Displays the dungeon view system.
                            case AppPage.dungeon:
                                DungeonView()
                                    .environment(dungeonState)
                            // Displays the profile view system.
                            case AppPage.profile:
                                ProfileView()
                            // Displays the task view system.
                            case AppPage.taskList:
                                TaskView()
                            // Displays the minimal viable code page
                            case AppPage.minimal:
                                MinimalParent()
                            default:
                                SettingsView()    //Fallback in case something about the authentication goes wrong
                        }
                        
                    } else {    //If user is not logged in, bring them to the log in view
                        SignInView()
                    }
                }
            }
    }
}

#Preview("Views Host") {
    ContentView()
}

// Extend a function onto the Color operation to allow HEX codes to be passed in instead of spcific colors
extension Color {
    init(_ hex: Int, _ opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
}
