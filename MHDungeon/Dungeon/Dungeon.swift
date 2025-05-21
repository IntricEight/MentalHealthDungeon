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
struct Dungeon: Decodable, Identifiable {
    /// Store a registered ID of the `Dungeon` instance.
    var id: Int
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
        // Get the url for the Dungeons file, or throw a NotFound error if it does not exist.
        guard let dungeonUrl = Bundle.main.url(forResource: "Dungeons", withExtension: "json") else {
            throw DungeonError.NotFound
        }
        
        // We want to avoid decoding the JSON until we've separated out the Dungeon whose name matches the given name. This way, we avoid creating more dungeons than we need by only decoding the one that we are looking for.
        
        // Get the data stored witin the dungeon's JSON file without decoding it.
        let dungeonData = try Data(contentsOf: dungeonUrl)
        let raw = try JSONSerialization.jsonObject(with: dungeonData, options: [])
        
        // Convert the raw data into an array of strings containing the Dungeons in the file.
        guard
          let top = raw as? [String: Any],
          let list = top["dungeons"] as? [[String: Any]]
        else {
            let context = DecodingError.Context(codingPath: [], debugDescription: "Invalid top-level ‘dungeons’ structure")
            throw DecodingError.dataCorrupted(context)
        }

        // Find the item in the data whose name matches the provided parameter, and store it separately
        guard let matchData = list.first(where: { $0["name"] as? String == name }) else {
            throw DungeonError.NotFound
        }

        // Convert the matched data back into a JSON format, to be used with a decoder.
        let matchJSON = try JSONSerialization.data(withJSONObject: matchData, options: [])
        
        // Decode the JSON that contains only the desired Dungeon.
        self = try! JSONDecoder().decode(Dungeon.self, from: matchJSON)
    }
 
    
    // TODO: Make static list that returns a list of all Dungeons
    ///
    @MainActor
    static func getAllDungeons() throws -> [Dungeon] {
        // Get the url for the Dungeons file, or throw a NotFound error if it does not exist.
        guard let dungeonUrl = Bundle.main.url(forResource: "Dungeons", withExtension: "JSON") else {
            throw DungeonError.NotFound
        }
        
        // Get the data from within the dungeons JSON file
        let dungeonData = try Data(contentsOf: dungeonUrl)
        
        // Decode the data and store it within an immutable array
        let dungeons: [Dungeon] = try JSONDecoder().decode([Dungeon].self, from: dungeonData)
        
        
        
        return dungeons
    }
}
