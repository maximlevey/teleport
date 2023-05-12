//
//  StartupView.swift
//  Teleport Beta
//
//  Created by Maxim Levey
//

import SwiftUI

// MARK: - StartupView

struct StartupView: View {
    // Reference to the AppDelegate.
    @EnvironmentObject var appDelegate: AppDelegate

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
                .padding(.bottom, 3)

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
        .frame(width: 300, height: 300)
        .background(Color(NSColor.windowBackgroundColor))
    }
}
