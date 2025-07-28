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
        // TODO: Instead of having a list to add, then clicking Add, it might be better to just add it immediately once the Plus is clicked. We can use the bottom button space for Stats like remaining choices before you run out of X difficulty for the day
        
        VStack {
            // TODO: Display a list of task items that can be added to the user's list. These presets should have the ability to set a timer so that once they are completed, they enter a cooldown
            
            
            
            Text("Choose tasks to add")
            
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
                    print("Add the Selected Task selected")
                    
                    // Think about what could replace this button if I remove it in favor of using the Task list items directly
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

/// A subview which displays the user's `Task`s if any exist, and instructions them to do so otherwise.
private struct TaskListView: View {
    // TODO: Test converting into a set once the initial list is working. Also, if it needs privating
    /// The list of the user's `Task`s.
    @State var tasks: [TaskFramework] = Task.GetAllPresetTasks()
    
    var body: some View {
        if tasks.isEmpty {
            // Show that no tasks exist, and suggest that they progress through the app until they unlock some
            VStack {
                Text("No tasks unlocked to add.")
                    .font(.title3)

                Text("Perhaps try creating your own?")
                    .font(.title3)
            }.frame(alignment: .top)
            
            Spacer()
        } else {
            // List of active tasks
            List(tasks) { task in
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
