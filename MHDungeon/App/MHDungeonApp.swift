//
//  MHDungeonApp.swift
//  MHDungeon
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        //Connect Firebase authentication to a local emulator for testing
        Auth.auth().useEmulator(withHost: "localhost", port: 9099)
        
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
    
    @StateObject var authModel = AuthModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()   //The host page of the app navigation
                .environmentObject(authModel)
        }
    }
}
