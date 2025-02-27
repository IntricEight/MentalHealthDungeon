//
//  ContentView.swift
//  MHDungeon
//

// TODO: Style the application views. This includes spacings, colors, etc. Make it pretty before the submission
// TODO: Clear or comment out the host of print(*Useful for navigation checking) lines throughout the code

import SwiftUI

// Global screen traits
let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

struct ContentView: View {
    @EnvironmentObject var authModel: AuthModel
    @Environment(AppState.self) var appState: AppState
    
    var body: some View {
        Color(0xbababa).ignoresSafeArea()
            .overlay {
                Group {
                    // If the user is logged in, allow them to navigate around the app
                    if authModel.userSession != nil && authModel.currentAccount != nil {
                        //Select the view to display
                        switch appState.currentView {
                            case AppPage.dungeon:
                                DungeonView()
                            case AppPage.profile:
                                ProfileView()
                            case AppPage.taskList:
                                TaskListView()
                            default:
                                SettingsView()    //Fallback in case something about the auth goes wrong
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
