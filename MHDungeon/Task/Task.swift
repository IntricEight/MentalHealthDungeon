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
    /// Thrown when an error is encountered during the decoding process.
    case DecodeError
    /// Thrown when the file containing the `Dungeon`s cannot be found.
    case FileNotFound
    
    /// The useful description of each error used by `LocalizedError`.
    var errorDescription: String? {
        switch self {
            case .ZeroPoints:
                return "Cannot reward zero inspiration points."
            case .NegativePoints:
                return "Cannot reward negative inspiration points."
            case .InvalidExpiration:
                return "The expiration time must be beyond the present."
            case .DecodeError:
                return "Failed to properly decode the task's JSON file."
            case .FileNotFound:
                return "Failed to locate the task's JSON file."
        }
    }
}

/// A model which manages the identity of an objective that the user can complete within an established time frame to earn `Inspiration Points`.
struct Task : Codable, Hashable, Identifiable {
    /// Store a unique ID of the `Task` instance.
    var id: UUID = UUID()
    /// The name of the `Task`, which should summarize the objective in a few words.
    let name: String
    /// Contains a (more) detailed summmary of the `Task`'s objectives than the name.
    ///
    /// Can be empty, but not nil. User submission should be optional.
    let details: String
    /// The number of `Inspiration Points` that the `Task` will reward.
    let points: Int
    /// Tracks the time when the `Task` was created.
    let creationTime: Date
    /// Tracks the time when the `Task` expires.
    let expirationTime: Date
    
    // 5-arg constructor which allows the expiration time of the task to be directly provided.
    /// Initialize a `Task` with the expiration time directly provided.
    init(name: String, details: String = "", inspirationPoints ip: Int, expirationTime: Date) throws {
        // Ensure that proper values are being used to create this task. Does not include time in this instance, that is handled below.
        try Task.ValidateTask(inspirationPoints: ip)
        
        // Ensure the expiration time provided is in the future
        guard expirationTime > Date.now else {
            // Throw an exception - Expiration time must be in the future
            throw TaskCreationError.InvalidExpiration
        }
        
        // Fill out the task's non-calculated values
        self.name = name
        self.details = details
        self.points = ip
        self.creationTime = Date.now
        self.expirationTime = expirationTime
    }
    
    // 5-arg constructor which allows the number of hours the task will be active to be provided.
    /// Initialize a `Task` with the number of hours until expiration provided.
    ///
    /// - Parameters:
    ///   - name: The name of the `Task`.
    ///   - details: An explanation of the `Task`. This can include notes, instructions, or anything else the user wants to record about the task.
    ///   - inspirationPoints: The numbers of `Inspiration Points` that completing the `Task` will reward.
    ///   - hoursToExpiration: The hours until the `Task` expires and cannot be completed.
    init(name: String, details: String, inspirationPoints ip: Int, hoursToExpiration expiresIn: Double) throws {
        // Ensure that proper values are being used to create this task
        try Task.ValidateTask(inspirationPoints: ip, hoursToExpiration: expiresIn)
        
        // Fill out the task's non-calculated values
        self.name = name
        self.details = details
        self.points = ip
        self.creationTime = Date.now
        
        // Calculate the expiration time using the creationTime and number of allowed hours (3600 seconds in an hour)
        self.expirationTime = creationTime.addingTimeInterval(TimeInterval(expiresIn * 3600))
    }
    
    /// Initialize a `Task` using a `TaskFramework` structures created from decoding a JSON file.
    init(using framework: TaskFramework) throws {
        // Ensure that proper values are being used to create this task
        try Task.ValidateTask(validating: framework)
        
        // Fill out the task's non-calculated values
        self.name = framework.name
        self.details = framework.details
        self.points = framework.inspirationPoints
        self.creationTime = Date.now
        
        // Calculate the expiration time using the creationTime and number of allowed hours (3600 seconds in an hour)
        self.expirationTime = creationTime.addingTimeInterval(TimeInterval(framework.hoursToExpire * 3600))
    }
    
    /// Check the values that are being used to create a `Task` to prevent using bad data.
    ///
    /// Uses a `TaskFramework` that probably contains data taken directly from a JSON file. As a result, bad data is unlikely, but not impossible. This should still be called regardless.
    ///
    /// - Parameters:
    ///   - framework: The `TaskFramework` instance that is being validated.
    private static func ValidateTask(validating framework: TaskFramework) throws {
        try Task.ValidateTask(inspirationPoints: framework.inspirationPoints, hoursToExpiration: framework.hoursToExpire)
    }
    
    // Default values are set to succeed so users don't have to input every variable each time
    /// Check the values that are being used to create a `Task` to prevent using bad data.
    ///
    /// - Parameters:
    ///   - name: The desired name of the `Task`. At present, is not used in any error checking.
    ///   - details: The desired details of the `Task`. At present, is not used in any error checking.
    ///   - ip: The number of points that the `Task` will reward if completed before it expires.
    ///   - expiresIn: The number of hours until the `Task` expires after creation, and can no longer be completed for `Inspiration Points`.
    private static func ValidateTask(name: String = "", details: String = "", inspirationPoints ip: Int = 1, hoursToExpiration expiresIn: Double = 1) throws(TaskCreationError) {
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
    
    /// `@MainActor` static function that returns an array of all of the `Task`s stored on the local JSON file.
    @MainActor
    static func GetAllPresetTasks() -> [TaskFramework] {
        do {
            // Get the url for the PresetTasks file, or throw a NotFound error if it does not exist.
            guard let taskUrl = Bundle.main.url(forResource: "PresetTasks", withExtension: "json") else {
                print("Task file was not found.")
                
                throw TaskCreationError.FileNotFound
            }
            
            // Get the data from within the tasks JSON file
            let taskData: Data = try Data(contentsOf: taskUrl)
            
            // Decode the data and store it within an immutable array
            let taskJSON: [String: [TaskFramework]] = try JSONDecoder().decode([String: [TaskFramework]].self, from: taskData)
            guard let tasks: [TaskFramework] = taskJSON["tasks"] else {
                print("Failed to extract Task array from String:[TaskFramework] dictionary")
                
                throw TaskCreationError.DecodeError
            }
            
            return tasks
            
        } catch {
            print("Error encountered: \(error.localizedDescription)")
            
            return []
        }
    }
}

/// Represents a `Task` that has not yet been created.
///
/// Used when decoding premade tasks from JSON files.
struct TaskFramework : Decodable, Identifiable {
    // TODO: When the task system is reworked to use difficulties instead of straight points and hours, you'll have to adjust the PresetTasks.json and the decoding inside this function. Don't forget about it
    
    /// Generate a unique ID of the `TaskFramework` instance.
    ///
    /// This will not be maintained if a `Task` is created using the `TaskFramework`.
    let id: UUID = UUID()
    /// The task's descriptive name.
    let name: String
    /// A brief description of the task's expectation.
    let details: String
    /// The number of points that the `Task` will reward when completed.
    let inspirationPoints: Int
    /// The hours that the `Task` is active for.
    let hoursToExpire: Double
    
    /// Custom CodingKeys to match property names during [en/de]coding
    private enum CodingKeys: String, CodingKey {
        case name
        case details
        case inspirationPoints
        case hoursToExpire
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try container.decode(String.self, forKey: .name)
        self.details = try container.decode(String.self, forKey: .details)
        self.inspirationPoints = try container.decode(Int.self, forKey: .inspirationPoints)
        self.hoursToExpire = try container.decode(Double.self, forKey: .hoursToExpire)
    }
}

