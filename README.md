<img align="left" width="128" height="128" src="https://user-images.githubusercontent.com/72744507/237012738-a25affd1-d26f-49f7-b09e-e80039856950.png">

# Teleport - Instant SMS 2FA
![macOS Supported Version](https://img.shields.io/badge/Requires_macOS-13.0%2B-162734?style=flat-square)
![Version](https://img.shields.io/badge/Version-0.1-162734?style=flat-square)

Teleport is a macOS utility that monitors incoming texts and automatically copies any authentication codes it finds to your clipboard.

> **Note** SMS-based two-factor authentication (2FA)is no longer considered to be a secure option for two-factor authentication, and should only be used when there are no other 2FA options available. Whenever possible, it's best to use time-based one-time password (TOTP) options such as those provided by 1Password or Google Authenticator. 

## Screenshots
![UI_Screenshots](https://github.com/maximlevey/Teleport/assets/72744507/76025c7a-e15e-4cdd-bdae-720f50bf7d04)

## Download

- Grab the latest version of Teleport from the [releases page](https://github.com/maximlevey/Teleport/releases)
- Alternatively, install via script by running the following command
```
cd ~/Downloads && curl -LO https://github.com/maximlevey/Teleport/releases/download/0.1/Teleport.zip && unzip Teleport.zip && mv Teleport/Teleport.app /Applications/ && rm -rf Teleport.zip Teleport/
```

## Installation

1. Open the `Teleport.zip` on your device and follow the instructions.
2. On your iPhone, go to Settings > Messages > Text Message Forwarding and enable forwarding to your Mac.

## Requirements

- An iPhone running iOS 8.1 or later
- A Mac running OS X Yosemite or later.
- Both devices must be signed in to iCloud with the same Apple ID.

> For more information about SMS Forwarding, see Apple Support article [HT208386](https://support.apple.com/en-au/HT208386)

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
