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
    var task: Task?
    
    // Features from the Task that have been brought out into their own variables.
    /// The name of the `Task`.
    let name: String
    /// The number of `Inspiration Points` that the `Task` will reward.
    let points: Int
    /// Tracks the time when the `Task` expires.
    let expirationTime: Date

    /// A visual countdown of the time remaining before the `Task` expires.
    @State private var timeRemaining: String = "Expires in <LOADING>"
    
    /// Controls how frequently the visual countdown updates.
    let timeInterval: Double = 40
    /// Message to show that the countdown has elapsed
    let expiredMessage: String = "Expired"
    

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
        
        // Task display bar with buttons
        // TODO: Figure out why the checkmark button code executes wherever you click on the task
        RoundedRectangle(cornerRadius: 20)
            .foregroundColor(Color.green)
            .frame(width: screenWidth * 0.9, height: 140, alignment: .bottom)
            .overlay {
                VStack {
                    // Checkmark and name
                    HStack {
                        // Checkmark button to mark the task as complete
                        Button {
                            print("\(name) checked!")
                            
                            // Mark the Task as either failed or completed and remove it from the user
                            Task.deleteTask(id: task?.id, authAccess: authModel, isCompleted: timeRemaining != expiredMessage)
                        } label: {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(Color.black)
                                .frame(width: 80, height: 80, alignment: .topLeading)
                                .overlay {
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
                            .onAppear(perform: updateTimeRemaining)
                            .onReceive(Timer.publish(every: timeInterval, on: .main, in: .common).autoconnect()) { _ in
                                    updateTimeRemaining()
                                }
                    }
                    
                }.padding()
            }
            .listRowBackground(Color.clear)
    }
    
    /// Updates and formats the remaining time for the display.
    func updateTimeRemaining() -> Void {
        /// Record the present time to stop the value changing from now until execution time.
        let now = Date.now
        
        // Ensure that the expiration time hasn't already passed.
        guard expirationTime > now else {
            timeRemaining = expiredMessage
            return
        }
        
        /// Store the time remaining in a formatted string.
        var formatting: String = ""
        
        // Record whether the segment was used for format assistance.
        var hasDays: Bool = false
        var hasHours: Bool = false
        var hasMinutes: Bool = false
        
        // Calculate the time difference
        let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: now, to: expirationTime)
        
        // Add the days remaining if there are any
        if let daysRemaining = components.day, daysRemaining > 0 {
            // Record that our string will contain days
            hasDays = true
            
            formatting += "\(daysRemaining) day"
            
            // Show the plurality
            if daysRemaining > 1 {
                formatting += "s"
            }
        }
        
        // Add the hours remaining if there are any
        if let hoursRemaining = components.hour, hoursRemaining > 0 {
            // Format the days segment to account for the hours segment
            if hasDays {
                formatting += ", "
            }
            
            // Record that our string will contain hours
            hasHours = true
            
            formatting += "\(hoursRemaining) hour"
            
            // Show the plurality
            if hoursRemaining > 1 {
                formatting += "s"
            }
        }
        
        // Add the minutes remaining if there are any, so long as no days remain either
        if !hasDays {
            if let minutesRemaining = components.minute, minutesRemaining > 0 {
                // Format the hours segment to account for the minutes segment
                if hasHours {
                    formatting += ", "
                }
                
                // Record that our string will contain minutes
                hasMinutes = true
                
                formatting += "\(minutesRemaining) minute"
                
                // Show the plurality
                if minutesRemaining > 1 {
                    formatting += "s"
                }
            }
        }
        
        // If there are no days, hours, or minutes, then there is likely only seconds left on the clock and we will display that
        if !hasDays && !hasHours && !hasMinutes {
            if let secondsRemaining = components.second, secondsRemaining > 0 {
                formatting = "\(secondsRemaining) second"
                
                // Show the plurality
                if secondsRemaining > 1 {
                    formatting += "s"
                }
            }
        }
        
        timeRemaining = "Expires in \(formatting)"
    }
}

#Preview("Task Item") {
    // Uses the number of minutes in a time span: Days, Hours, and Minutes
    let minutesCalculated: Double = (1440.0 * 3) + (60.0 * 7) + (1.0 * 9)
    
    TaskListItem(name: "Example Task goes here. Can you not see it? Clearly, something else is going on here", inspirationPoints: 10, expirationTime: Date.now.addingTimeInterval( minutesCalculated * 60))
}

// Note from Dehrens on previewing throwing objects:
//  Make a DEBUG build only fileinternal init that takes a mock-object instead that can't throw
