//  Copyright (c) 2023 Maxim Levey
//
//  Teleport is licensed under the MIT license.
//  You may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  https://github.com/maximlevey/Teleport/blob/main/LICENSE

// MARK: - Imports

import AppKit
import Foundation
import SwiftUI

// MARK: - Preference View

struct PreferenceView: View {

  // Instance of PreferenceManager.
  @ObservedObject var preferences = PreferenceManager.shared
  // Boolean to handle display of PreferenceView
  @Binding var showPreferenceView: Bool

  // MARK: - View Content
  var body: some View {
    VStack(alignment: .center, spacing: 17.5) {

      Button(action: {
        showPreferenceView = false
        // swiftlint:disable:next multiple_closures_with_trailing_closure
      }) {
        Image(systemName: "arrow.left")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .foregroundColor(Color("teleportBrand"))
          .frame(width: 10, height: 10)
      }
      .buttonStyle(PlainButtonStyle())
      .padding(.leading)
      .frame(maxWidth: .infinity, alignment: .leading)

      VStack(alignment: .center) {
        // App Icon
        Image(systemName: "gear")
          .foregroundColor(Color("teleportBrand"))
          .font(.system(size: 32))
      }
      .frame(width: 125, height: 40)

      VStack(alignment: .center, spacing: 0) {
        Toggle(isOn: $preferences.notificationsDisabled) {
        }
        .padding(.top, 1.25)
        .padding(.bottom, 1.25)
        .toggleStyle(PrimaryToggleStyle(label: "Notifications"))
        .frame(width: 125, height: 22)

        Toggle(isOn: $preferences.hideAuthCode) {
        }
        .padding(.top, 1.25)
        .padding(.bottom, 1.25)
        .toggleStyle(PrimaryToggleStyle(label: "Show authCode"))
        .frame(width: 125, height: 22)

        Toggle(isOn: $preferences.hideSenderID) {
        }
        .padding(.top, 1.25)
        .padding(.bottom, 1.25)
        .toggleStyle(PrimaryToggleStyle(label: "Show senderID"))
        .frame(width: 125, height: 22)

        Spacer()
          .frame(height: 5)

        Button(action: {
          PreferenceManager.shared.notificationsRequested = false
          PreferenceManager.shared.notificationsDisabled = false
          PreferenceManager.shared.hideAuthCode = false
          PreferenceManager.shared.hideSenderID = false
          // swiftlint:disable:next multiple_closures_with_trailing_closure
        }) {
          Text("Restore Defaults")
            .font(.system(size: 12))
            .fontWeight(.regular)
        }
        .padding(.top, 1.5)
        .padding(.bottom, 1.5)
        .buttonStyle(SecondaryButtonStyle(
          height: 22,
          width: 125))

        Button(action: {
          if
            let url = URL(
              string:
                "x-apple.systempreferences:com.apple.preference.notifications")
          {
            NSWorkspace.shared.open(url)
          }
          // swiftlint:disable:next multiple_closures_with_trailing_closure
        }) {
          Text("System Settings")
            .font(.system(size: 12))
            .fontWeight(.regular)
        }
        .padding(.top, 1.5)
        .padding(.bottom, 1.5)
        .buttonStyle(SecondaryButtonStyle(
          height: 22,
          width: 125))
      }
      .frame(width: 125, height: 140)
      .padding(.bottom, 20)
    }
    .frame(width: 200, height: 275)
    .background(Color(NSColor.windowBackgroundColor))
  }
}
