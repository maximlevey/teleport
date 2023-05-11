//
//  WelcomeView.swift
//  Teleport Beta
//
//  Created by Maxim Levey
//

import SwiftUI

// MARK: - WelcomeView

struct WelcomeView: View {
    // Reference to the AppDelegate.
    @EnvironmentObject var appDelegate: AppDelegate
    //
    @Environment(\.colorScheme) var colorScheme

    // MARK: - Main View

    var body: some View {
        VStack {
            // MARK: - App Icon

            // App Icon Image
            Image(nsImage: NSImage(named: "AppIcon")!)
                .resizable()
                .frame(width: 128, height: 128)

            // MARK: - Header

            // App Title
            Text("Teleport")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(NSColor.textColor))

            // App Version
            Text("Version 1.4 Beta")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.bottom)

            // MARK: - Body

            // Main Paragraph
            Text(
                "**Thank you for installing Teleport!**\n\n Full Disk Access is required to monitor incoming messages. To get started, click the button below and follow the prompts."
            )
            .multilineTextAlignment(.center)
            .padding(.bottom)
            .padding(.horizontal, 7.5)
            .foregroundColor(Color(NSColor.textColor))

            // MARK: - Buttons

            // Full Disk Access Button
            Button(action: {
                appDelegate.openFullDiskAccessSettings()
            }) {
                Text("Grant Full Disk Access")
            }
            .buttonStyle(
                CustomButtonStyleAlt(
                    backgroundColor: colorScheme == .dark ? Color(hex: "48dfba") : Color(hex: "162734"),
                    foregroundColor: colorScheme == .dark ? Color(NSColor.windowBackgroundColor) : Color(NSColor.windowBackgroundColor)
                )
            )
            // Notifications Button
            Button(action: {
                appDelegate.openNotificationSettings()
            }) {
                Text("Notifications")
            }
            .buttonStyle(CustomButtonStyle())

            // About Button
            Button(action: {
                appDelegate.openAboutView()
            }) {
                Text("About Teleport...")
            }
            .buttonStyle(CustomButtonStyle())
            .padding(.bottom)

            // MARK: - Footer

            VStack(alignment: .center, spacing: 4) {
                // License
                Text("MIT License")
                    .font(.footnote)
                    .foregroundColor(.gray)
                // Copyright
                Text("Copyright (c) 2023 Maxim Levey")
                    .font(.footnote)
                    .foregroundColor(.gray)

                // Source Code
                Link(
                    "View Source Code",
                    destination: URL(string: "https://github.com/maximlevey/Teleport/")!
                )
                .font(.footnote)
                .foregroundColor(.gray)
                .underline()
            }.padding(.bottom)
        }
        .padding(.horizontal)
        .frame(width: 300, height: 500)
        .background(Color(NSColor.windowBackgroundColor))
    }
}
