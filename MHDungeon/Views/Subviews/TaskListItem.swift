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

    @State private var timeRemaining: String = "Expires in <LOADING>"
    
    // Controls how frequently the countdown updates
    let timeInterval: Double = 40

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
    
    // Updates and formats the remaining time for display
    func updateTimeRemaining() -> Void {
        // Record the present time to stop changing values from execution time
        let now = Date.now
        
        // Ensure that the expiration time hasn't already passed
        guard expirationTime > now else {
            timeRemaining = "Expired"
            return
        }
        
        // Store the time remaining in a formatted string
        var formatting: String = ""
        
        // Record whether the segmnet was used for format assistance
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
    var minutesCalculated: Double = (1440.0 * 3) + (60.0 * 7) + (1.0 * 9)
    
    TaskListItem(name: "Example Task goes here. Can you not see it? Clearly, something else is going on here", inspirationPoints: 10, expirationTime: Date.now.addingTimeInterval( minutesCalculated * 60))
}

// Note from Dehrens on previewing throwing objects:
//  Make a DEBUG build only fileinternal init that takes a mock-object instead that can't throw
