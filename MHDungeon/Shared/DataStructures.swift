//
//  DataStructures.swift
//  MHDungeon
//

import Foundation

// This file contains several data structures that, for one reason or another, don't seem to exist within Apple's Swift language. This file contains my home-made solutions for this absence.

// Right now, I'm too crunched for time to be able to work on this for now. The likelihood of something going wrong and taksing up too much time is too high. For now, though, I wanted to leave this file in place so that I have a reminder to wrok on it over the Summer, assuming I stick with this project.

// TODO: Implement the Pair into the project. It should be Codable.
    // Examples of places where this should go: In Account, combine the dungeon's stage tracker with the dungeon's Date completion timer into a single Pair<Int, Date>? object
struct Pair<Key: Codable, Value: Codable>: Codable {
    var key: Key
    var value: Value

    // This struct was brought in from ChatGPT, who also threw in the rest of the code below. I don't think the rest of the code is actually necessary, but I'm going to leave this in until I actually try using this in my program.
    
//    enum CodingKeys: String, CodingKey {
//        case key
//        case value
//    }
//
//    init(key: Key, value: Value) {
//        self.key = key
//        self.value = value
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        key = try container.decode(Key.self, forKey: .key)
//        value = try container.decode(Value.self, forKey: .value)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(key, forKey: .key)
//        try container.encode(value, forKey: .value)
//    }
}
