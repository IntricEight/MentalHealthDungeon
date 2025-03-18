//
//  TaskCreationView.swift
//  MHDungeon
//

import SwiftUI

struct TaskCustomView: View {
    @Environment(\.dismiss) var dismiss
    
    // Stores the list of the user's current tasks
    @EnvironmentObject var authModel: AuthModel
    
    @State private var name: String = ""
    @State private var details: String = ""
    @State private var inspirationPoints: String = ""
    @State private var hoursToExpiration: String = ""
    
    @State private var errorMessage: String? = nil
    @State private var createdTask: Task? = nil
    
    // Communication (and settings) button controls
    let buttonRadius: CGFloat = 20
    let buttonHeight: CGFloat = 40
    
    var body: some View {
        // TODO: Has various text and selection inputs to allow the user to create a task from several options
        
        VStack {
            // TODO: Create input fields and dropdown lists for the user to make decisions with
            // Daily limit: 4 Easy tasks (1), 2 Hard tasks (4), and 1 Challenging task (6)
            
            // Input fields for the user to fill in task details
            Form {
                Section(header: Text("Task Information")) {
                    TextField("Name", text: $name)
                    TextField("Details", text: $details)
                }
                Section(header: Text("Parameters")) {
                    TextField("Inspiration Points", text: $inspirationPoints)
                        .keyboardType(.numberPad)
                    TextField("Hours to Expiration", text: $hoursToExpiration)
                        .keyboardType(.decimalPad)
                }
            }
            
            Spacer()
            
            Text("Allow the user to create a task")
            
            Spacer()
            
            // Finalize the new task process by canceling or creating it
            HStack {
                // Cancel Task creation
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
                
                // Create the new Task
                Button {
                    print("Create the New Task selected")
                    
                    // TODO: Attempt to create a new Task from the input values
                    guard let points = Int(inspirationPoints) else {
                        errorMessage = "Please enter a valid number for inspiration points."
                        return
                    }

                    guard let hours = Double(hoursToExpiration) else {
                        errorMessage = "Please enter a valid number for hours to expiration."
                        return
                    }

                    do {
                        // Attempt to create a task using the data provided by the user
                        try authModel.addTask(name: name, details: details, points: points, hours: hours)
                        
                        // Dismiss the view.
                        print("< Created a new Task of {\(name), \(details), \(points), \(hours)}")
                        dismiss()
                    } catch let error as TaskCreationError {
                        errorMessage = error.localizedDescription
                    } catch {
                        errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
                    }
                    
                } label: {
                    RoundedRectangle(cornerRadius: buttonRadius)
                        .frame(height: buttonHeight)
                        .foregroundColor(Color.indigo)
                        .overlay {
                            Text("Create Task")
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
    TaskCustomView()
}
