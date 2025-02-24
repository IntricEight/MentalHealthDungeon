//
//  TaskListView.swift
//  MHDungeon
//

// TODO: Implement an override button that reduces the timer of the first task to 5 seconds. This will be useful in demonstrating that ask feature to the audience

import SwiftUI

struct TaskListView: View {
    var currentView: Binding<AppPage>?      // Passed through here into the NavigationBar
    
    // Control visiblity of various features
    @State private var navBarVisible: Bool = false      //Control the visibility of the navigation bar
    
    // Dungeon button controls
    // TODO: Make some environmental file where this stuff can be stored
    let buttonRadius: CGFloat = 20
    
    // Tab controls
    let tabRadius: CGFloat = 30
    
    // TODO: Clean up. Test converting into a set once the initial list is working
    @State var tasks: [Task] = createSampleTasks()
        
    
    
    var body: some View {
        
        
        // Or a List, as it comes with a scroll. Perhaps you could even use both at the same time, future me
        // Use a .sheet (iExpense, look up Paul Hudson's tutorial) to display the Task details / Task Creation
        //  OR
        // Use a NavigationStack with NavigationLink
        
        // One layer for the main app stuff, and one for the overlay tab feature
        ZStack {
            // Main screen view
            VStack {
                // Account details section
                HStack {
                    // Task Creation Button
                    // TODO: When clicked, split into two buttons (New and Custom)
                    Button {
                        print("Task Creation selected")
                        
                        tasks.removeLast()
                    } label: {
                        RoundedRectangle(cornerRadius: buttonRadius)
                            .frame(height: 50)
                            .foregroundColor(Color.red)
                            .padding(EdgeInsets(top: 0, leading: 48, bottom: 0, trailing: 32))
                    }
                    
                    Spacer()
                    
                    // Profile image
                    // TODO: Implement profile picture display. Picture taken from selection on Profile view
                    Circle()
                        .frame(width: 60, height: 60, alignment: .trailing)
                        .foregroundColor(Color.yellow)

                }
                .padding(EdgeInsets(top: 64, leading: 0, bottom: 10, trailing: 16))
                
                
                Spacer()
                
                // TODO: Figure out why the white background won't go away, and make it go away
                // List of active tasks
                List(tasks) { task in
                    Button {
                        print(task)
                    } label: {
                        TaskListItem(task)
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
                
                
                
                // Navigation section
                HStack {
                    Spacer()
                    
                    // Navigation tab button
                    Button {
                        print("Navigation selected")
                        
                        // Bring up the Navigation Bar when touched
                        withAnimation(.easeInOut(duration: 0.5)) {
                            navBarVisible = true
                        }
                    } label: {
                        Rectangle()
                            .frame(width: screenWidth * 0.2, height: 40, alignment: .bottom)
                            .foregroundColor(Color.blue)
                            .clipShape(
                                .rect(
                                    topLeadingRadius: tabRadius,
                                    topTrailingRadius: tabRadius
                                )
                            )
                            .ignoresSafeArea()
                    }.padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 32))
                }
            }.zIndex(1)
            
            
            // Overlayed tab features
            VStack {
                
                Spacer()
                
                // Show or hide the navigation bar
                if navBarVisible {
                    NavigationBar(currentView: currentView, visible: $navBarVisible)
                        .transition(.move(edge: .bottom))
                        .frame(alignment: .bottom)
                }
            }.zIndex(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

#Preview("Task List") {
    TaskListView()
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
