//  Copyright (c) 2023 Maxim Levey
//
//  Teleport is licensed under the MIT license.
//  You may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  https://github.com/maximlevey/Teleport/blob/main/LICENSE

// MARK: - Imports

import Cocoa

// MARK: - Process Manager

class ProcessManager: ObservableObject {
  // Singleton instance of the process manager
  static let shared = ProcessManager()
  // Handles interactions with Teleport app
  let messageHandler = MessageHandler()
  // Indicator of whether the Teleport app handler is currently active
  @Published var isRunning = true
  // MARK: - Process Handling
  // Start the Teleport process immediately upon creation of the ProcessManager instance
  init() {
    self.startMessageHandler()
    // Register for system wake notifications to appropriately manage the Teleport app state
    let notificationCenter = NSWorkspace.shared.notificationCenter
    let wakeSelector = #selector(systemWake(_:))
    let wakeNotification = NSWorkspace.didWakeNotification
    notificationCenter.addObserver(self, selector: wakeSelector, name: wakeNotification, object: nil)
    // Register for system sleep notifications to appropriately manage the Teleport app state (SLEEP)
    let sleepSelector = #selector(systemSleep(_:))
    let sleepNotification = NSWorkspace.willSleepNotification
    notificationCenter.addObserver(self, selector: sleepSelector, name: sleepNotification, object: nil)
  }
  // Ensures the Teleport process is stopped when the ProcessManager is deinitialized
  deinit {
    self.stopMessageHandler()
  }
  // Stops the Teleport process when system goes to sleep
  @objc func systemSleep(_ notification: Notification) {
    self.stopMessageHandler()
  }
  // Restarts the Teleport process when system wakes up, unless the process is paused by user
  @objc func systemWake(_ notification: Notification) {
    if !PreferenceManager.shared.teleportPaused {
      self.startMessageHandler()
    }
  }
  // Switches the Teleport app between running and stopped states
  func toggleMessageHandler() {
    if isRunning {
      stopMessageHandler()
    } else {
      startMessageHandler()
    }
  }
  // Initiates the Teleport app
  func startMessageHandler() {
    let fileManager = FileManager.default
    let dbPath = NSString(string: "~/Library/Messages/chat.db").expandingTildeInPath
    // Ensures the necessary permissions are granted for the Teleport app to function
    if !fileManager.isReadableFile(atPath: dbPath) {
      // If necessary permissions are not granted, halt the Teleport app
      isRunning = false
    } else {
      // If necessary permissions are granted, activate the Teleport app
      messageHandler.run()
      isRunning = true
    }
  }
  // Ceases the operation of the Teleport app
  func stopMessageHandler() {
    // Terminates the Teleport app process
    messageHandler.terminate(Notification(name: Notification.Name("stopMessageHandler")))
    isRunning = false
  }
}
