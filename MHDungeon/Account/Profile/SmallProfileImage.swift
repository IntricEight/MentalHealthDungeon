//
//  SmallProfileImage.swift
//  MHDungeon
//

import SwiftUI

// TODO: Once the profile image is implemented, create a feature to display a much smaller version of it using this view

/// A subview which displays the user's profile image in a compressed size.
///
/// To be used as a profile picture and/or button on pages where the profile is not the focus.
struct SmallProfileImage: View {
    var body: some View {
        Circle()
            .frame(width: 60, height: 60)
            .foregroundColor(Color.black)
            .overlay {
                Image("blank-profile")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(.circle)
            }
    }
}

#Preview {
    SmallProfileImage()
}
