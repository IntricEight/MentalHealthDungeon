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
    
    init(id: String, displayName name: String, email: String) {
        self.id = id
        self.displayName = name
        self.email = email
    }
}

extension Account {
    static var MOCK_USER = Account(id: NSUUID().uuidString, displayName: "Universaliscam", email: "fake@got.cha")
}
