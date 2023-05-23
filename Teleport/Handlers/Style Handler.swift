//  Copyright (c) 2023 Maxim Levey
//
//  Teleport is licensed under the MIT license.
//  You may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  https://github.com/maximlevey/Teleport/blob/main/LICENSE

// MARK: - Imports

import SwiftUI

// MARK: - Button Styles

// Define a primary button style
struct PrimaryButtonStyle: ButtonStyle {
  let height: CGFloat
  let width: CGFloat
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .padding(.all, 0.0)
      .font(.system(size: 12))
      .frame(maxWidth: width, maxHeight: height) // Set frame dimensions
      .background(RoundedRectangle(cornerRadius: 5) // Set background to a rounded rectangle
        .fill(configuration.isPressed
              ? Color("teleportBrand").opacity(0.8)
              : Color("teleportBrand")))
      .foregroundColor(configuration.isPressed
                       ? Color(.windowBackgroundColor)
                       : Color(.windowBackgroundColor))
  }
}

// Define a secondary button style
struct SecondaryButtonStyle: ButtonStyle {
  let height: CGFloat
  let width: CGFloat
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding(.all, 0.0)
      .font(.system(size: 12))
      .frame(maxWidth: width, maxHeight: height) // Set frame dimensions
      .background(RoundedRectangle(cornerRadius: 5) // Set background to a rounded rectangle
        .fill(configuration.isPressed
              ? Color(.separatorColor).opacity(0.8)
              : Color(.separatorColor)))
      .foregroundColor(configuration.isPressed
                       ? Color(.textColor)
                       : Color(.textColor))
  }
}

// MARK: - Toggle Styles

// Define a primary toggle style
struct PrimaryToggleStyle: ToggleStyle {
  let label: String
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      Text(label) // Add label
        .padding(.all, 0.0)
        .frame(maxWidth: .infinity, alignment: .leading) // Set frame dimensions
        .foregroundColor(Color(NSColor.textColor))
      RoundedRectangle(cornerRadius: 5) // Create toggle switch with rounded corners
        .fill(!configuration.isOn
              ? Color("teleportBrand")
              : Color(.separatorColor))
        .overlay(
          Group {
            if !configuration.isOn {
              // Add checkmark image when toggle is off
              Image(systemName: "checkmark")
                .foregroundColor(Color(.windowBackgroundColor))
                .font(.system(size: 7.5))
                .fontWeight(.bold)
            }
          }
        )
        .frame(width: 15, height: 15) // Set frame dimensions
        .padding(.all, 0.0)
        .onTapGesture {
          withAnimation(.linear(duration: 0.1)) {
            configuration.isOn.toggle()
          }
        }
    }
    .padding(.all, 0.0)
    .background(Color.clear)
  }
}
