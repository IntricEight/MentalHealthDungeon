//
//  SettingsListItem.swift
//  MHDungeon
//

import SwiftUI

struct SettingsListItem: View {
    /// The displayed text content on the item.
    let text: String
    /// The icon on the right edge of the item.
    let icon: String
    /// The page to navigate to when the item is tapped.
    ///
    /// Unlike navigation in other parts of this app, this will be using a NavigationStack.
    let destination: AnyView?
    /// The function to execute when the item is tapped.
    let action: (() -> Void)?
    
    /// Initialize the list item to navigate to another page when tapped.
    ///
    /// - Parameters:
    ///   - text: A descriptive title.
    ///   - icon: An associated icon that summarizes the feature.
    ///   - destination: The view that will be navigated to when the item is tapped.
    init(text: String, icon: String, @ViewBuilder destination: () -> some View) {
        self.text = text
        self.icon = icon
        self.destination = AnyView(destination())
        self.action = nil
    }
    
    /// Initialize the list item to execute a function when tapped.
    ///
    /// - Parameters:
    ///   - text: A descriptive title.
    ///   - icon: An associated icon that summarizes the feature.
    ///   - action: A code segment to be ran when the item is tapped.
    init(text: String, icon: String, action: @escaping () -> Void) {
        self.text = text
        self.icon = icon
        self.destination = nil
        self.action = action
    }
    
    var body: some View {
        // Determine if the list item will navigate the user to a new view, or execute a function.
        if let destination = destination {
            NavigationLink(destination: destination) {
                content
            }
        } else if let action = action {
            Button(action: action) {
                content
            }
        }
    }
    
    // The visual content of the list item
    private var content: some View {
        // Display the list option here
        HStack {
            Text(text)
                .font(.title2)
                .frame(alignment: .leading)
            
            Spacer()
            
            HStack {
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 25, alignment: .center)
                
                Spacer()
            }
            .frame(width: 40, alignment: .trailing)
        }
    }
}

#Preview {
    SettingsListItem(text: "Log out", icon: "rectangle.portrait.and.arrow.forward") {
        DeleteAccountView()
    }
}
