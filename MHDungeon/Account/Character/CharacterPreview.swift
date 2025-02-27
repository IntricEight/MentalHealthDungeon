//
//  CharacterPreview.swift
//  MHDungeon
//

// TODO: Design a smaller display of the user's character's appearance, to be displayed on the profile page
// TODO: Create a character system (This feature is unlikely to be implemented during this project's lifespan)

import SwiftUI

// Communication (and settings) button controls
let buttonRadius: CGFloat = 20

struct CharacterPreview: View {
    var body: some View {
        Button {
            print("Character creation selected")
        } label: {
            RoundedRectangle(cornerRadius: buttonRadius)
                .foregroundColor(Color.green)
                .overlay {
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
