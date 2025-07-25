//
//  TaskItem.swift
//  MHDungeon
//

import SwiftUI

// TODO: Refactor to be used in the Preset lists of tasks with a '+' instead of a checkmark

/// A subview which displays the contents of a single `Task` within a visual list.
struct TaskListItem: View {
    // Contains the account which stores the list of the user's current tasks
    @EnvironmentObject var authModel: AuthModel
    
    /// The `Task` being displayed.
    private var task: Task?
    
    // Features from the Task that have been brought out into their own variables.
    /// The name of the `Task`.
    private let name: String
    /// The number of `Inspiration Points` that the `Task` will reward.
    private let points: Int
    /// Tracks the time when the `Task` expires.
    private let expirationTime: Date

    /// A visual countdown of the time remaining before the `Task` expires.
    @State private var timeRemaining: String = "Expires in <LOADING>"
    
    /// A template to base the `timeRemaining` display value off of.
    private let timeRemainingTemplate: String = "Expires in "
    /// Controls how frequently the visual countdown updates (In seconds).
    private let timeInterval: Double = 1
    /// Message to show that the countdown has elapsed
    private let expiredMessage: String = "Expired"
    
    // Get a timer to convert the remanining time into Days, Hours, Minutes, Seconds format
    private let dhmsTimer: DHMSTimer = DHMSTimer()

    // Official init, this is what should be used when this view is actually being called by lists.
    /// Initialize the list visual with a `Task` item.
    init(_ task: Task) {
        self.task = task
        
        self.name = task.name
        self.points = task.points
        self.expirationTime = task.expirationTime
    }
    
    // Preview init because error handling is impossible on Previews, it seems
    #if DEBUG
    init(name: String, inspirationPoints: Int, expirationTime: Date) {
        self.name = name
        self.points = inspirationPoints
        self.expirationTime = expirationTime
    }
    #endif
    
    var body: some View {
        
        // TODO: Bring the name and other task details into here to bring them out of Struct variable status.
        // This will require changing the preview, which is why I haven't done it yet myself.
        
        // Task display bar with buttons
        RoundedRectangle(cornerRadius: 20)
            .foregroundColor(Color.green)
            .frame(width: screenWidth * 0.9, height: 140, alignment: .bottom)
            .overlay {
                VStack {
                    // Checkmark and name
                    HStack {
                        // Checkmark button to mark the task as complete
                        Button {
                            // Mark the Task as either failed or completed and remove it from the user
                            Task.DeleteTask(id: task?.id, authAccess: authModel, isCompleted: timeRemaining != expiredMessage)
                        } label: {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(Color.black)
                                .frame(width: 80, height: 80, alignment: .topLeading)
                                .overlay {
                                    // Change the icon to show whether the task will be completed successfully or has failed
                                    Image(systemName: timeRemaining != expiredMessage ? "checkmark" : "xmark")
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
                        // TODO: Calculate the total space the points text is taking up so that it remains consistent no matter how many points are being rewarded
                        Text("\(points)")
                        Spacer(minLength: 8)
                        
                        // Display the remaining time in a sporatic countdown. onAppear() runs the update on loading, while onReceive() runs it every 'timeInterval' after
                        Text("\(timeRemaining)")
                            .onAppear {
                                // Ensure that the time until expiration is displayed upon loading
                                dhmsTimer.UpdateTimeRemaining(timeRemaining: &timeRemaining, expirationTime: expirationTime,  template: timeRemainingTemplate, message: expiredMessage)
                            }
                            .onReceive(Timer.publish(every: timeInterval, on: .main, in: .common).autoconnect()) { _ in
                                // After timeInterval second(s) have passed, this takes over the remaining time display
                                dhmsTimer.UpdateTimeRemaining(timeRemaining: &timeRemaining, expirationTime: expirationTime, template: timeRemainingTemplate, message: expiredMessage)
                                }
                    }
                    
                }.padding()
            }
            .listRowBackground(Color.clear)
    }
}

#Preview("Task Item") {
    // Uses the number of minutes in a time span: Days, Hours, and Minutes
    let minutesCalculated: Double = (1440.0 * 3) + (60.0 * 7) + (1.0 * 9)
    
    TaskListItem(name: "Example Task goes here. Can you not see it? Clearly, something else is going on here", inspirationPoints: 10, expirationTime: Date.now.addingTimeInterval( minutesCalculated * 60))
}

// Note from Dehrens on previewing throwing objects:
//  Make a DEBUG build only fileinternal init that takes a mock-object instead that can't throw
