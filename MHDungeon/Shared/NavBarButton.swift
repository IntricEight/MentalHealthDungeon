//
//  NavBarButton.swift
//  MHDungeon
//

import SwiftUI

struct NavBarButton: View {
    @Environment(AppState.self) var appState: AppState
    
    @Binding var visible: Bool
    
    let icon: String
    var dest: AppPage
    let message: String
    
    init(icon: String, destination: AppPage, visible: Binding<Bool>, consoleMessage: String) {
        self.icon = icon
        self.dest = destination
        self._visible = visible
        self.message = consoleMessage
    }
    
    var body: some View {
        // The button which contains the action and visual display for the operation
        Button {
            //Print the destination notification message to the console
            print(message)
            
            // Signal to close the navigation bar without an animation
            withTransaction(Transaction(animation: nil)) {
                visible = false
            }
            
            // Navigate to the destination view
            appState.currentView = dest
            
            print(appState.currentView)
            
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
    @Previewable @State var visible = true
    var p_appState: AppState = AppState(.profile)
    
    NavBarButton(icon: "circle.circle.fill", destination: AppPage.taskList, visible: $visible, consoleMessage: "Preview Button selected")
                    .environment(p_appState)
}
