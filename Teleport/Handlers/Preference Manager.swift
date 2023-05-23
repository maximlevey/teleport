//  Copyright (c) 2023 Maxim Levey
//
//  Teleport is licensed under the MIT license.
//  You may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  https://github.com/maximlevey/Teleport/blob/main/LICENSE

// MARK: - Imports

import Foundation

// MARK: - Preference Manager

class PreferenceManager: ObservableObject {
  // Singleton instance of the preference manager.
  static let shared = PreferenceManager()
  // MARK: - User Preferences
  // Preference to control Teleport process.
  // If 'teleportPaused' is true, the Teleport process is paused.
  @Published var teleportPaused = false
  // Preference indicating if notifications permission have been requested from the user.
  @Published var notificationsRequested: Bool = UserDefaults.standard.bool(forKey: "notificationsRequested") {
    didSet {
      // Update the stored value in UserDefaults when the property changes.
      UserDefaults.standard.set(notificationsRequested, forKey: "notificationsRequested")
    }
  }
  // Preference indicating if notifications are disabled by the user in the app.
  @Published var notificationsDisabled: Bool = UserDefaults.standard.bool(forKey: "notificationsDisabled") {
    didSet {
      // Update the stored value in UserDefaults when the property changes.
      UserDefaults.standard.set(notificationsDisabled, forKey: "notificationsDisabled")
    }
  }
  // Preference indicating if authentication code should be hidden in the notifications.
  @Published var hideAuthCode: Bool = UserDefaults.standard.bool(forKey: "hideAuthCode") {
    didSet {
      // Update the stored value in UserDefaults when the property changes.
      UserDefaults.standard.set(hideAuthCode, forKey: "hideAuthCode")
    }
  }
  // Preference indicating if sender ID should be hidden in the notifications.
  @Published var hideSenderID: Bool = UserDefaults.standard.bool(forKey: "hideSenderID") {
    didSet {
      // Update the stored value in UserDefaults when the property changes.
      UserDefaults.standard.set(hideSenderID, forKey: "hideSenderID")
    }
  }
}
