//
//  AppDelegate.swift
//  Teleport Beta
//
//  Created by Maxim Levey
//

// MARK: - Imports

import Cocoa
import SQLite
import SwiftUI
import UserNotifications
import ServiceManagement

// MARK: - Enums

enum ActiveView {
    case welcome
    case content
    case access
    case startup
    case none
}

// MARK: - MyWindow Class

// Custom NSWindow class 'MyWindow' overrides performClose function
class MyWindow: NSWindow {
    // Called when the window is closed to hide application icon in dock, tab menu, etc.
    override func performClose(_: Any?) {
        NSApp.setActivationPolicy(.accessory)
        print("Application window closed")
    }
}

// MARK: - AppDelegate Class

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate, ObservableObject, UNUserNotificationCenterDelegate {
    // MARK: - Properties
    
    // Represents the currently active view.
    var activeView: ActiveView = .none
    
    // Represents the application's main window.
    var window: NSWindow!
    
    // The timestamp of the last processed message.
    var lastProcessedMessageDate = Int64(Date().timeIntervalSince1970 * 1000)
    
    // The last copied number from the messages.
    var lastCopiedNumber: String?
    
    // Timer to periodically check for new messages.
    var messageCheckTimer: DispatchSourceTimer?
    
    // This initializer sets up the necessary configurations.
    override init() {
        super.init()
        requestNotificationPermissions()
        // Adding an observer for the application's active status.
        NotificationCenter.default.addObserver(forName: NSApplication.willBecomeActiveNotification, object: nil, queue: .main) { _ in
            NSApp.setActivationPolicy(.regular)
            self.activeView = .none
            self.updateWindow()
        }
    }
    
    // MARK: - Application Lifecycle
    
    // Called when the application is about to finish its launch process.
    func applicationWillFinishLaunching(_: Notification) {
        activeView = .startup
        print("Teleport is starting...")
        
        // Write to defaults to ensure plist created
        // Enya is my girlfriend, I <3 her
        //let defaults = UserDefaults.standard
        // if defaults.object(forKey: "I <3") == nil {
            //defaults.set("Enya", forKey: "I <3")
            //defaults.synchronize()
        //}
        //let myValue = defaults.string(forKey: "I <3")
        //print("Writing to defaults. Key: I <3 String: \(myValue ?? "nil")")
        
        // Set main menu
        let mainMenu = NSMenu()
        
        // Create Teleport Menu
        let teleportMenu = NSMenu(title: "Teleport")
        // Populate the menu with items.
        teleportMenu.addItem(NSMenuItem(title: "About Teleport", action: #selector(aboutTeleport), keyEquivalent: ""))
        teleportMenu.addItem(NSMenuItem(title: "View on Github", action: #selector(viewGithub), keyEquivalent: ""))
        teleportMenu.addItem(NSMenuItem.separator())
        teleportMenu.addItem(NSMenuItem(title: "Notifications", action: #selector(openNotifications), keyEquivalent: ""))
        teleportMenu.addItem(NSMenuItem(title: "Full Disk Access", action: #selector(openDiskAccess), keyEquivalent: ""))
        teleportMenu.addItem(NSMenuItem.separator())
        teleportMenu.addItem(NSMenuItem(title: "Close Window", action: #selector(NSWindow.performClose(_:)), keyEquivalent: "w"))
        teleportMenu.addItem(NSMenuItem(title: "Quit Teleport", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        let teleportMenuItem = NSMenuItem(title: "Teleport", action: nil, keyEquivalent: "")
        teleportMenuItem.submenu = teleportMenu
        mainMenu.addItem(teleportMenuItem)
        
        // Create Debug Menu
        let debugMenu = NSMenu(title: "Debug")
        // Populate the Debug menu with items.
        debugMenu.addItem(NSMenuItem(title: "Reset Teleport", action: #selector(resetUserDefaults), keyEquivalent: ""))
        debugMenu.addItem(NSMenuItem.separator())
        debugMenu.addItem(NSMenuItem(title: "Launch startupView", action: #selector(launchStartupView), keyEquivalent: ""))
        debugMenu.addItem(NSMenuItem(title: "Launch welcomeView", action: #selector(launchWelcomeView), keyEquivalent: ""))
        debugMenu.addItem(NSMenuItem(title: "Launch accessView", action: #selector(launchAccessView), keyEquivalent: ""))
        debugMenu.addItem(NSMenuItem(title: "Launch aboutView", action: #selector(launchAboutView), keyEquivalent: ""))

        let debugMenuItem = NSMenuItem(title: "Debug", action: nil, keyEquivalent: "")
        debugMenuItem.submenu = debugMenu
        mainMenu.addItem(debugMenuItem)
        
        NSApp.mainMenu = mainMenu
    }
    
    // Called after the application has finished its launch process.
    func applicationDidFinishLaunching(_: Notification) {
        if UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            activeView = .startup
            requestFullDiskAccessReturning {
                self.lastProcessedMessageDate = self.getLastMessageDate()
                self.setupMessageCheckTimer()
            }
        } else {
            // First launch, show WelcomeView
            print("This is your first time using Teleport!\n")
            activeView = .welcome
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            requestFullDiskAccessReturning {
                self.lastProcessedMessageDate = self.getLastMessageDate()
                self.setupMessageCheckTimer()
            }
        }
        updateWindow()
    }
    
    // Quits the application.
    func quitApp() {
        NSApplication.shared.terminate(nil)
    }
    
    // Called when the application is about to terminate.
    func applicationWillTerminate(_: Notification) {
        messageCheckTimer?.cancel()
    }
    
    // MARK: - Menu Items
    
    // Handles the 'About Teleport' menu item click event.
    @objc func aboutTeleport() {
        // Always show the ContentView when About Teleport is clicked
        activeView = .content
        updateWindow()
    }
    
    // Handles the 'View on Github' menu item click event.
    @objc func viewGithub() {
        if let url = URL(string: "https://github.com/maximlevey/Teleport") {
            NSWorkspace.shared.open(url)
        } else {
            print("Failed to open the Github page.")
        }
    }
    
    // Handles the 'Open Notifications' menu item click event.
    @objc func openNotifications() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.notifications") {
            NSWorkspace.shared.open(url)
        } else {
            print("Failed to open Notifications settings.")
        }
    }
    
    // Handles the 'Open Disk Access' menu item click event.
    @objc func openDiskAccess() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles") {
            NSWorkspace.shared.open(url)
        } else {
            print("Failed to open Full Disk Access settings.")
        }
    }
    
    // Handles the 'Reset Defaults and Restart' menu item click event.
    @objc func resetUserDefaults() {
        let domainName = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domainName)
        print("Resetting UserDefaults")
        print("Teleport will restart")
        // Terminate the current application
        NSApplication.shared.terminate(self)
        // Delay by 1 second to ensure that the app has time to close
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Path for the new instance of the app
            let path = Bundle.main.bundlePath
            // Launch the new instance
            _ = try? Process.run(URL(fileURLWithPath: path), arguments: [], terminationHandler: nil)
        }
    }
    
    // Handles the 'Launch startupView' menu item click event.
    @objc func launchStartupView() {
        // Always show the ContentView when About Teleport is clicked
        activeView = .startup
        updateWindow()
    }
    
    // Handles the 'Launch welcomeView' menu item click event.
    @objc func launchWelcomeView() {
        // Always show the ContentView when About Teleport is clicked
        activeView = .welcome
        updateWindow()
    }
    
    // Handles the 'Launch accessView' menu item click event.
    @objc func launchAccessView() {
        // Always show the ContentView when About Teleport is clicked
        activeView = .access
        updateWindow()
    }
    
    // Handles the 'Launch aboutView' menu item click event.
    @objc func launchAboutView() {
        // Always show the ContentView when About Teleport is clicked
        activeView = .content
        updateWindow()
    }
    
    
    // MARK: - Window Management
    
    // Updates the window based on the currently active view.
    func updateWindow() {
        var windowSize: CGSize
        var contentView: AnyView
        
        switch activeView {
        case .welcome:
            windowSize = CGSize(width: 300, height: 500)
            contentView = AnyView(WelcomeView().environmentObject(self))
        case .content:
            windowSize = CGSize(width: 300, height: 500)
            contentView = AnyView(ContentView().environmentObject(self))
        case .access:
            windowSize = CGSize(width: 300, height: 500)
            contentView = AnyView(AccessView().environmentObject(self))
        case .startup:
            windowSize = CGSize(width: 300, height: 300)
            contentView = AnyView(StartupView().environmentObject(self))
        case .none:
            return
        }
        // Close any existing window
        window?.close()
        
        window = MyWindow(
            contentRect: NSRect(x: 0, y: 0, width: windowSize.width, height: windowSize.height),
            styleMask: [.titled, .closable],
            backing: .buffered, defer: false
        )
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.styleMask.insert(.fullSizeContentView)
        window.isReleasedWhenClosed = false
        window.orderFrontRegardless()
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        
        // Set the window's origin to the desired coordinates
        window.center()
        
        // Make the window not movable
        window.isMovable = false
        
        window.delegate = self
        
        window.contentView = NSHostingView(rootView: contentView)
    }
    
    //  Window Delegate
    // Called when the window is about to close.
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        sender.performClose(nil)
        return true
    }
    
    // MARK: - Permissions
    
    // Requests full disk access for the first launch of the application.
    // If access is already granted, the provided completion handler is invoked.
    func requestFullDiskAccessFirstLaunch(completion: @escaping () -> Void) {
        let fileManager = FileManager.default
        let dbPath = NSString(string: "~/Library/Messages/chat.db").expandingTildeInPath
        
        // Check if Teleport has full disk access permissions
        if !fileManager.isReadableFile(atPath: dbPath) {
        } else {
            // Full Disk Access already granted, continue app execution
            completion()
        }
    }
    
    // Requests full disk access for the application if previously launched.
    // If access is already granted, the provided completion handler is invoked.
    func requestFullDiskAccessReturning(completion: @escaping () -> Void) {
        let fileManager = FileManager.default
        let dbPath = NSString(string: "~/Library/Messages/chat.db").expandingTildeInPath
        
        // Check if Teleport has full disk access permissions
        if !fileManager.isReadableFile(atPath: dbPath) {
            // Show AccessView
            DispatchQueue.main.async {
                self.activeView = .access
                self.updateWindow()
            }
        } else {
            // Full Disk Access already granted, continue app execution
            completion()
        }
    }
    
    // MARK: - Notifications
    
    // Requests permission for notifications. Only requests permission if it hasn't been requested before.
    private func requestNotificationPermissions() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        // Check if we have already requested permissions
        if !UserDefaults.standard.bool(forKey: "permissionsRequested") {
            center.requestAuthorization(options: [.alert, .sound]) { _, error in
                if let error = error {
                    print("Error requesting notification authorization: \(error.localizedDescription)")
                } else {
                    // Save the flag to UserDefaults
                    UserDefaults.standard.set(true, forKey: "permissionsRequested")
                }
            }
        }
    }
    
    // Defines how to present a notification when the app is in the foreground.
    func userNotificationCenter(_: UNUserNotificationCenter, willPresent _: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    // Creates and schedules a notification with the given title and body.
    private func showNotification(title: String, body: String) {
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.categoryIdentifier = "teleportAuthCodeCategory"
        
        // Create notification trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        // Create notification request
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // Add notification request to notification center
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Message Processing
    
    // Retrieve the date of the latest message from the Messages database.
    func getLastMessageDate() -> Int64 {
        // Define the path to the Messages database
        let dbPath = NSString(string: "~/Library/Messages/chat.db").expandingTildeInPath
        
        // Try connecting to the Messages database
        guard let conn = try? Connection(dbPath, readonly: true) else {
            print("Unable to connect to chat.db") // Log error if connection fails
            return 0 // Return 0 if unable to connect to the database
        }
        
        // Define the 'message' table and 'date' column
        let messages = Table("message")
        let dateColumn = Expression<Int64>("date")
        
        // Build a query to select the date of the latest message in the database
        let query = messages.select(dateColumn).order(dateColumn.desc).limit(1)
        
        // Try executing the query and retrieving the latest message date
        if let latestMessage = try? conn.pluck(query) {
            return latestMessage[dateColumn] // Return the date of the latest message in the database
        }
        
        return 0 // Return 0 if there are no messages in the database
    }
    
    // Set up a timer to periodically check for new messages.
    func setupMessageCheckTimer() {
        print("Starting Teleport messageHandler...") // Log the start of timer setup
        
        // Create a dispatch queue to run the timer on
        let queue = DispatchQueue(label: "com.example.Teleport.messageCheckTimer")
        
        // Create a timer source and schedule it to run every 500 milliseconds with a leeway of 100 milliseconds
        messageCheckTimer = DispatchSource.makeTimerSource(queue: queue)
        messageCheckTimer?.schedule(
            deadline: .now(), repeating: .milliseconds(500), leeway: .milliseconds(100)
        )
        
        // Set the event handler for the timer to call the `processNewMessage()` method
        messageCheckTimer?.setEventHandler {
            self.processNewMessage()
        }
        
        // Set the cancel handler for the timer to log a message indicating that the timer was canceled
        messageCheckTimer?.setCancelHandler {
            print("Teleport messageHandler cancelled")
        }
        
        // Start the timer
        messageCheckTimer?.resume()
        print("Teleport messageHandler started.\n") // Log that the timer has started
        print("Teleport startup complete!\n") // Log that the Teleport startup process is complete
    }
    
    // Processes new messages by retrieving them from the Messages database, extracting the authentication code, and copying it to the clipboard.
    func processNewMessage() {
        // Define the path to the Messages database
        let dbPath = NSString(string: "~/Library/Messages/chat.db").expandingTildeInPath
        
        // Try connecting to the Messages database
        if let conn = try? Connection(dbPath, readonly: true) {
            do {
                // Define the tables and columns for the query
                let messages = Table("message")
                let handles = Table("handle")
                
                let textColumn = Expression<String?>("text")
                let dateColumn = Expression<Int64>("date")
                let isFromMeColumn = Expression<Int>("is_from_me")
                
                let handleIdColumn = Expression<Int>("handle_id")
                let rowIdColumn = Expression<Int>("ROWID")
                let idColumn = Expression<String?>("id")
                
                // Construct a query to fetch messages received since the last processed message
                let query = messages.join(.leftOuter, handles, on: handleIdColumn == handles[rowIdColumn])
                    .select(textColumn, dateColumn, isFromMeColumn, handles[idColumn])
                    .filter(dateColumn > lastProcessedMessageDate)
                    .filter(isFromMeColumn == 0)
                    .order(dateColumn.desc)
                
                // Prepare and execute the query to retrieve new messages
                let newMessages = try conn.prepare(query)
                
                for message in newMessages {
                    let text = message[textColumn]
                    let senderId = message[handles[idColumn]] ?? "Unknown Sender"
                    
                    // Attempt to extract the authentication code from the latest message
                    if let match = text.flatMap({ self.extractNumber($0) }) {
                        // If it's a new code, copy the authentication code to the clipboard
                        if lastCopiedNumber != match {
                            // Display a notification indicating that a new code was copied to the clipboard
                            DispatchQueue.main.async {
                                self.showNotification(
                                    title: "\(senderId) via Teleport", body: "Authentication Code \(match) copied to clipboard"
                                )
                            }
                            
                            // Copy the number to the clipboard
                            NSPasteboard.general.declareTypes([.string], owner: nil)
                            NSPasteboard.general.setString(match, forType: .string)
                            
                            // Log success or failure of the copy operation
                            if NSPasteboard.general.string(forType: .string) != nil {
                                print("New Message Received...")
                                print("Authentication Code \(match) copied to clipboard\n")
                            } else {
                                print("Failed to copy Authentication Code to clipboard\n")
                            }
                            
                            lastCopiedNumber = match
                        }
                    } else {
                        // Log that a new message was received but did not contain an authentication code
                        print("New Message Received...")
                        print("No Authentication Code found in message\n")
                    }
                    
                    // Update the date of the last processed message
                    lastProcessedMessageDate = message[dateColumn]
                }
            } catch {
                print("Error: \(error)") // Log any errors encountered during processing
            }
        } else {
            print("Teleport unable to connect to chat.db") // Log a failure to connect to the database
        }
    }
    
    // Extract a number consisting of 4 to 9 digits from a string.
    func extractNumber(_ text: String) -> String? {
        // Define the regular expression for matching numbers that consist of 4 to 9 digits
        let regex = try! NSRegularExpression(pattern: "\\b\\d{4,9}\\b")
        
        // Define the range of the string for the search
        let range = NSRange(location: 0, length: text.utf16.count)
        
        // Use the regular expression to search for the first match in the string
        if let match = regex.firstMatch(in: text, options: [], range: range) {
            // If a match is found, extract the matched string and return it
            return (text as NSString).substring(with: match.range)
        }
        
        // If no match is found, return nil
        return nil
    }
    
    // MARK: - View Items
    
    // Opens the Full Disk Access settings.
    func openFullDiskAccessSettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles") {
            NSWorkspace.shared.open(url)
        } else {
            print("Failed to open Full Disk Access settings.")
        }
    }
    
    // Opens the Notification settings.
    func openNotificationSettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.notifications") {
            NSWorkspace.shared.open(url)
        } else {
            print("Failed to open Notifications settings.")
        }
    }
    
    // Opens the About view.
    func openAboutView() {
        DispatchQueue.main.async {
            self.activeView = .access
            self.updateWindow()
        }
    }
}

