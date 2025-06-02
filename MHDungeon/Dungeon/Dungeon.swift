//
//  Dungeon.swift
//  MHDungeon
//

import Foundation

/// Errors that can occur while using the `Dungeon` feature.
enum DungeonError: Error, LocalizedError {
    /// Thrown when a search is made for a `Dungeon` that does not exist.
    case NotFound
    /// Thrown when an error is encountered during the decoding process.
    case DecodeError
    /// Thrown when there is an attempt to start an adventure when another one is already in progress
    case AlreadyActive
    /// Thrown when the user tries to start a `Dungeon` that they cannot afford to enter.
    case NotEnoughIP
    
    /// The useful description of each error used by `LocalizedError`.
    var errorDescription: String? {
        switch self {
            case .NotFound:
                return "No dungeon was found with that name."
            case .DecodeError:
                return "Failed to properly decode the dungeon's JSON file."
            case .AlreadyActive:
                return "Cannot begin another adventure when one is already active."
            case .NotEnoughIP:
                return "User does not own enough IP to begin this dungeon."
        }
    }
}

/// Represents a Dungeon that the user can adventure through.
///
/// Contains a name, details, lists of images and rewards, and the cost and time to complete connected to the Dungeon.
struct Dungeon: Decodable, Identifiable {
    /// Store a registered ID of the `Dungeon` instance.
    let id: Int
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
    
    /// Initialize by using the dungeon's name.
    ///
    /// Only decodes the desired `Dungeon` instance, which cuts down on resource cost.
    ///
    /// - Parameters:
    ///   - name: The `String`  name of the chosen `Dungeon`.
    init(name: String) throws {
        // Get the url for the Dungeons file, or throw a NotFound error if it does not exist.
        guard let dungeonUrl = Bundle.main.url(forResource: "Dungeons", withExtension: "json") else {
            print("Dungeon file was not found.")
            
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
        self = try JSONDecoder().decode(Dungeon.self, from: matchJSON)
    }
 
    /// `@MainActor` static function that returns an array of all of the `Dungeons` stored on the local JSON file.
    ///
    /// The array of dungeons has been sorted by the ID of each dungeon, from least to greatest.
    @MainActor
    static func GetAllDungeons() throws -> [Dungeon] {
        print("Attempting to get all dungeons.")
        
        // Get the url for the Dungeons file, or throw a NotFound error if it does not exist.
        guard let dungeonUrl = Bundle.main.url(forResource: "Dungeons", withExtension: "json") else {
            print("Dungeon file was not found.")
            
            throw DungeonError.NotFound
        }
        
        // Get the data from within the dungeons JSON file
        let dungeonData: Data = try Data(contentsOf: dungeonUrl)
        
        // Decode the data and store it within an immutable array
        let dungeonJSON: [String: [Dungeon]] = try JSONDecoder().decode([String: [Dungeon]].self, from: dungeonData)
        guard var dungeons: [Dungeon] = dungeonJSON["dungeons"] else {
            print("Failed to extract Dungeon array from String:[Dungeon] dictionary")
            
            throw DungeonError.DecodeError
        }
        
        // Sort the dungeon array using their IDs in ascending order
        dungeons = dungeons.sorted { $0.id < $1.id }
        
        // TODO: Remove after testing
        dungeons.forEach { dungeon in
            print("\(dungeon.name) - \(dungeon.cost)")
        }
        
        return dungeons
    }
    
    /// `@MainActor` static function that begins an adventure within a `Dungeon`.
    ///
    /// - Parameters:
    ///   - dungeonID: The ID of the `Dungeon` where the adventure is starting.
    ///   - auth: The `AuthModel` that manages access to the `Firebase` records.
    @MainActor
    static func BeginDungeon(dungeonName name: String, authAccess auth: AuthModel) {
        do {
            // Begin the adventure through the auth model
            try auth.BeginAdventure(dungeonName: name)
        } catch {
            print("Failed to begin dungeon \"\(name)\": \(error.localizedDescription)")
        }
    }
    
    /// `@MainActor` static function that completes an adventure within a `Dungeon`.
    @MainActor
    static func CompleteDungeon(dungeonName name: String, authAccess auth: AuthModel) {
        // Complete the adventure through the auth model
        auth.CompleteAdventure(dungeonName: name)
    }
    
}
