import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var library: LibraryModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile Settings")) {
                    TextField("Username", text: $library.userName)
                }
                
                Section(header: Text("App Preferences")) {
                    Toggle("Dark Mode", isOn: $library.preferences.isDarkModeEnabled)
                    Toggle("Enable Notifications", isOn: $library.preferences.notificationsEnabled)
                }
                
                Section(footer: Text("Changes will be applied throughout the app automatically using the reactive data flow.")) {
                    Button("Reset Preferences") {
                        library.preferences = UserPreferences()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings")
        }
    }
}
