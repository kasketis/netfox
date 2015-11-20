![](https://raw.githubusercontent.com/kasketis/netfox/master/assets/netfox_logo.png)

A lightweight, one line setup, network debugging library that provides a quick look on all executed network requests performed by your app.
It grabs all requests - of course yours, requests from 3rd party libraries (such as AFNetworking or else), UIWebViews, and more

Very useful and handy for network related issues and bugs

Implemented in Swift 2.1 - bridged also for Objective-C

Feel free to contribute :)

#### Installation

Copy the “nfx” folder in your project and add the following line in didFinishLaunchingWithOptions: method of your AppDelegate

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

Just shake your device and check what's going right or wrong! 
Shake again and go back to your app! 
![](https://raw.githubusercontent.com/kasketis/netfox/master/assets/shake.png)

#### Features

- Search: You can easily search among requests via
	- Request url: github.com, .gr, or whatever you want
	- Request method: GET, POST, etc
	- Response status: 200 (these are the green guys), 400/404/500 (the red bad guys)
	- Response type: Like json, xml, html, image and more 
- Sharing: You can share your log via email with backend devs or someone who can help.
	- Simple log option includes only request/response headers and small request/response bodies (when these apply)
	- Full log option includes request/response headers and request/response bodies (as attachments)
- More to come.. ;)

#### Other

Due to the large size of request/response bodies, the library provides disk storage for low memory overhead

#### Licence

All source code is licensed under MIT License

