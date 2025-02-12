//
//  ContentView.swift
//  MHDungeon
//
//  Created by Collin Bowdoin on 1/29/25.
//

// TODO: Convert all of the shapes into interactive buttons
// TODO: Style the view. This includes spacings, colors, etc

import SwiftUI

struct ContentView: View {
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        // Circle control
        let circleScreenPercentage = 0.6
        let circleDiameter = screenWidth * circleScreenPercentage
        
        // Tab controls
        let tabRadius: CGFloat = 30
        
        // Communication (and settings) button controls
        let buttonRadius: CGFloat = 20
        let buttonHeight: CGFloat = 40
        
        //TODO: Change the background color from using opacity to using a lighter color of grey
        
        // TODO: Make a better system for coloring the background of the app
        Color.gray.opacity(0.6).ignoresSafeArea()
            .overlay {
                VStack {
                    // User progress info section
                    HStack {
                        // Profile Image button
                        Circle()
                            .frame(width: circleDiameter, height: circleDiameter, alignment: .leading)
                            .foregroundColor(Color.white)
                            .padding([.leading], 10)
                        
                        Spacer()
                        
                        // Account Progress tab button
                        // TODO: Figure out how to get the tab to align with the right edge of the screen
                        Rectangle()
                            .frame(width: 50, alignment: .trailing)
                            .foregroundColor(Color.blue)
                            .clipShape(
                                .rect(
                                    topLeadingRadius: tabRadius,
                                bottomLeadingRadius: tabRadius
                                )
                            )
                            .ignoresSafeArea(edges: .trailing)
                    }
                    .frame(maxWidth: .infinity, maxHeight: circleDiameter, alignment: .top)
                    .padding([.top], 50)
                    
                    Spacer(minLength: 30)
                    
                    // Connections section
                    // TODO: Style the buttons
                    HStack {
                        // Messages button
                        RoundedRectangle(cornerRadius: buttonRadius)
                            .frame(height: buttonHeight)
                            .foregroundColor(Color.brown)
                        
                        // Friends button
                        RoundedRectangle(cornerRadius: buttonRadius)
                            .frame(height: buttonHeight)
                            .foregroundColor(Color.indigo)
                    }
                    
                    Spacer(minLength: 20)
                    
                    // Character Control section
                    // TODO: Place a WIP message over the top. This feature is unlikely to be implemented
                    // TODO: Create a character system
                    RoundedRectangle(cornerRadius: buttonRadius)
                        .foregroundColor(Color.green)
                    
                    Spacer(minLength: 20)
                    
                    HStack {
                        RoundedRectangle(cornerRadius: buttonRadius)
                            .frame(width: 200, height: 30)
                            .foregroundColor(Color.orange)
                        
                        Spacer(minLength: 10)
                        
                        // Navigation tab button
                        Rectangle()
                            .frame(width: screenWidth * 0.2, height: 40, alignment: .bottom)
                            .foregroundColor(Color.blue)
                            .clipShape(
                                .rect(
                                    topLeadingRadius: tabRadius,
                                    topTrailingRadius: tabRadius
                                )
                            )
                            .ignoresSafeArea()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .ignoresSafeArea()
            }
        
        
    }
}

#Preview {
    ContentView()
}
