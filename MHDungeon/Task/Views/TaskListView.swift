//
//  TaskListView.swift
//  MHDungeon
//

// TODO: Implement an override button that reduces the timer of the first task to 5 seconds. This will be useful in demonstrating that ask feature to the audience

import SwiftUI

struct TaskListView: View {
    @EnvironmentObject var authModel: AuthModel
    
    var currentView: Binding<AppPage>?      // Passed through here into the NavigationBar
    
    // Control visiblity of various features
    @State private var navBarVisible: Bool = false      //Control the visibility of the navigation bar
    
    // Dungeon button controls
    // TODO: Make some environmental file where this stuff can be stored
    let buttonRadius: CGFloat = 20
    
    // Tab controls
    let tabRadius: CGFloat = 30
    
    // TODO: Clean up. Test converting into a set once the initial list is working
    @State var tasks: [Task] = []
        
    
    
    var body: some View {
        // Or a List, as it comes with a scroll. Perhaps you could even use both at the same time, future me
        // Use a .sheet (iExpense, look up Paul Hudson's tutorial) to display the Task details / Task Creation
        //  OR
        // Use a NavigationStack with NavigationLink
        
        // One layer for the main app stuff, and one for the overlay tab feature
        ZStack {
            // Main screen view
            VStack {
                // Account details section
                HStack {
                    // Task Creation Button
                    // TODO: When clicked, split into two buttons (New and Custom)
                    Button {
                        print("Task Creation selected")
                        
                        tasks.removeLast()
                    } label: {
                        RoundedRectangle(cornerRadius: buttonRadius)
                            .frame(height: 50)
                            .foregroundColor(Color.red)
                            .padding(EdgeInsets(top: 0, leading: 48, bottom: 0, trailing: 32))
                    }
                    
                    Spacer()
                    
                    // Profile image
                    // TODO: Implement profile picture display. Picture taken from selection on Profile view
                    Circle()
                        .frame(width: 60, height: 60, alignment: .trailing)
                        .foregroundColor(Color.yellow)

                }
                .padding(EdgeInsets(top: 64, leading: 0, bottom: 10, trailing: 16))
                
                
                Spacer()
                
                // TODO: Figure out why the white background won't go away, and make it go away
                // List of active tasks
                List(tasks) { task in
                    Button {
                        print(task)
                    } label: {
                        TaskListItem(task)
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
                
                
                
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
                    }.padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 32))
                }
            }.zIndex(1)
                .onAppear {
                    tasks = authModel.currentAccount?.taskList ?? []
                }
            
            
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
