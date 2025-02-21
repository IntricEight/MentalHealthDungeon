//
//  TaskItem.swift
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

class TaskItem {
    private var name: String        // Should summarize the task assigned
    private var description: String     //Can contain a more detailed summmary of the task's objectives. Can be empty, but not nil
    private var points: Int     // The number of Inspiration Points that the
    private var creationTime: Date      //Tracks the time of the task's creation
    private var expirationTime: Date        //Tracks the time when the task expires
    
    // 5-arg constructor which allows the expiration time of the task to be directly provided
    init(name: String, description: String = "", inspirationPoints: Int, expirationTime: Date) throws(TaskCreationError) {
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
        self.description = description
        self.points = inspirationPoints
        self.creationTime = Date.now
        self.expirationTime = expirationTime
    }
    
    // 5-arg constructor which allows the number of hours the task will be active to be provided
    init(name: String, description: String = "", inspirationPoints: Int, hoursToExpiration: Int) throws {
        // Error checking
        if inspirationPoints == 0 {
            // TODO: Throw an exception - Points cannot be 0
        } else if inspirationPoints < 0 {
            // TODO: Throw an exception - Points cannot be negative
        }
        
        self.name = name
        self.description = description
        self.points = inspirationPoints
        self.creationTime = Date.now
        
        // Calculate the expiration time using the creationTime and number of allowed hours
        self.expirationTime = creationTime.addingTimeInterval(TimeInterval(hoursToExpiration * 3600))

    }
    
    // Contains the error checking
    func InitErrorChecking(points: Int) -> Void {
        // TODO: Either figure out how to call functions in init before setting all variables, or trash this function
        
        // Error checking
        if points == 0 {
            // TODO: Throw an exception - Points cannot be 0
        } else if points < 0 {
            // TODO: Throw an exception - Points cannot be negative
        }
    }
    
    // Get the remaining time before the task expires
    func GetRemainingTime() -> TimeInterval {
        return expirationTime.timeIntervalSinceNow
    }
}

class TaskList {
    
}
