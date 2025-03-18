//
//  Task.swift
//  MHDungeon
//

import Foundation

enum TaskCreationError: Error, LocalizedError {
    case ZeroPoints
    case NegativePoints
    case InvalidExpiration
    
    var errorDescription: String? {
        switch self {
            case .ZeroPoints:
                return "Cannot reward zero inspiration points."
            case .NegativePoints:
                return "Cannot reward negative inspiration points."
            case .InvalidExpiration:
                return "The expiration time must be beyond the present."
        }
    }
}

struct Task : Codable, CustomStringConvertible, Hashable, Identifiable {
    // Store a unique ID of the Task instance
    var id: UUID = UUID()
    
    // Should summarize the task assigned
    let name: String
    
    //Can contain a more detailed summmary of the task's objectives. Can be empty, but not nil. User submission should be optional
    let details: String
    
    // The number of Inspiration Points that the task can reward
    // TODO: Convert into an unsigned int
    let points: Int
    
    //Tracks the time of the task's creation
    let creationTime: Date
    
    //Tracks the time when the task expires
    let expirationTime: Date
    
    
    
    // 5-arg constructor which allows the expiration time of the task to be directly provided
    init(name: String, details: String = "", inspirationPoints ip: Int, expirationTime: Date) throws(TaskCreationError) {
        // Error checking
        // Ensure the IP suggested in within the valid range
        if ip == 0 {
            // Throw an exception - Points cannot be 0
            throw TaskCreationError.ZeroPoints
            
        } else if ip < 0 {
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
        self.points = ip
        self.creationTime = Date.now
        self.expirationTime = expirationTime
    }
    
    // 5-arg constructor which allows the number of hours the task will be active to be provided
    init(name: String, details: String, inspirationPoints ip: Int, hoursToExpiration expiresIn: Double) throws {
        // Error checking
        // Ensure the IP suggested in within the valid range
        if ip == 0 {
            // Throw an exception - Points cannot be 0
            throw TaskCreationError.ZeroPoints
            
        } else if ip < 0 {
            // Throw an exception - Points cannot be negative
            throw TaskCreationError.NegativePoints
        }
        
        // Ensure the expiration time provided is in the future
        if expiresIn <= 0.0 {
            // Throw an exception - Expiration time must be in the future
            throw TaskCreationError.InvalidExpiration
        }
        
        self.name = name
        self.details = details
        self.points = ip
        self.creationTime = Date.now
        
        // Calculate the expiration time using the creationTime and number of allowed hours (3600 seconds in an hour)
        self.expirationTime = creationTime.addingTimeInterval(TimeInterval(expiresIn * 3600))

    }
    
    
    
    
    
    // Contains the error checking
    func InitErrorChecking(points: Int) -> Void {
        // TODO: Either figure out how to call functions in init before setting all variables, or trash this function
    }
    
    // Get the remaining time before the task expires
    func GetRemainingTime() -> TimeInterval {
        return expirationTime.timeIntervalSinceNow
    }
    
    // Mark the task as complete
    func CompleteTask() -> Bool {
        // TODO: Decide if this should even be within the Task struct, or in the account.
        // TODO: Remove the Task from the database, and set a timeout on it if it is premade
        
        return true
    }
    
    // Convert the task into a dictionary to assist with updating the database
    func toDictionary() -> [String: Any] {
        return [
            "id" : id.uuidString,
            "name" : name,
            "details" : details,
            "points" : points,
            "creationTime" : creationTime,
            "expirationTime" : expirationTime
        ]
    }
    
    
    
    
    // TODO: Make this more useful after initial testing is complete
    var description: String {       // Allows me to control what gets printed to the Console
        return "Task: \(name). Expires at \(expirationTime)"
    }
    
}
