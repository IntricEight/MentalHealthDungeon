//
//  Reward.swift
//  MHDungeon
//

import Foundation

/// An identifier for the different types of rewards that can be found inside a `Dungeon`.
enum DungeonReward {
    /// The user's maximum `Inspiration Point` storage is increased.
    case IpMaxIncrease
    /// A default case to be used when the application doesn't know what type of reward this is.
    ///
    /// This shouldn't occur in natural runtime, and mostly exists to allow the use of switch cases and error catching.
    case Unknown
}

/// A reward that a user can earn from a `Dungeon`.
struct Reward: Decodable {
    let item: DungeonReward
    let value: String
    
    /// Custom CodingKeys to match property names during decoding.
    private enum CodingKeys: String, CodingKey {
        case item
        case value
    }
    
    /// Initialize an instance of a Reward using a decoder.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let itemName = try container.decode(String.self, forKey: .item)
        let value = try container.decode(String.self, forKey: .value)
        
        self.init(item: itemName, value: value)
    }
    
    /// Initialize an instance of a Reward using a pair of strings.
    init(item name: String, value: String) {
        switch name {
            case "ipMaxIncrease":
                item = .IpMaxIncrease
            default:
                item = .Unknown
        }
        
        self.value = value
    }
}
