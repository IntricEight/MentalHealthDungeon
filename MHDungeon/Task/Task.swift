//
//  Task.swift
//  MHDungeon
//
//  Created by Collin Bowdoin on 2/19/25.
//

import Foundation

enum TaskCreationError: Error {
    case ZeroPoints
    case NegativePoints
    case InvalidExpiration
}

struct Task : CustomStringConvertible, Hashable, Codable, Identifiable {
    var id: UUID = UUID()
    
    // Should summarize the task assigned
    private(set) var name: String
    
    //Can contain a more detailed summmary of the task's objectives. Can be empty, but not nil
    private(set) var details: String = ""
    
    // The number of Inspiration Points that the task can reward
    private(set) var points: Int
    
    //Tracks the time of the task's creation
    private(set) var creationTime: Date
    
    //Tracks the time when the task expires
    private(set) var expirationTime: Date
    
    
    
    // 5-arg constructor which allows the expiration time of the task to be directly provided
    init(name: String, details: String, inspirationPoints: Int, expirationTime: Date) throws(TaskCreationError) {
        // Error checking
        // Ensure the IP suggested in within the valid range
        if inspirationPoints == 0 {
            // Throw an exception - Points cannot be 0
            throw TaskCreationError.ZeroPoints
            
        } else if inspirationPoints < 0 {
            // Throw an exception - Points cannot be negative
            throw TaskCreationError.NegativePoints
        }
        
        // Ensure the expiration time provided is in the future
        guard expirationTime > Date.now else {
            // Throw an exception - Expiration time must be in the future
            throw TaskCreationError.InvalidExpiration
        }
        
        self.name = name
        self.details = details
        self.points = inspirationPoints
        self.creationTime = Date.now
        self.expirationTime = expirationTime
    }
    
    // 5-arg constructor which allows the number of hours the task will be active to be provided
    init(name: String, details: String, inspirationPoints: Int, hoursToExpiration: Int) throws {
        // Error checking
        // Ensure the IP suggested in within the valid range
        if inspirationPoints == 0 {
            // Throw an exception - Points cannot be 0
            throw TaskCreationError.ZeroPoints
            
        } else if inspirationPoints < 0 {
            // Throw an exception - Points cannot be negative
            throw TaskCreationError.NegativePoints
        }
        
        self.name = name
        self.details = details
        self.points = inspirationPoints
        self.creationTime = Date.now
        
        // Calculate the expiration time using the creationTime and number of allowed hours
        self.expirationTime = creationTime.addingTimeInterval(TimeInterval(hoursToExpiration * 3600))

    }
    
    
    
    
    
    // Contains the error checking
    func InitErrorChecking(points: Int) -> Void {
        // TODO: Either figure out how to call functions in init before setting all variables, or trash this function
    }
    
    // Get the remaining time before the task expires
    func GetRemainingTime() -> TimeInterval {
        return expirationTime.timeIntervalSinceNow
    }
    
    
    
    
    
    
    
    
    
    // TODO: Make this more useful after initial testing is complete
    var description: String {       // Allows me to control what gets printed to the Console
        return "Task: \(name). Expires at \(expirationTime)"
    }
    
}
