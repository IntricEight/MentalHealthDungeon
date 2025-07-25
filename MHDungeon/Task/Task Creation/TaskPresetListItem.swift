//
//  TaskPresetListItem.swift
//  MHDungeon
//

import SwiftUI

struct TaskPresetListItem: View {
    // Contains the account which stores the list of the user's current tasks
    @EnvironmentObject var authModel: AuthModel
    
    /// The model of the `Task` being displayed.
    private var task: TaskFramework?
    
    // Features from the Task that have been brought out into their own variables.
    /// The name of the `Task`.
    private let name: String
    /// Details about the `Task`.
    private let details: String
    /// The number of `Inspiration Points` that the `Task` will reward.
    private let points: Int
    /// Displays the hours the `Task` will be active.
    private let hoursToExpire: Double
    
    /// A visual countdown of the time remaining before the `Task` expires.
    @State private var timeRemaining: String = "Expires in <LOADING>"
    // Get a timer to convert the expiration timer into Days, Hours, Minutes, Seconds format
    private let dhmsTimer: DHMSTimer = DHMSTimer()
    
    // Official init, this is what should be used when this view is actually being called by lists.
    /// Initialize the list visual with a `TaskFramework` item.
    init(_ task: TaskFramework) {
        self.task = task
        
        self.name = task.name
        self.details = task.details
        self.points = task.inspirationPoints
        self.hoursToExpire = task.hoursToExpire
    }
    
    var body: some View {
        
        // Task display bar with buttons
        RoundedRectangle(cornerRadius: 20)
            .foregroundColor(Color.yellow)
            .frame(width: screenWidth * 0.9, height: 140, alignment: .bottom)
            .overlay {
                VStack {
                    // Checkmark and name
                    HStack {
                        // Checkmark button to mark the task as complete
                        Button {
                            print("Adding \"\(name)\" to Task List")
                            
                            // Add the selected Task to the user's list
                            do  {
                                try authModel.AddTask(name: name, details: details, points: points, hours: hoursToExpire)
                            } catch {
                                print("Failed to add the task to the user")
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(Color.black)
                                .frame(width: 80, height: 80, alignment: .topLeading)
                                .overlay {
                                    // Show an icon of a Plus symbol
                                    Image(systemName: "plus")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 60, height: 60, alignment: .center)
                                        .foregroundColor(Color.white)
                                }
                        }.buttonStyle(.borderless)
                        
                        Spacer(minLength: 16)
                        
                        Text(name)
                            .font(.title)
                            .lineLimit(2)
                            .truncationMode(.tail)
                    }
                    
                    // Points and remaining time
                    HStack {
                        
                        Text("\(points)")
                        Spacer(minLength: 8)
                        
                        // Display the remaining time in a sporatic countdown. onAppear() runs the update on loading, while onReceive() runs it every 'timeInterval' after
                        Text("\(timeRemaining)")
                            .onAppear {
                                // Ensure that the time until expiration is displayed upon loading
                                dhmsTimer.UpdateTimeRemaining(timeRemaining: &timeRemaining, expirationTime: Date.now.addingTimeInterval(hoursToExpire * 3600),  template: "", message: "Should not appear")
                            }
                    }
                    
                }.padding()
            }
            .listRowBackground(Color.clear)
    }
}
