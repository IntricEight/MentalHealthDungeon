//
//  NavigationBar.swift
//  MHDungeon
//
//  Created by Collin Bowdoin on 2/12/25.
//

import SwiftUI

struct NavigationBar: View {
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        
        // Tab controls
        let tabRadius: CGFloat = 30
        
        VStack (spacing: 0) {
            HStack {
                Spacer()    // Moves the tab to the far right
                
                // Close Navigation tab button
                Button {
                    print("Close Navigation selected")
                } label: {
                    Rectangle()
                        .frame(width: screenWidth * 0.2, height: 40, alignment: .bottomTrailing)
                        .foregroundColor(Color.blue)
                        .clipShape(
                            .rect(
                                topLeadingRadius: tabRadius,
                                topTrailingRadius: tabRadius
                            )
                        )
                        .padding([.trailing], 32)
                }
            }
            
            
            Rectangle()
                .foregroundColor(Color.blue)
                .frame(height: 100, alignment: .bottom)
                .overlay {
                    HStack {
                        Spacer()
                        
                        // Tasks Navigation button
                        Button {
                            print("Task Nav selected")
                        } label: {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(Color.red)
                                .frame(width: 80, height: 80)
                                .overlay {
                                    Image(systemName: "circle.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 60, height: 60, alignment: .center)
                                        .foregroundColor(Color.white)
                                }
                        }
                        
                        Spacer()
                        
                        // Dungeon Navigation button
                        Button {
                            print("Dungeon Nav selected")
                        } label: {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(Color.red)
                                .frame(width: 80, height: 80)
                                .overlay {
                                    Image(systemName: "triangle.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 60, height: 60, alignment: .center)
                                        .foregroundColor(Color.white)
                                }
                        }
                        
                        Spacer()
                        
                        // Profile Navigation button
                        Button {
                            print("Profile Nav selected")
                        } label: {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(Color.red)
                                .frame(width: 80, height: 80)
                                .overlay {
                                    Image(systemName: "square.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 60, height: 60, alignment: .center)
                                        .foregroundColor(Color.white)
                                }
                        }
                        
                        Spacer()
                    }
                }
        }.frame(height: 140)
    }
}

#Preview {
    NavigationBar()
}
