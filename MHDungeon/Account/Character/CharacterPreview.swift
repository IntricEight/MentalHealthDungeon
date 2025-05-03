//
//  CharacterPreview.swift
//  MHDungeon
//

// TODO: Design a smaller display of the user's character's appearance, to be displayed on the profile page. This is only visual: The hosting view will implement the button navigation logic
// TODO: Create a character system (This feature is unlikely to be implemented during this project's lifespan)

import SwiftUI

// Communication (and settings) button controls
let buttonRadius: CGFloat = 20

/// A subview that displays the user's character.
///
/// Does not serve as a navigation button; that logic must be implemented by host view.
struct CharacterPreview: View {
    var body: some View {
        Button {
            print("Character creation selected")
        } label: {
            RoundedRectangle(cornerRadius: buttonRadius)
                .foregroundColor(Color.green)
                .overlay {
                    // TODO: Remove the following text when beginning implementation attempts
                    Text("WIP")
                        .font(.custom("", size: 100))
                        .foregroundColor(Color.black)
                }
        }
    }
}

#Preview {
    CharacterPreview()
}
