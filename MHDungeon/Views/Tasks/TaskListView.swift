//
//  TaskListView.swift
//  MHDungeon
//
//  Created by Collin Bowdoin on 2/12/25.
//

import SwiftUI

struct TaskListView: View {
    var currentView: Binding<AppPage>?      // Passed through here into the NavigationBar
    
    // Control visiblity of various features
    @State private var navBarVisible: Bool = false      //Control the visibility of the navigation bar
    
    // Tab controls
    let tabRadius: CGFloat = 30
    
    var body: some View {
        
        
        // Or a List, as it comes with a scroll. Perhaps you could even use both at the same time, future me
        // Use a .sheet (iExpense, look up Paul Hudson's tutorial) to display the Task details / Task Creation
        //  OR
        // Use a NavigationStack with NavigationLink
        
        // One layer for the main app stuff, and one for the overlay tab feature
        ZStack {
            VStack {
                HStack {
                    
                }
                
                
                Spacer()
                
                
                // Navigation section
                HStack {
                    Spacer()
                    
                    
                    // Navigation tab button
                    Button {
                        print("Navigation selected")
                        
                        // Bring up the Navigation Bar when touched
                        withAnimation(.easeInOut(duration: 0.5)) {
                            navBarVisible = true
                        }
                    } label: {
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
                    }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 32))
                }
            }.zIndex(1)
            
            
            // Overlayed tab features
            VStack {
                
                Spacer()
                
                // Show or hide the navigation bar
                if navBarVisible {
                    NavigationBar(currentView: currentView, visible: $navBarVisible)
                        .transition(.move(edge: .bottom))
                        .frame(alignment: .bottom)
                }
            }.zIndex(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

#Preview("Task List") {
    TaskListView()
}
