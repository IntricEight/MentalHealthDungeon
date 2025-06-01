//
//  Task.swift
//  MHDungeon
//

import Foundation

/// Errors that can be caused during the creation of a `Task`.
enum TaskCreationError: Error, LocalizedError {
    /// Thrown when a `Task` is made which rewards zero `Inspiration Points`.
    case ZeroPoints
    /// Thrown when a `Task` is made which rewards zero `Inspiration Points`.
    case NegativePoints
    /// Thrown when a `Task` is made who's expiration time is in the past.
    case InvalidExpiration
    
    /// The useful description of each error used by `LocalizedError`.
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

/// A model which manages the identity of an objective that the user can complete within an established time frame to earn `Inspiration Points`.
struct Task : Codable, CustomStringConvertible, Hashable, Identifiable {
    /// Store a unique ID of the `Task` instance.
    var id: UUID = UUID()
    /// The name of the `Task`, which should summarize the objective in a few words.
    let name: String
    /// Contains a (more) detailed summmary of the `Task`'s objectives than the name.
    ///
    /// Can be empty, but not nil. User submission should be optional.
    let details: String
    // TODO: Convert into an unsigned int
    /// The number of `Inspiration Points` that the `Task` will reward.
    let points: Int
    /// Tracks the time when the `Task` was created.
    let creationTime: Date
    /// Tracks the time when the `Task` expires.
    let expirationTime: Date
    
    // 5-arg constructor which allows the expiration time of the task to be directly provided.
    /// Initialize a `Task` with the expiration time directly provided.
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
    
    // 5-arg constructor which allows the number of hours the task will be active to be provided.
    /// Initialize a `Task` with the number of hours until expiration provided.
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
    
    
    
    
    
    /// Error checking that should be performed during initialization.
    func InitErrorChecking(points: Int) -> Void {
        // TODO: Either figure out how to call functions in init before setting all variables, or trash this function
    }
    
    /// Get the remaining time before the `Task` expires.
    func GetRemainingTime() -> TimeInterval {
        return expirationTime.timeIntervalSinceNow
    }
    
    /// Convert the `Task` into a `Dictionary` to assist with updating the database.
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
    
    // TODO: Check if I can remove the ? on UUID? without breaking anything?
    
    /// `@MainActor` static function that removes the provided `Task` from the application and `Firebase` storage.
    ///
    /// If the `Task` was completed successfully, rewards the player with the appropriate points.
    ///
    /// - Parameters:
    ///   - taskUID: The unique ID of the `Task` being deleted.
    ///   - auth: The `AuthModel` that manages access to the `Firebase` records.
    ///   - isCompleted: Whether the `Task` was completed successfully, or was failed and is being removed.
    @MainActor
    static func DeleteTask(id taskUID: UUID?, authAccess auth: AuthModel, isCompleted: Bool)
    {
        // This function largely exists at present to abstract away the AuthModel access from views.
        auth.DeleteTask(id: taskUID, isCompleted: isCompleted)
    }
    
    
    // TODO: Make this more useful after initial testing is complete
    /// The description of the `Task`, to be used when printing to the console or stored within a `String`.
    var description: String {       // Allows me to control what gets printed to the Console
        return "Task: \(name). Expires at \(expirationTime)"
    }
    
}
