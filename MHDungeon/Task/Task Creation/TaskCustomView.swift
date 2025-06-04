//
//  TaskCreationView.swift
//  MHDungeon
//

import SwiftUI

// MARK: Set the constraints of custom task creation here
private let MAX_POINTS: Int = 15
private let MAX_HOURS: Double = 168.0
private let MAX_NAME_LENGTH: Int = 30
private let MAX_DETAILS_LENGTH: Int = 200

/// A view which guides the user through creating a custom `Task` before adding it to their `Account`.
struct TaskCustomView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Contains the account which stores the list of the user's current tasks
    @EnvironmentObject private var authModel: AuthModel
    
    /// The user-provided name of the `Task`.
    @State private var name: String = ""
    /// The provided details of the `Task`.
    @State private var details: String = ""
    /// The number of `Inspiration Points` that the `Task` rewards upon completion,
    @State private var inspirationPoints: Int?
    /// The number of hours until the `Task` expires after creation.
    @State private var hoursToExpiration: Double?
    
    /// A storage and display variable for any errors that the user encounters during the `Task` creation process.
    @State private var errorMessage: String = ""
    /// The `Task` that the user has created.
    ///
    /// This will be stored within the user's list of `Task`s inside `Account`.
    @State private var createdTask: Task? = nil
    
    // Communication (and settings) button controls
    private let buttonRadius: CGFloat = 20
    private let buttonHeight: CGFloat = 40
    
    var body: some View {
        // TODO: Change up the points and hours options. The user should only be selecting the timer (As a difficulty option) and the points should be allocated based on that
        
        VStack {
            // TODO: Create input fields and dropdown lists for the user to make decisions with
            // Daily limit: 4 Easy tasks (1), 2 Hard tasks (4), and 1 Challenging task (6)
            
            // Input fields for the user to fill in task details
            Form {
                Section(header: Text("Task Information")) {
                    TextField("Name", text: $name)
                        .onChange(of: name) { oldValue, newValue in
                            if newValue.count > MAX_NAME_LENGTH {
                                name = oldValue
                            }
                        }
                    
                    TextField("Details", text: $details)
                        .onChange(of: details) { oldValue, newValue in
                            if newValue.count > MAX_DETAILS_LENGTH {
                                name = oldValue
                            }
                        }
                    
                }
                Section(header: Text("Task Features")) {
                    // Allow the user to add an IP reward of between 0 and MAX_POINTS to the Task.
                    TextField("Inspiration Points", value: $inspirationPoints, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .onChange(of: inspirationPoints) { oldValue, newValue in
                            if let value = newValue {
                                if value < 0 {
                                    inspirationPoints = 0
                                } else if value > MAX_POINTS {
                                    inspirationPoints = MAX_POINTS
                                }
                            }
                        }
                    
                    // Allow the user to set the expiration date between 0 and MAX_HOURS in the future to the Task.
                    TextField("Hours to Expiration", value: $hoursToExpiration, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                        .onChange(of: hoursToExpiration) { oldValue, newValue in
                            if let value = newValue {
                                if value < 0 {
                                    hoursToExpiration = 0
                                } else if value > MAX_HOURS {
                                    hoursToExpiration = MAX_HOURS
                                }
                            }
                        }
                }
            }
            
            Text(errorMessage)
                .font(.title3)
                .foregroundColor(Color.red)
            
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
                    
                    // Attempt to create a new Task from the input values
                    guard let points: Int = inspirationPoints else {
                        errorMessage = "Please enter a valid number for inspiration points."
                        return
                    }

                    guard let hours: Double = hoursToExpiration else {
                        errorMessage = "Please enter a valid number for hours to expiration."
                        return
                    }

                    do {
                        // TODO: Make a static function inside Task and hide the authModel inside
                        // Attempt to create a task using the data provided by the user
                        try authModel.AddTask(name: name, details: details, points: points, hours: hours)
                        
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
            .padding(EdgeInsets(top: -8, leading: 16, bottom: 8, trailing: 16))
        }
    }
}

#Preview {
    TaskCustomView()
}
