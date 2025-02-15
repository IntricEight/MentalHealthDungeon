//
//  ContentView.swift
//  MHDungeon
//
//  Created by Collin Bowdoin on 1/29/25.
//

// TODO: Style the application views. This includes spacings, colors, etc. Make it pretty before the submission

import SwiftUI

// Global screen traits
let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

struct ContentView: View {
    var body: some View {
        // App background color
        Color(0xbababa).ignoresSafeArea()
            .overlay {
                
                
                
                
                //Current View
                // TODO: Make this adaptable to allow view navigation
//                ProfileView()
                DungeonView()
            }
    }
}

#Preview {
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
