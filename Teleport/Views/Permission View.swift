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

// MARK: - Permission View

struct PermissionView: View {
  // MARK: - View Content
  var body: some View {
    VStack(alignment: .center, spacing: 20) {
      VStack(alignment: .center, spacing: 2) {
        Image(systemName: "exclamationmark.triangle")
          .foregroundColor(Color("teleportBrand"))
          .font(.system(size: 64))
      }
      VStack(alignment: .center, spacing: 2) {
        Text("Teleport requires full disk access to monitor chat.db")
          .font(.system(size: 12))
          .fontWeight(.medium)
          .foregroundColor(Color(NSColor.textColor))
          .multilineTextAlignment(.center)
          .frame(width: 175)
          .padding(.bottom, 2.5)
        Text("Open System Preferences using the button below and enable Teleport. ")
          .font(.system(size: 12))
          .foregroundColor(.gray)
          .multilineTextAlignment(.center)
          .frame(width: 175)
      }
      VStack(alignment: .center, spacing: 7.5) {
        Button(action: {
          if
            let url = URL(
              string:
                "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles")
          {
            NSWorkspace.shared.open(url)
          }
          // swiftlint:disable:next multiple_closures_with_trailing_closure
        }) {
          Text("System Preferences")
            .font(.system(size: 12))
            .fontWeight(.regular)
        }
        .buttonStyle(PrimaryButtonStyle(height: 22, width: 175))
        Button(action: {
          NSApplication.shared.terminate(nil)
          // swiftlint:disable:next multiple_closures_with_trailing_closure
        }) {
          Text("Quit Teleport")
            .font(.system(size: 12))
            .fontWeight(.regular)
            .foregroundColor(Color(NSColor.textColor))
        }
        .buttonStyle(SecondaryButtonStyle(height: 22, width: 175))
      }
    }
    .frame(width: 200, height: 275)
    .background(Color(NSColor.windowBackgroundColor))
  }
}
