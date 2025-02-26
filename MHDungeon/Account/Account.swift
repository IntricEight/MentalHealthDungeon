//
//  Account.swift
//  MHDungeon
//

import Foundation

class Account: Identifiable, Codable {
    // TODO: Look into creating a singleton on Swift. That might be a good way to manage this, unless I wanna just use some universl variables that track login status
    // If not a singleton, then a static class might be the preferred method - Research @GlobalActor
    // Using Firebase to store the accounts and manage login process?
    // Another idea is to use the @EnvironmentObject and set the account as an environmental variable?
    
    
    
    // The current content within Account is in place from an authentication tutorial. Refactor to meet this app's requirements after auth is confirmed to work effectively
    let id: String
    let displayName: String
    let email: String
    
    // TODO: Implement the task list array and confirm that tasks also save in Firebase
    var taskList: [Task] = []
    
    init(id: String, displayName name: String, email: String) {
        self.id = id
        self.displayName = name
        self.email = email
        
        taskList = createSampleTasks()

    }
    
    // Function to create a list to test the visuals on.
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

}
