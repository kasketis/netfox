![](https://raw.githubusercontent.com/kasketis/netfox/master/assets/netfox_logo.png)

[![Version](https://img.shields.io/badge/version-1.7.2-green.svg?style=flat-square)]()
[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/netfox.svg?style=flat-square)](https://github.com/cocoapods/cocoapods)
[![Carthage compatible](https://img.shields.io/badge/carthage-compatible-4BC51D.svg?style=flat-square)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/netfox.svg?style=flat-square)](http://cocoadocs.org/docsets/netfox)
[![License](https://img.shields.io/badge/license-MIT-orange.svg?style=flat-square)](https://opensource.org/licenses/MIT)

A lightweight, one line setup, network debugging library that provides a quick look on all executed network requests performed by your app.
It grabs all requests - of course yours, requests from 3rd party libraries (such as AFNetworking, Alamofire or else), UIWebViews, and more

Very useful and handy for network related issues and bugs

Implemented in Swift 2.1 - bridged also for Objective-C

Feel free to contribute :)

### Overview
![](https://raw.githubusercontent.com/kasketis/netfox/master/assets/overview1_5_3.gif)

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

<pre>
$ gem install cocoapods
</pre>

To integrate netfox into your Xcode project using CocoaPods, specify it in your `Podfile`:

<pre>
use_frameworks!
pod 'netfox'
</pre>

Then, run the following command:

<pre>
$ pod install
</pre>

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

<pre>
$ brew update
$ brew install carthage
</pre>

To integrate netfox into your Xcode project using Carthage, specify it in your `Cartfile`:

<pre>
github "kasketis/netfox"
</pre>

and follow [these](https://github.com/Carthage/Carthage#if-youre-building-for-ios) steps


### Manually

If you prefer not to use dependency managers, you can integrate netfox into your project manually.

You can do it by copying the "netfox" folder in your project (make sure that "Create groups" option is selected)

## Start

To start netfox add the following line in didFinishLaunchingWithOptions: method of your AppDelegate

#### Swift
<pre>
NFX.sharedInstance().start()
</pre>

#### Obj-C
<pre>
[[NFX sharedInstance] start];
</pre>

Just simple as that!

Note: Please wrap the above line with
<pre>
#if DEBUG
. . .
#endif
</pre>
to prevent library’s execution on your production app.

You can add the DEBUG symbol with the -DDEBUG entry. Set it in the "Swift Compiler - Custom Flags" section -> "Other Swift Flags" line in project’s "Build Settings"

## Usage 

Just shake your device and check what's going right or wrong! 
Shake again and go back to your app!
![](https://raw.githubusercontent.com/kasketis/netfox/master/assets/shake.png)

## Stop

Call
<pre>
NFX.sharedInstance().stop()
</pre>
to stop netfox and clear all saved data. 
If you stop netfox its view will not be displayed until you call start method again. 

If you want to just enable/disable logging functionality or clear the data please use the buttons provided in the settings view

## Custom gestures

By default the library registers for shake motion. If you want to open the logs with a different gesture, add the following line after the installation one
<pre>
NFX.sharedInstance().setGesture(.custom)
</pre>
Then you can use
<pre>
NFX.sharedInstance().show()
</pre>
when you want to show the logs and
<pre>
NFX.sharedInstance().hide()
</pre>
when you want to hide them.

## Prevent logging for specific URLs

Use the following method to prevent requests for specified URL from being logged. You can ignore as many URLs as you want
<pre>
NFX.sharedInstance().ignoreURL("the_url")
</pre>
Tip: You can use the url of the host (for example "https://www.github.com") to ignore all paths of it 

## Features

- Search: You can easily search among requests via
	- Request url: github.com, .gr, or whatever you want
	- Request method: GET, POST, etc
	- Response type: Like json, xml, html, image and more 
- Sharing: You can share your log via email with backend devs or someone who can help.
	- Simple log option includes only request/response headers and small request/response bodies (when applicable)
	- Full log option includes request/response headers and request/response bodies (as attachments)
- Filtering: Select what types of responses (JSON/XML/HTML/Image/Other) you want to see
- Enable/disable logging within the app
- Clear data within the app
- Statistics: Check cool things like average response time, total response size and more for your selected types of responses
- Info: Check your IP address, your app version and build number and other things within the app
- More to come.. ;)

## Other

- If you experience any problems with request logging please check [this](https://github.com/kasketis/netfox/blob/master/Workarounds.md). If you don't get your answer please open an [issue](https://github.com/kasketis/netfox/issues)
- Due to the large size of request/response bodies, the library provides disk storage for low memory overhead

## Licence

All source code is licensed under [MIT License](https://github.com/kasketis/netfox/blob/master/LICENSE). Which means you could do virtually anything with the code. I will appreciate it very much if you keep an attribution where appropriate.

