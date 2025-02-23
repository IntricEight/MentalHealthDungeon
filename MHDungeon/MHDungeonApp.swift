//
//  MHDungeonApp.swift
//  MHDungeon
//
//  Created by Collin Bowdoin on 1/29/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct MHDungeonApp: App {
    // TODO: Run functions on app startup like timer checking before displaying any views.
    /// Such functions may include:
    /// - Checking the timers on all premade Task options and renabling them if enough time has passed
    
    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()   //The host page of the app navigation
        }
    }
}
