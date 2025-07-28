//
//  DungeonAdventureView.swift
//  MHDungeon
//

import SwiftUI

struct DungeonAdventureView: View {
    // Contains the account which stores the timer of the current dungeon
    @EnvironmentObject var authModel: AuthModel
    @Environment(DungeonState.self) private var dungeonState: DungeonState
    
    /// A visual countdown of the time remaining before the `Task` expires.
    @State private var timeRemaining: String = "Completes in <LOADING>"
    
    // TODO: Decide if I should end up writing anything before the timer
    /// A template to base the `timeRemaining` display value off of.
    private let timeRemainingTemplate: String = ""
    /// Controls how frequently the visual countdown updates (In seconds).
    private let timeInterval: Double = 1
    /// Message to show that the countdown has elapsed
    private let completedMessage: String = "Dungeon complete!"
    
    // Get a timer to convert the remanining time into Days, Hours, Minutes, Seconds format
    private let dhmsTimer: DHMSTimer = DHMSTimer()
    
    var body: some View {
        /// The name of the current active `Dungeon`.
        let dungeonName: String = dungeonState.currentDungeon?.name ?? "Dungeon failed to load"
        /// The inspiration point cost of the current `Dungeon`.
        let dungeonCost = dungeonState.currentDungeon?.cost ?? 999
        /// The current number of `Inspiration Points` that the user has in their `Account`.
        let currentPoints = authModel.currentAccount?.inspirationPoints ?? -1
        
        // Main screen view
        VStack {
            // Account details section
            HStack {
                // Dungeon selection button
                Button {
                    print("Return to landing selected")
                    
                    // Navigate to the Dungeon Landing page
                    dungeonState.ChangeView(to: .landing)
                } label: {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 150, height: 50)
                        .foregroundColor(Color.blue)
                        .contentShape(Rectangle())
                        .overlay {
                            HStack {
                                Image(systemName: "arrowshape.turn.up.right.fill")
                                    .foregroundColor(.white)
                                    .rotationEffect(.degrees(180))
                                    .fontWeight(.heavy)
                                
                                Text("Back")
                                    .foregroundColor(.white)
                                    .fontWeight(.semibold)
                                    .font(.title)
                            }
                            .frame(alignment: .center)
                        }
                }.padding(EdgeInsets(top: 0, leading: 42, bottom: 0, trailing: 16))
                
                Spacer()
                
                // Profile image
                SmallProfileImage()
                    .frame(alignment: .trailing)
            }
            .padding(EdgeInsets(top: 64, leading: 0, bottom: 10, trailing: 16))
            
            
            // Perhaps add a title line for the level name + stage #?
            
            
            // Dungeon Unlock Progress section
            DungeonImage(stage: 1)
            
            
            // Begin the Adventure section
            Button {
                print("Attempting to begin \(dungeonName) - \(currentPoints)/\(dungeonCost) IP owned.")
                
                // Check if the dungeon has been completed, or can be started
                if !(authModel.currentAccount?.activeDungeonName.isEmpty ?? true) {
                    // Check if the current adventure has been finished
                    if timeRemaining == completedMessage {
                        print("Completing the current adventure in \(dungeonName).")
                        
                        // Complete the dungeon and reward the user
                        Dungeon.CompleteDungeon(dungeonName: dungeonName, authAccess: authModel)
                        
                        // Return the user to the landing page
                        dungeonState.ChangeView(to: .landing)
                    } else {
                        print("Cannot begin a new dungeon, one is already in progress.")
                    }
                    
                } else {
                    print("Beginning an adventure in \(dungeonName).")
                    
                    // Begin the dungeon's adventure timer
                    Dungeon.BeginDungeon(dungeonName: dungeonName, authAccess: authModel)
                }
                
            } label: {
                RoundedRectangle(cornerRadius: 20)
                    .frame(height: 70)
                    .foregroundColor(Color.green)
                    .overlay {
                        // If an adventure has begun, display the remaining time in a sporatic countdown. Otherwise, allow it to begin, and start displaying the remaining time
                        Text(timeRemaining)
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .font(.system(size: 28))    //Shrinking the text just a little to fit inside the button
                            .frame(alignment: .center)
                            .onAppear {
                                timeRemaining = authModel.currentAccount?.activeDungeonName.isEmpty ?? true ? "Begin the Adventure!" : timeRemaining
                            }
                    }
                    .contentShape(Rectangle())
                    .onAppear {
                        if !(authModel.currentAccount?.activeDungeonName.isEmpty ?? true) {
                            // Ensure that the time until completion is displayed upon loading
                            dhmsTimer.UpdateTimeRemaining(timeRemaining: &timeRemaining, expirationTime: authModel.currentAccount?.dungeonEndTime ?? Date.now, template: timeRemainingTemplate, message: completedMessage)
                        }
                    }
                    .onReceive(Timer.publish(every: timeInterval, on: .main, in: .common).autoconnect()) { _ in
                            // After timeInterval second(s) have passed, this takes over the remaining time display
                            if !(authModel.currentAccount?.activeDungeonName.isEmpty ?? true) {
                                dhmsTimer.UpdateTimeRemaining(timeRemaining: &timeRemaining, expirationTime: authModel.currentAccount?.dungeonEndTime ?? Date.now, template: timeRemainingTemplate, message: completedMessage)
                            }
                        }
            }.padding(EdgeInsets(top: 0, leading: 48, bottom: 0, trailing: 48))
            
            
            Spacer()
            
            // TODO: Make a list of rewards appear here?
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

#Preview {
    DungeonAdventureView()
}
