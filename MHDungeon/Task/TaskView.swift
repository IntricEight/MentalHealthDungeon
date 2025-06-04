//
//  TaskView.swift
//  MHDungeon
//

import SwiftUI

/// A view page that provides the user an interface menu that they can use to interact with various task-related systems.
///
/// Acts as a central page for task-related actions. These include:
/// - Marking tasks as complete to earn points.
/// - Creating new Tasks from either a list of presets or a custom menu.
/// - Accessing an existing task to read its details.
struct TaskView: View {
    // Stores the list of the user's current tasks
    @EnvironmentObject var authModel: AuthModel
    
    /// Controls visibility of app navigation bar.
    @State private var navBarVisible: Bool = false
    
    // TODO: After getting the new task implementation working, look at refactoring this button/state into its own view
    /// Controls whether the "new task" button is split or not.
    ///
    /// This controls whether the menu-like button is present, or if the button has been split apart into the Custom and Preset options.
    @State var isExpanded: Bool = false
    
    // TODO: Test converting into a set once the initial list is working. Also, if it needs privating
    /// The list of the user's `Task`s.
    @State var tasks: [Task] = []
    
    // Task button controls
    // TODO: Make some environmental file where this stuff can be stored
    private let buttonRadius: CGFloat = 20
    private let buttonHeight: CGFloat = 50
    
    // Tab controls
    private let tabRadius: CGFloat = 30
    
    var body: some View {
        NavigationStack {
            // One layer for the main app stuff, and one for the overlay tab feature
            ZStack {
                // Main screen view
                VStack {
                    // Account details section
                    HStack {
                        Spacer(minLength: 15)
                        
                        
                        // Task Creation Button
                        // TODO: After I get the sheet working, see if I can break this button into its own View
                        if !isExpanded {
                            Button {
                                print("Task Creation selected")
                                
                                // Show the two buttons that allow users to create new tasks
                                isExpanded.toggle()
                            } label: {
                                RoundedRectangle(cornerRadius: buttonRadius)
                                    .frame(width: screenWidth * 0.6, height: buttonHeight)
                                    .foregroundColor(Color.red)
                                    .overlay {
                                        Text("Add Task")
                                            .foregroundColor(.white)
                                            .fontWeight(.semibold)
                                            .font(.title)
                                            .frame(alignment: .center)
                                    }
                            }
                        } else {
                            // Custom task creation button
                            NavigationLink(destination: TaskCustomView()) {
                                RoundedRectangle(cornerRadius: buttonRadius)
                                    .foregroundColor(Color.blue)
                                    .frame(height: buttonHeight)
                                    .overlay(
                                        Text("Custom")
                                            .foregroundColor(.white)
                                            .fontWeight(.semibold)
                                            .font(.title)
                                    )
                            }.navigationBarBackButtonHidden(true)
                            
                            Spacer(minLength: 10)
                            
                            // Preset task creation button
                            NavigationLink(destination: TaskPresetView()) {
                                RoundedRectangle(cornerRadius: buttonRadius)
                                    .foregroundColor(Color.green)
                                    .frame(height: buttonHeight)
                                    .overlay(
                                        Text("Preset")
                                            .foregroundColor(.white)
                                            .fontWeight(.semibold)
                                            .font(.title)
                                    )
                            }.navigationBarBackButtonHidden(true)
                        }
                        
                        Spacer(minLength: 15)
                        
                        // Profile image
                        SmallProfileImage()
                            .frame(alignment: .trailing)
                        
                    }
                    .padding(EdgeInsets(top: 64, leading: 0, bottom: 10, trailing: 16))
                    
                    
                    Spacer()
                    
                    
                    // Show the user's current tasks
                    TaskListView(account: authModel.currentAccount!)
                    
                    // Navigation section
                    HStack {
                        Spacer()
                        
                        // Navigation tab button
                        NavBarTab(navBarVisible: $navBarVisible)
                            .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 32))
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
                        NavigationBar(visible: $navBarVisible)
                            .transition(.move(edge: .bottom))
                            .frame(alignment: .bottom)
                    }
                }.zIndex(10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview("Task List") {
    TaskView()
}

struct TaskListView: View {
    @ObservedObject var account: Account
    
    // TODO: Figure out why the white background won't go away, and make it go away
    // TODO: Figure out how to get the animation when removing a task back to appear on the list
    
    var body: some View {
        if account.taskList.isEmpty {
            // Show that no tasks exist, and direct them to the task creation button
            // TODO: Style this and include instructions on how to create a task
            VStack {
                Text("No tasks found in account.")
                    .font(.title3)

                Text("Perhaps try creating your own?")
                    .font(.title3)
            }.frame(alignment: .top)
            
            Spacer()
        } else {
            // List of active tasks
            List(account.taskList) { task in
                TaskListItem(task)
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
        }
    }
}
