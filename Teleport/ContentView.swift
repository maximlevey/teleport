//
//  ContentView.swift
//  Teleport Beta
//
//  Created by Maxim Levey
//

import SwiftUI

// MARK: - ContentView

struct ContentView: View {
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
                "**Teleport created by Maxim Levey**\n\n If you have any questions about Teleport or would like to contribute, please visit me on Github - I'd love to hear from you!"
            )
            .multilineTextAlignment(.center)
            .padding(.bottom)
            .padding(.horizontal, 7.5)
            .foregroundColor(Color(NSColor.textColor))

            // MARK: - Buttons

            // Visit Github Button
            Button(action: {
                if let url = URL(string: "https://github.com/maximlevey/Teleport") {
                    NSWorkspace.shared.open(url)
                }
            }) {
                Text("Visit Github")
            }
            .buttonStyle(
                CustomButtonStyleAlt(
                    backgroundColor: colorScheme == .dark ? Color(hex: "48dfba") : Color(hex: "162734"),
                    foregroundColor: colorScheme == .dark ? Color(NSColor.windowBackgroundColor) : Color(NSColor.windowBackgroundColor)
                )
            )

            // Support Teleport Button
            Button(action: {
                if let url = URL(string: "https://bmc.link/maximlevey") {
                    NSWorkspace.shared.open(url)
                }
            }) {
                Text("Support Teleport")
            }
            .buttonStyle(CustomButtonStyle())

            // Connect With Me Button
            Button(action: {
                if let url = URL(string: "https://www.linkedin.com/in/maximlevey/") {
                    NSWorkspace.shared.open(url)
                }
            }) {
                Text("Connect With Me")
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
