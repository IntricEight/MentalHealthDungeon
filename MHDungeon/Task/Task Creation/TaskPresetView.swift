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
            
            Text("Display a list of premade tasks")
            
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
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        }
    }
}

#Preview {
    TaskPresetView()
}
