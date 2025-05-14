//
//  Dungeon.swift
//  MHDungeon
//

import Foundation

/// Errors that can occur while using the `Dungeon` feature.
enum DungeonError: Error, LocalizedError {
    /// Thrown when a search is made for a `Dungeon` that does not exist.
    case NotFound
    
    /// The useful description of each error used by `LocalizedError`.
    var errorDescription: String? {
        switch self {
            case .NotFound:
                return "No dungeon was found with that name."
        }
    }
}

/// Represents a Dungeon that the user can adventure through.
///
/// Contains a name, details, lists of images and rewards, and the cost and time to complete connected to the Dungeon.
struct Dungeon: Decodable {
    /// The dungeon's name
    let name: String
    /// A brief description of the dungeon's appearance.
    let description: String
    /// A list of names or locations which contain the images that will be used with this dungeon.
    let imageNames: [String]
    /// A list of rewards that the dungeon can reward on a random (equal) chance.
    let rewards: [Reward]
    /// The cost (in `Inspiration Points`) to run this dungeon.
    let cost: Int
    /// The time (in hours) it takes to complete this dungeon.
    let hours: Double
    
//    /// Initialize a dungeon instance without any images attached.
//    init(name: String, description: String, cost: Int, hours: Double) {
//        self.name = name
//        self.description = description
//        self.imageNames = []
//        self.rewards = []
//        self.cost = cost
//        self.hours = hours
//    }
//    
//    /// Initialize a dungeon instance with a set of images to display.
//    init(name: String, description: String, images: [String] = [], rewards: [Reward<<#ItemType: Decodable#>>] = [], cost: Int, hours: Double) {
//        self.name = name
//        self.description = description
//        self.imageNames = images
//        self.rewards = rewards
//        self.cost = cost
//        self.hours = hours
//    }
    
    /// Initialize by using just the dungeon's name, and filling out the rest of the data using the
    init(name: String) throws {
//        let dungeons: [Dungeon] = []
        
        
        throw DungeonError.NotFound
    }
 
    
    // TODO: Make static list that returns a list of all Dungeons
}
