//
//  SmallProfileImage.swift
//  MHDungeon
//

import SwiftUI

// TODO: Once the profile image is implemented, create a feature to display a much smaller version of it using this view

struct SmallProfileImage: View {
    var body: some View {
        Circle()
            .frame(width: 60, height: 60)
            .foregroundColor(Color.yellow)
    }
}

#Preview {
    SmallProfileImage()
}
