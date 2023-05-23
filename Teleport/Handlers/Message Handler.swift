//  Copyright (c) 2023 Maxim Levey
//
//  Teleport is licensed under the MIT license.
//  You may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  https://github.com/maximlevey/Teleport/blob/main/LICENSE

// MARK: - Imports

import AppKit
import Cocoa
import Foundation
import SQLite

// MARK: - Message Handler

class MessageHandler {
  // Store timestamp of the most recently processed message.
  var lastProcessedMessageDate = Int64(Date().timeIntervalSince1970 * 1000)
  // Store the last copied number from the messages.
  var lastCopiedNumber: String?
  // Timer to periodically scan for new messages.
  var messageCheckTimer: DispatchSourceTimer?
  // Connection object to manage the database connection.
  var dbConnection: Connection?
  // Dedicated dispatch queue for performing database-related operations asynchronously.
  let dbQueue = DispatchQueue(label: "com.maximlevey.Teleport.dbQueue")
  // Path to chat.db, the Messages database.
  let dbPath = NSString(string: "~/Library/Messages/chat.db").expandingTildeInPath
  // Flag to indicate if the message handling process is currently running.
  @Published var isRunning = false
  // MARK: - Database Connection
  // Establish a persistent connection to the database for reuse.
  func connectToDatabase() {
    do {
      dbConnection = try Connection(dbPath, readonly: true)
    } catch {
      print("\n[ERROR] connectToDatabase: failed to connect to chat.db")
    }
  }
  // MARK: - Message Processing
  // Fetch the timestamp of the most recent message in the Messages database.
  func getLastMessageDate() -> Int64 {
    var latestMessageDate: Int64 = 0
    dbQueue.sync {
      // Check if the database connection is established.
      guard let conn = dbConnection else {
        print("\n[ERROR] getLastMessageDate: failed to connect to chat.db")
        return
      }
      // Define the query to fetch the latest message.
      let messages = Table("message")
      let dateColumn = Expression<Int64>("date")
      let query = messages.select(dateColumn).order(dateColumn.desc).limit(1)
      // Execute the query and update the latest message date.
      if let latestMessage = try? conn.pluck(query) {
        latestMessageDate = latestMessage[dateColumn]
      }
    }
    return latestMessageDate
  }
  // Set up a timer that triggers the new message handling process at regular intervals.
  func setupMessageCheckTimer() {
    messageCheckTimer = DispatchSource.makeTimerSource(queue: dbQueue)
    messageCheckTimer?.schedule(
      deadline: .now(), repeating: .milliseconds(500), leeway: .milliseconds(100))
    messageCheckTimer?.setEventHandler { [weak self] in
      // Ensure the database file is readable before attempting to process new messages.
      if FileManager.default.isReadableFile(atPath: self?.dbPath ?? "") {
        self?.processNewMessage()
      }
    }
    messageCheckTimer?.resume()  // Start the timer.
  }
  // Process new messages from the database.
  func processNewMessage() {
    dbQueue.async {
      // Ensure we have a valid database connection before proceeding.
      guard let conn = self.dbConnection else {
        // Cancel the timer if the connection fails.
        self.messageCheckTimer?.cancel()
        print("\n[ERROR] processNewMessage: failed to connect to chat.db")
        return
      }
      // Configure and execute the database query.
      do {
        let messages = Table("message")
        let handles = Table("handle")
        let textColumn = Expression<String?>("text")
        let dateColumn = Expression<Int64>("date")
        let isFromMeColumn = Expression<Int>("is_from_me")
        let handleIdColumn = Expression<Int>("handle_id")
        let rowIdColumn = Expression<Int>("ROWID")
        let idColumn = Expression<String?>("id")
        // Construct query that gets new messages from other users in descending date order.
        let query = messages.join(.leftOuter, handles, on: handleIdColumn == handles[rowIdColumn])
          .select(textColumn, dateColumn, isFromMeColumn, handles[idColumn])
          .filter(dateColumn > self.lastProcessedMessageDate)
          .filter(isFromMeColumn == 0)
          .order(dateColumn.desc)
        // Process each new message.
        for message in try conn.prepare(query) {
          // Check if message text contains a unique authentication code.
          // If so, copy it to the pasteboard and trigger a notification.
          let text = message[textColumn]
          let senderId = message[handles[idColumn]] ?? "Unknown Sender"
          // Extract number from the message text and check if it's unique.
          if let authCode = text.flatMap({ self.extractNumber($0) }), self.lastCopiedNumber != authCode {
            // Update the pasteboard and trigger a notification on the main queue.
            DispatchQueue.main.async {
              NSPasteboard.general.declareTypes([.string], owner: nil)
              NSPasteboard.general.setString(authCode, forType: .string)
              if NSPasteboard.general.string(forType: .string) != nil {
                NotificationHandler().authCodeNotification(senderID: senderId, authCode: authCode)
              } else {
              }
            }
            // Store the unique authCode as the most recently processed.
            self.lastCopiedNumber = authCode
          }
          // Store the timestamp of the most recently processed message.
          self.lastProcessedMessageDate = message[dateColumn]
        }
      } catch {
        print("[ERROR] processNewMessage: \(error)")
      }
    }
  }
  // Extract a number containing 4 to 9 digits from a text string.
  // This is used to find authentication codes in message text.
  func extractNumber(_ text: String) -> String? {
    // Define the regular expression for matching numbers that consist of 4 to 9 digits
    do {
      let regex = try NSRegularExpression(pattern: "\\b\\d{4,9}\\b")
      // Define the range of the string for the search
      let range = NSRange(location: 0, length: text.utf16.count)
      // Use the regular expression to search for the first match in the string
      if let match = regex.firstMatch(in: text, options: [], range: range) {
        // If a match is found, extract the matched string and return it
        return (text as NSString).substring(with: match.range)
      }
      // If no match is found, return nil
      return nil
    } catch {
      return nil
    }
  }
  // MARK: - Process Lifecycle
  // Start the message checking process
  // Set up the database connection and get the timestamp of the latest message.
  func run() {
    connectToDatabase()
    // Only start the process if the database connection is successfully established.
    if dbConnection != nil {
      lastProcessedMessageDate = getLastMessageDate()
      setupMessageCheckTimer()
    }
  }
  // Cleanup when the process is about to terminate.
  // This prevents resource leaks and ensures a clean exit.
  func terminate(_: Notification) {
    messageCheckTimer?.cancel() // Cancel the timer.
    messageCheckTimer = nil // Remove the timer.
    dbConnection = nil // Close the database connection.
  }
}
