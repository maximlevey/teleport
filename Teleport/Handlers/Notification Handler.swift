//  Copyright (c) 2023 Maxim Levey
//
//  Teleport is licensed under the MIT license.
//  You may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  https://github.com/maximlevey/Teleport/blob/main/LICENSE

// MARK: - Imports

import Cocoa
import SwiftUI
import UserNotifications

// MARK: - Notification Handler

class NotificationHandler: NSObject, UNUserNotificationCenterDelegate {
  // Instance of PreferenceManager.
  @ObservedObject var preferenceManager = PreferenceManager.shared
  // MARK: - Standard Notification
  // Generate and send a local notification containing authCode and senderID
  func authCodeNotification(senderID: String, authCode: String) {
    // Check if user has opted out of notifications.
    if !notificationsDisabled {
      // Request notification permissions if they haven't been requested yet.
      checkNotifications()
      // Prepare the notification content.
      let content = UNMutableNotificationContent()
      // Configure the notification title based on user's preference to hide sender ID.
      content.title = PreferenceManager.shared.hideSenderID
      ? "Teleport"
      : "\(senderID) via Teleport"
      // Configure the notification body based on user's preference to hide the authentication code.
      content.body = PreferenceManager.shared.hideAuthCode
      ? "Authentication code copied to clipboard"
      : "Authentication code \(authCode) copied to clipboard"
      // Configure the notification category.
      content.categoryIdentifier = "teleportStandardNotification"
      // Create a time-based trigger for the notification to fire immediately.
      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
      // Create a request to schedule the notification.
      let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
      // Schedule the notification.
      UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
          print("Error scheduling notification: \(error)")
        }
      }
    }
  }
  // MARK: - Notification Delegate
  // Customise how notifications are presented while the app is running.
  func userNotificationCenter(
    _: UNUserNotificationCenter,
    willPresent _: UNNotification,
    withCompletionHandler completionHandler: @escaping
  (UNNotificationPresentationOptions) -> Void) {
    // Show a banner and play a sound for incoming notifications.
    completionHandler([.banner, .sound])
  }
  // MARK: - Permission Handling
  // Check if user has disabled notifications in preferences.
  private var notificationsDisabled: Bool {
    PreferenceManager.shared.notificationsDisabled
  }
  // Check if notification permissions have been requested from the user.
  private var notificationsRequested: Bool {
    PreferenceManager.shared.notificationsRequested
  }
  private func checkNotifications() {
    if !notificationsRequested {
      // Get the notification center instance and set this object as its delegate.
      let center = UNUserNotificationCenter.current()
      center.delegate = self
      // Request notification permissions from the user.
      center.requestAuthorization(options: [.alert, .sound]) { granted, error in
        DispatchQueue.main.async {
          if let error = error {
            // Log error if permission request fails.
            print("[ERROR] checkNotifications: \(error.localizedDescription)")
          } else if granted {
            // Record that notification permissions have been requested.
            self.preferenceManager.notificationsRequested = true
          }
        }
      }
    }
  }
}
