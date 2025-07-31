import SwiftUI
import FirebaseCore
import GoogleSignIn

@main
struct ChickenOrTheEggApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
                .onAppear {
                    // Configure Google Sign-In when app appears
                    guard let clientID = getGoogleClientID() else {
                        print("Error: Google Client ID not found")
                        return
                    }
                    GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
                }
                .onAppear {
                    // Configure Google Sign-In when app appears
                    guard let clientID = getGoogleClientID() else {
                        print("Error: Google Client ID not found")
                        return
                    }
                    GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
                }
        }
    }
    
    private func getGoogleClientID() -> String? {
        guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let clientID = plist["CLIENT_ID"] as? String else {
            return nil
        }
        return clientID
    }
}
