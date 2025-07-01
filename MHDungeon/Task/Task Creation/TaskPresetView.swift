//
//  TaskPresetView.swift
//  MHDungeon
//

import SwiftUI

/// A view which provides the user with a list of premade`Task`s that they can add to their `Account`.
struct TaskPresetView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Communication (and settings) button controls
    private let buttonRadius: CGFloat = 20
    private let buttonHeight: CGFloat = 40
    
    var body: some View {
        // TODO: Create a list of preset tasks that the user can choose from. They can choose as little or as many items as they want. Display should look like the TaskListItem, except the check mark is replaced with a plus symbol that adds it to the user
        // List is stored within PresetTasks.json
        
        VStack {
            // TODO: Display a list of task items that can be added to the user's list. These presets should have the ability to set a timer so that once they are completed, they enter a cooldown

            Text("Choose up to 5 tasks to add")
            
            Spacer()
            
            TaskListView()
            
            Spacer()
            
            // Finalize the new task process by canceling or creating it
            HStack {
                // Cancel task creation
                Button {
                    print("Exited Custom Task Creation selected")
                    dismiss()
                } label: {
                    RoundedRectangle(cornerRadius: buttonRadius)
                        .frame(height: buttonHeight)
                        .foregroundColor(Color.brown)
                        .overlay {
                            Text("Cancel")
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                        }
                }
                
                Spacer(minLength: 30)
                
                // Create the new task
                Button {
                    print("Create the New Task selected")
                } label: {
                    RoundedRectangle(cornerRadius: buttonRadius)
                        .frame(height: buttonHeight)
                        .foregroundColor(Color.indigo)
                        .overlay {
                            Text("Add Presets")
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                        }
                }
            }
            .padding(EdgeInsets(top: -8, leading: 16, bottom: 8, trailing: 16))
        }
    }
}

/// Display the preset `Task`s inside of a list
private struct TaskListView: View {
    var taskList: [TaskFramework] = Task.GetAllPresetTasks()
    
    // TODO: Figure out why the phone day/night setting background won't go away, and make it go away
    // TODO: Figure out how to get the animation when removing a task back to appear on the list
    
    var body: some View {
        if taskList.isEmpty {
            // Show that no tasks exist, and direct them to the task creation button
            // TODO: Style this and show the time remaining until Tasks reset
            VStack {
                Text("No tasks remaining.")
                    .font(.title3)

                Text("More tasks will become available tomorrow!")
                    .font(.title3)
            }.frame(alignment: .top)
            
            Spacer()
        } else {
            // List of active tasks
            List(taskList) { task in
                TaskPresetListItem(task)
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
        }
    }
}


#Preview {
    TaskPresetView()
}
