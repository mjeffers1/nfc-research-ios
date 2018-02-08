# 📱 iOS NFC Example App

A quick example showing how to use the Core NFC API in iOS 11 and Swift.
Detect NFC tags and read messages that contain NDEF data.

## Overview

Your app can read tags to give users more information about their physical environment and the real-world objects in it. For example, your app might give users information about products they find in a store or exhibits they visit in a museum.

Using Core NFC, you can read Near Field Communication (NFC) tags of types 1 through 5 that contain data in the NFC Data Exchange Format (NDEF). To read a tag, your app creates an NFC NDEF reader session and provides a delegate. A running reader session polls for NFC tags and calls the delegate when it finds tags that contain NDEF messages, passing the messages to the delegate. The delegate can read the messages and handle conditions that can cause a session to become invalid.

To enable your app to detect NFC tags, turn on the Near Field Communication Tag Reading capability in your Xcode project. To learn more about adding capabilities to your project, see Add a capability to a target.

# Note

Reading NFC NDEF tags is only supported on iPhone 7, iPhone 7 Plus, iPhone 8, iPhone 8 Plus and iPhone X.
