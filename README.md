<img align="left" width="128" height="128" src="https://user-images.githubusercontent.com/72744507/237012738-a25affd1-d26f-49f7-b09e-e80039856950.png">

# Teleport - Instant SMS 2FA
![macOS Supported Version](https://img.shields.io/badge/Requires_macOS-13.0%2B-162734?style=flat-square)
![Version](https://img.shields.io/badge/Version-1.0-162734?style=flat-square)

Teleport is a macOS utility that monitors incoming texts and automatically copies any authentication codes it finds to your clipboard.

> **Note** SMS-based two-factor authentication (2FA)is no longer considered to be a secure option for two-factor authentication, and should only be used when there are no other 2FA options available. Whenever possible, it's best to use time-based one-time password (TOTP) options such as those provided by 1Password or Google Authenticator. 

## Requirements

- An iPhone running iOS 8.1 or later
- A Mac running macOS Ventura or later.
- Both devices must be signed in to iCloud with the same Apple ID.

> For more information about SMS Forwarding, see Apple Support article [HT208386](https://support.apple.com/en-au/HT208386)

## Installation

**Manual Install**
- Grab the latest version of Teleport from the [releases page](https://github.com/maximlevey/Teleport/releases)
- Open `Teleport.zip` and move Teleport to your applications
- From your applications folder, right click Teleport and select `Open`

**Scripted Install**
```
cd ~/Downloads && curl -LO https://github.com/maximlevey/Teleport/releases/download/1.0/Teleport.zip && unzip Teleport.zip && mv Teleport/Teleport.app /Applications/ && rm -rf Teleport.zip Teleport/
```

## Setup

**On your Mac**
- Click on the Teleport icon located on your Mac's Menu Bar
- From the menu, select `System Preferences` 
- Add Teleport to the list of Apps and enable it
- Relaunch Teleport and watch codes teleport to your clipboard

**On your iPhone**
- Open settings and navigate to `Messages`
- Select `Text Message Forwarding` and enable your Mac

## FAQ

**Why does Teleport need full disk access?** 

Teleport needs full disk access to be able to read your local chat database file (chat.db), which is stored in a protected area of your disk. This access is essential for Teleport to perform its core functionality of processing your chat messages. It's important to note that even though it's termed "full disk access," Teleport only reads from the chat.db file and doesn't modify it in any way.

Apple's privacy regulations mandate that any app needing to access user data in protected areas of the filesystem must request full disk access, regardless of how limited or specific that access may be. It's a broad categorisation, intended to make it clear to users when an app needs to access sensitive data.

**How are my messages and data stored?**

Teleport is designed with your privacy and security as its utmost priority. All your messages and data are stored locally on your own device. The app doesn't have any network connectivity features, meaning it doesn't send your data to any external servers or third parties.

When Teleport processes a message, it reads the content from the local chat database (chat.db), does its processing, and then discards the data it read. Your messages are not stored elsewhere or retained longer than necessary. The original chat database itself is not modified, ensuring that your data remains secure and under your control.

**Why am I seeing "App Can’t Be Opened Because It Is From an Unidentified Developer"?**

This message appears because the app is not signed with a Developer ID. A Developer ID is a digital signature provided by Apple, which guarantees that the app is not tampered with and comes from a known source. It's part of Apple's Gatekeeper technology, which aims to protect users from malicious software.

At this stage, I don't have a Developer ID, this does not mean that the app is harmful; it just signifies that it has not been officially verified by Apple. To open Teleport, control-click the app icon, then choose Open from the shortcut menu. Click Open in the dialog box. If prompted, enter an administrator name and password.

## Contributions

Contributions are very welcome! I am by no means a developer and started Teleport as a way to learn some Swift, any recommendations around features and best practices would be greatly appreciated.

Feel free to shoot me a message on [LinkedIn](https://www.linkedin.com/in/maximlevey/) or in the [Mac Admins Slack.](https://macadmins.slack.com)

## License

> Copyright (c) 2023 Maxim Levey
>
>Permission is hereby granted, free of charge, to any person obtaining a copy
>of this software and associated documentation files (the "Software"), to deal
>in the Software without restriction, including without limitation the rights
>to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
>copies of the Software, and to permit persons to whom the Software is
>furnished to do so, subject to the following conditions:
>
>The above copyright notice and this permission notice shall be included in all
>copies or substantial portions of the Software.
>
>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
>AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
>LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
>OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
>SOFTWARE.
