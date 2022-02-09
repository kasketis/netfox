<p align="center">
  <img src="netfox-logo.svg" />
</p>

<p align="center">
<img alt="Version" src="https://img.shields.io/badge/version-1.20.0-green.svg?style=flat-square" />
<a href="https://travis-ci.org/kasketis/netfox"><img alt="CI Status" src="http://img.shields.io/travis/kasketis/netfox.svg?style=flat-square" /></a>
<a href="https://cocoapods.org/pods/netfox"><img alt="Cocoapods Compatible" src="https://img.shields.io/cocoapods/v/netfox.svg?style=flat-square" /></a>
<a href="https://github.com/Carthage/Carthage"><img alt="Carthage Compatible" src="https://img.shields.io/badge/carthage-compatible-4BC51D.svg?style=flat-square" /></a>
<img alt="Platform" src="https://img.shields.io/cocoapods/p/netfox.svg?style=flat-square" />
<a href="https://opensource.org/licenses/MIT"><img alt="License" src="https://img.shields.io/badge/license-MIT-orange.svg?style=flat-square" /></a>
</p>


Netfox provides a quick look on all executed network requests performed by your iOS or OSX app.
It grabs all requests - of course yours, requests from 3rd party libraries (such as AFNetworking, Alamofire or else), UIWebViews, and more

Very useful and handy for network related issues and bugs

Supports Swift 5 and above - bridged also for Objective-C.

For Swift 4 support, use version [1.19.0](https://github.com/kasketis/netfox/releases/tag/1.19.0).

For Swift 3.2 support, use version [1.12.1](https://github.com/kasketis/netfox/releases/tag/1.12.1).

Feel free to contribute :)

### Overview
| ![](https://raw.githubusercontent.com/kasketis/netfox/master/assets/overview1_5_3.gif)  | ![](https://cloud.githubusercontent.com/assets/1402212/12893260/78f90916-ce90-11e5-830a-d1a1b91b2ac4.png) |
|---|---|

## Installation

### SPM (beta, only iOS)

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

To add `netfox` as a package dependency to your Xcode project, select `File > Add Packages` and enter as repository URL the `https://github.com/kasketis/netfox` (always choose the latest release)

For more info, please check [here](https://developer.apple.com/documentation/swift_packages/adding_package_dependencies_to_your_app)

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. To integrate netfox into your Xcode project using CocoaPods, specify it in your `Podfile`:

<pre>
use_frameworks!
pod 'netfox'
</pre>

To bundle only on some build configurations specify them after pod.

<pre>
use_frameworks!
pod 'netfox', :configurations => ['Debug', 'Test']
</pre>

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate netfox into your Xcode project using Carthage, specify it in your `Cartfile`:

<pre>
github "kasketis/netfox"
</pre>
### Manually

If you prefer not to use dependency managers, you can integrate netfox into your project manually.

You can do it by copying the "netfox" folder in your project (make sure that "Create groups" option is selected)

The above folder contains 3 subfolders: Core, iOS and OSX. 

- If you target on iOS keep only Core and iOS folders (remove OSX folder)
- If you target on OSX keep only Core and OSX folders (remove iOS folder)

## Start

#### Swift
```swift
// AppDelegate
import netfox
NFX.sharedInstance().start() // in didFinishLaunchingWithOptions:
```

</pre>

#### Objective-C
```objective-c
// AppDelegate
[NFX.sharedInstance start]; // in didFinishLaunchingWithOptions:
```

Just simple as that!

Note: Please wrap the above line with
```c
#if DEBUG
. . .
#endif
```
to prevent library’s execution on your production app.

You can add the DEBUG symbol with the -DDEBUG entry. Set it in the "Swift Compiler - Custom Flags" section -> "Other Swift Flags" line in project’s "Build Settings"

## Usage 

Just shake your device and check what's going right or wrong! 
Shake again and go back to your app!
![](https://raw.githubusercontent.com/kasketis/netfox/master/assets/shake.png)

## Stop

Call
```swift
NFX.sharedInstance().stop()
```
to stop netfox and clear all saved data. 
If you stop netfox its view will not be displayed until you call start method again. 

If you want to just enable/disable logging functionality or clear the data please use the buttons provided in the settings view

## Custom gestures

By default the library registers for shake motion. If you want to open the logs with a different gesture, add the following line after the installation one
```swift
NFX.sharedInstance().setGesture(.custom)
```
Then you can use
```swift
NFX.sharedInstance().show()
```
when you want to show the logs and
```swift
NFX.sharedInstance().hide()
```
when you want to hide them.

## Prevent logging for specific URLs

Use the following method to prevent requests for specified URL from being logged. You can ignore as many URLs as you want
```swift
NFX.sharedInstance().ignoreURL("the_url")
```
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

## Integrations

[Droar](https://github.com/myriadmobile/netfox-Droar): A modular, single-line installation debugging window.

## Other

- If you experience any problems with request logging please check [this](https://github.com/kasketis/netfox/blob/master/Workarounds.md). If you don't get your answer please open an [issue](https://github.com/kasketis/netfox/issues)
- Due to the large size of request/response bodies, the library provides disk storage for low memory overhead

## Thanks

Special thanks to [tbaranes](https://github.com/tbaranes) and [vincedev](https://github.com/vincedev) for their contribution on OSX library!

## Licence

All source code is licensed under [MIT License](https://github.com/kasketis/netfox/blob/master/LICENSE). Which means you could do virtually anything with the code. I will appreciate it very much if you keep an attribution where appropriate.

