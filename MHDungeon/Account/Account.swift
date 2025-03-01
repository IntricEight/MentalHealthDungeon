//
//  Account.swift
//  MHDungeon
//

import Foundation
import FirebaseFirestore

class Account: Identifiable, Codable, ObservableObject {
    let id: String
    @Published var displayName: String
    let email: String
    
    // Stores the user's tasks
    @Published var taskList: [Task] = []
    
    init(id: String, displayName name: String, email: String) {
        self.id = id
        self.displayName = name
        self.email = email
        
        taskList = createSampleTasks()
    }
    
    // TODO: Saved in case I figure out how to get Firestore to ignore certain attributes
//    var description: String {       // Allows me to control what gets printed to the Console
//        return "Account: \(displayName) : \(email). Contains \(taskList.count) tasks."
//    }
    
    
    
    
    
    // Function to create a list of tasks to test the visuals on.
    // TODO: REMOVE after getting proper task creation working
    func createSampleTasks () -> [Task] {
        var tasks: [Task] = []
        
        do {
            tasks = [
                try Task(name: "Morning Run", details: "Go for a 5K run to start the day strong.", inspirationPoints: 10, hoursToExpiration: 12),
                try Task(name: "Read a Book", details: "Read at least 20 pages of a book.", inspirationPoints: 5, hoursToExpiration: 24),
                try Task(name: "Practice Coding", details: "Spend an hour coding in Swift.", inspirationPoints: 15, hoursToExpiration: 8),
                try Task(name: "Meditation", details: "Meditate for 15 minutes to clear your mind.", inspirationPoints: 7, hoursToExpiration: 6),
                try Task(name: "Write a Journal", details: "Write about your day and reflections.", inspirationPoints: 8, hoursToExpiration: 10),
                try Task(name: "Complete a Workout", details: "Do a full-body workout at the gym.", inspirationPoints: 12, hoursToExpiration: 14),
                try Task(name: "Cook a Healthy Meal", details: "Prepare a nutritious homemade meal.", inspirationPoints: 9, hoursToExpiration: 12),
                try Task(name: "Drink Water", details: "Drink at least 8 glasses of water.", inspirationPoints: 4, hoursToExpiration: 24),
                try Task(name: "Declutter Your Desk", details: "Organize and clean your workspace.", inspirationPoints: 6, hoursToExpiration: 5),
                try Task(name: "Call a Friend", details: "Catch up with a friend or family member.", inspirationPoints: 7, hoursToExpiration: 16),
                try Task(name: "Complete a Side Project Task", details: "Make progress on a personal project.", inspirationPoints: 15, hoursToExpiration: 48),
                try Task(name: "Stretch", details: "Perform a 10-minute stretching routine.", inspirationPoints: 5, hoursToExpiration: 3),
                try Task(name: "Plan Your Day", details: "Write down a to-do list for tomorrow.", inspirationPoints: 6, hoursToExpiration: 12),
                try Task(name: "Help Someone", details: "Do a small act of kindness today.", inspirationPoints: 10, hoursToExpiration: 18),
                try Task(name: "Listen to a Podcast", details: "Learn something new from a podcast.", inspirationPoints: 8, hoursToExpiration: 20),
                try Task(name: "Take a Walk", details: "Go for a 20-minute walk outside.", inspirationPoints: 7, hoursToExpiration: 6),
                try Task(name: "Limit Screen Time", details: "Avoid screens for one hour before bed.", inspirationPoints: 9, hoursToExpiration: 24),
                try Task(name: "Sketch or Doodle", details: "Draw something creative for fun.", inspirationPoints: 6, hoursToExpiration: 8),
                try Task(name: "Try a New Hobby", details: "Spend time exploring a new interest.", inspirationPoints: 12, hoursToExpiration: 48),
                try Task(name: "Organize Digital Files", details: "Sort and clean up your computer files.", inspirationPoints: 10, hoursToExpiration: 24)
            ]
        } catch TaskCreationError.InvalidExpiration {
            print("Failed to create tasks")
        } catch {
            print("An unexpected error occured")
        }
        
        return tasks
    }
    
    
    
    // Custom CodingKeys to match property names during en/decoding
    enum CodingKeys: String, CodingKey {
        case id
        case displayName
        case email
        case taskList
    }
    
    // Custom encoding function to manage the @Published attributes
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: CodingKeys.id)
        try container.encode(displayName, forKey: CodingKeys.displayName)
        try container.encode(email, forKey: CodingKeys.email)
        try container.encode(taskList, forKey: CodingKeys.taskList)
    }

    // Custom decoding init to manage @Published attributes
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: CodingKeys.id)
        displayName = try container.decode(String.self, forKey: CodingKeys.displayName)
        email = try container.decode(String.self, forKey: CodingKeys.email)
        taskList = try container.decode([Task].self, forKey: CodingKeys.taskList)
    }
    
    
}
