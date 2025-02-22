//
//  TaskItem.swift
//  MHDungeon
//
//  Created by Collin Bowdoin on 2/21/25.
//

import SwiftUI

struct TaskListItem: View {
    // The task on display
    var task: Task?
    
    // Features from the task that we have brought out into their own variables
    let name: String
    let points: Int
    let expirationTime: Date

    @State private var timeRemaining: String = "Expires in <ERROR>"

    // Official init, this is what should be used when this view is actually being called
    init(_ task: Task) {
        self.task = task
        
        self.name = task.name
        self.points = task.points
        self.expirationTime = task.expirationTime
    }
    
    // Preview init because error handling is impossible on those
    #if DEBUG
    init(name: String, inspirationPoints: Int, expirationTime: Date) {
        self.name = name
        self.points = inspirationPoints
        self.expirationTime = expirationTime
    }
    #endif
    
    var body: some View {
        
        // Task display bar with buttons
        RoundedRectangle(cornerRadius: 20)
            .foregroundColor(Color.green)
            .frame(width: screenWidth * 0.9, height: 140, alignment: .bottom)
            .overlay {
                VStack{
                    // Checkmark and name
                    HStack {
                        // Checkmark button to mark the task as complete
                        Button {
                            print("\(name) checked!")
                            
                            // TODO: Remove after testing
                            updateTimeRemaining()
                        } label: {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(Color.black)
                                .frame(width: 80, height: 80, alignment: .topLeading)
                                .overlay {
                                    Image(systemName: "checkmark")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 60, height: 60, alignment: .center)
                                        .foregroundColor(Color.white)
                                }
                        }
                        
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
                        Text("\(timeRemaining)")
                    }
                    
                }.padding()
            }
            .listRowBackground(Color.clear)
    }
    
    // Updates and formats the remaining time for display
    // TODO: Change the following function to remove the days/hours/minutes/seconds variables and use just the timeRemaining variable (Or a temp, yes, should use a temp instead)
    func updateTimeRemaining() {
        // Record the present time to stop changing values from execution time
        let now = Date.now
        
        // Ensure that the expiration time hasn't already passed
        guard expirationTime > now else {
            timeRemaining = "Expired"
            return
        }
        
        // Store the days, hours, and minutes in separate variables (Contains the whole string display of the time segment). The booleans are for format assistance
        var days: String = ""
        var hasDays: Bool = false
        var hours: String = ""
        var hasHours: Bool = false
        var minutes: String = ""
        var hasMinutes: Bool = false
        var seconds: String = ""
        
        // Calculate the time difference
        let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: now, to: expirationTime)
        
        // TODO: REMOVE after testing
        print("Days: \(components.day), Hours: \(components.hour), Minutes: \(components.minute), Seconds: \(components.second)")
        
        // Add the days remaining if there are any
        if let daysRemaining = components.day, daysRemaining > 0 {
            // Show that our string will contain days
            hasDays = true
            
            days = "\(daysRemaining) day"
            
            // Show the plurality
            if daysRemaining > 1 {
                days += "s"
            }
        }
        
        // Add the hours remaining if there are any
        if let hoursRemaining = components.hour, hoursRemaining > 0 {
            // Format the days segment to account for the hours segment
            if hasDays {
                days += ", "
            }
            
            // Show that our string will contain hours
            hasHours = true
            
            hours = "\(hoursRemaining) hour"
            
            // Show the plurality
            if hoursRemaining > 1 {
                hours += "s"
            }
        }
        
        // Add the minutes remaining if there are any, so long as no days remain either
        if hasDays == false {
            if let minutesRemaining = components.minute, minutesRemaining > 0 {
                // Format the hours segment to account for the minutes segment
                if hasHours {
                    hours += ", "
                }
                
                // Show that our string will contain minutes
                hasHours = true
                
                minutes = "\(minutesRemaining) minute"
                
                // Show the plurality
                if minutesRemaining > 1 {
                    minutes += "s"
                }
            }
        }
        
        // If there are no days, hours, or minutes, then there is likely only seconds left on the clock and we will display that
        if !hasDays && !hasHours && !hasMinutes {
            if let secondsRemaining = components.second, secondsRemaining > 0 {
                seconds = "\(secondsRemaining) second"
                
                // Show the plurality
                if secondsRemaining > 1 {
                    seconds += "s"
                }
            }
        }
        
        timeRemaining = "Expires in \(days)\(hours)\(minutes)\(seconds)"
        
        // TODO: REMOVE after testing
        print(timeRemaining)
    }
}

#Preview("Task Item") {
    // Uses the number of minutes in a time span: Days, Hours, and Minutes
    var minutesCalculated: Double = (1440.0 * 0) + (60.0 * 0) + (1.0 * 1.2)
    
    TaskListItem(name: "Example Task goes here. Can you not see it? Clearly, something else is going on here", inspirationPoints: 10, expirationTime: Date.now.addingTimeInterval( minutesCalculated * 60))
}

// Note from Dehrens on previewing throwing objects:
//  Make a DEBUG build only fileinternal init that takes a mock-object instead that can't throw
