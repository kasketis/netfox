# netfox

A lightweight, one line setup, swift library that provides a quick look on all executed network requests performed by your app
It grabs all requests - yours, from 3rd party (such as AFNetworking or else), UIWebViews, and more

Very useful and handy for network related issues and bugs

Implemented in Swift 2.1 - ported also for Objective-C

#### Installation

Copy nfx folder in your project and paste the following line in didFinishLaunchingWithOptions: method of your AppDelegate

Swift
<pre>
NFX.sharedInstance().start()
</pre>

Objective-C
<pre>
[[NFX sharedInstance] start];
</pre>

Just simple as that!

#### Usage

Just shake your device and check what's going right or wrong! Shake again and go back in your app! ![](https://copy.com/3YVZR7LxuSHwqH1q/shake.png)

#### Sharing

You can share your log via email with backend devs or someone who can help.
- Simple log option includes only request/response headers and small request/response bodies (when these apply)
- Full log option includes request/response headers and request/response bodies (as attachments)

#### Other

Due to large size of request/response bodies, library provides disk storage for low memory overhead

#### Licence

All source code is licensed under MIT License

