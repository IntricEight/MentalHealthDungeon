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
        
        //Uncomment the following line if you'd like to use the emulator for database testing
        //Connect Firebase authentication to a local emulator for testing
//        Auth.auth().useEmulator(withHost: "localhost", port: 9099)
        
        return true
    }
}


@main
struct MHDungeonApp: App {
    // TODO: Run functions on app startup like timer checking before displaying any views.
    /// Such functions may include:
    /// - Checking the timers on all premade Task options and renabling them if enough time has passed
    /// - Removing tasks whose timers have expired
    
    // Register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var authModel = AuthModel()
    @State private var appState: AppState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()   //The host page of the app navigation
                .environmentObject(authModel)
                .environment(appState)
            
            // TODO: Make the primary page navigation enum into an environment variable
        }
    }
}
