//
//  Constants.swift
//  Teleport Beta
//
//  Created by Maxim Levey
//

import SwiftUI
import Cocoa

// MARK: - Global Variables

let appIcon = NSImage(named: "AppIcon")

// MARK: - Color Extension

extension Color {
    // Initializes a Color instance with a hex color code.
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r: UInt64
        let g: UInt64
        let b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }
        self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255)
    }
}

// MARK: - Window Extension

extension NSWindow {
    func bringToFront() {
        self.level = .floating
        self.orderFrontRegardless()
        self.makeKey()
    }
}

// MARK: - Button Styles

struct CustomButtonStyle: ButtonStyle {
    // Returns a custom appearance for a button.
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: 175)
            .frame(maxHeight: 22)
            .background(Color(NSColor.separatorColor))
            .foregroundColor(Color(NSColor.textColor))
            .cornerRadius(5)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

struct CustomButtonStyleAlt: ButtonStyle {
    let backgroundColor: Color
    let foregroundColor: Color

    // Returns a custom appearance for a button, allowing custom background and foreground colors.
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: 175)
            .frame(maxHeight: 22)
            .background(backgroundColor)
            .foregroundColor(Color(NSColor.windowBackgroundColor))
            .cornerRadius(5)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}
