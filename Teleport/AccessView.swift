//
//  AccessView.swift
//  Teleport Beta
//
//  Created by Maxim Levey
//

import SwiftUI

// MARK: - AccessView

struct AccessView: View {
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
            Text("Version 0.1")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.bottom)

            // MARK: - Body

            // Main Paragraph
            Text(
                "**Houston, we have a problem**\n\n It looks like Teleport doesn't have access to monitor incoming messages. Please click below and grant access..."
            )
            .multilineTextAlignment(.center)
            .padding(.bottom)
            .padding(.horizontal, 7.5)
            .foregroundColor(Color(NSColor.textColor))

            // MARK: - Buttons

            // Grant Full Disk Access Button
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

            // Quit Teleport Button
            Button(action: {
                appDelegate.quitApp()
            }) {
                Text("Quit Teleport")
            }
            .buttonStyle(CustomButtonStyle())

            // About Teleport Button
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
