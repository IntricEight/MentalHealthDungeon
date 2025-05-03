//
//  MinimalView.swift
//  MHDungeon
//

import SwiftUI

struct MinimalParent: View {
    /// Controls visibility of app navigation bar.
    @State private var navBarVisible: Bool = false
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    // Navigation tab button
                    MinimalNavOpen(navBarVisible: $navBarVisible)
                }.zIndex(0)
                
                VStack {
                    // Show or hide the navigation bar
                    if navBarVisible {
                        MinimalNavBar(visible: $navBarVisible)
                            .transition(.move(edge: .bottom).animation(.easeInOut(duration: 0.5)))
                    }
                }.zIndex(10)
            }
        }
    }
}

struct MinimalNavBar: View {
    /// Allow the navigation bar to reset the host's NavBar state before leaving
    @Binding var visible: Bool
    var body: some View {
        VStack (spacing: 0) {
            HStack {
                // Close Navigation tab button
                Button {
                    // Signal to close the navigation bar with an animation
                    withAnimation {
                        visible = false
                    }
                } label: {
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width * 0.2, height: 40, alignment: .bottomTrailing)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // Navigation bar
            HStack {
                Spacer()
            }
            .frame(height: 100, alignment: .center)
            .background(Color.blue)
        }.frame(height: 140)
    }
}

struct MinimalNavOpen: View {
    /// The visibility toggle for the external feature.
    @Binding var navBarVisible: Bool
    var body: some View {
        // Navigation tab button
        Button {
            // This animation controls the animation of the navigation bar as it appears
            withAnimation {
                navBarVisible = true
            }
        } label: {
            Rectangle().frame(width: screenWidth * 0.2, height: 40, alignment: .bottom)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    MinimalParent()
}
