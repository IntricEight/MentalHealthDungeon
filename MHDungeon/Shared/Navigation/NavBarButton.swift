//
//  NavBarButton.swift
//  MHDungeon
//

import SwiftUI

/// A button which will direct the user into the selected major section of the application.
struct NavBarButton: View {
    @Environment(AppState.self) private var appState: AppState
    
    /// The name of the `SF Symbols` icon that adorns the button.
    private let icon: String
    /// The section destination that the button will direct the user to.
    private var dest: AppPage
    /// A message to be printed to the console when the button is pressed.
    private let message: String
    
    /// If the icon needs to be shrunken to fit inside the block (Looking at you, Clipboard) then set this to true.
    private let shrink: Bool
    
    /// Instantiates the button with the icon and destination, alongside a message to be printed to the console during navigation.
    init(icon: String, destination: AppPage, consoleMessage message: String = "", shrinkIcon shrink: Bool = false) {
        self.icon = icon
        self.dest = destination
        self.message = message
        self.shrink = shrink
    }
    
    var body: some View {
        // The button which contains the action and visual display for the operation
        Button {
            // Only navigate if the user isn't already on the desired page
            if appState.currentView != dest {
                //Print the destination notification message to the console
                print(message)
            
                // Navigate to the destination view
                appState.ChangeView(to: dest)
            }
            
        } label: {
            // A slightly rounded rectangle with an icon from SF Symbols in the center
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color.teal)
                .frame(width: 80, height: 80)
                .overlay {
                    Image(systemName: icon)
                        .foregroundColor(Color.white)
                        .font(.system(size: 60))
                        .frame(alignment: .center)
                }
        }
    }
}

#Preview {
    /// The destination of the button in the Preview
    var p_appState: AppState = AppState(.profile)
    
    NavBarButton(icon: "circle.circle.fill", destination: AppPage.taskList, consoleMessage: "Preview Button selected")
                    .environment(p_appState)
}
