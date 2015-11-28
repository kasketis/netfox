![](https://raw.githubusercontent.com/kasketis/netfox/master/assets/netfox_logo.png)

A lightweight, one line setup, network debugging library that provides a quick look on all executed network requests performed by your app.
It grabs all requests - of course yours, requests from 3rd party libraries (such as AFNetworking or else), UIWebViews, and more

Very useful and handy for network related issues and bugs

Implemented in Swift 2.1 - bridged also for Objective-C

Current version: 1.4.1

Feel free to contribute :)

#### Overview
![](https://raw.githubusercontent.com/kasketis/netfox/master/assets/overview1_3.gif)

#### Installation

Insert this line in your Podfile
<pre>
pod 'netfox'
</pre>

or if you want to do it manually just copy the "netfox" folder in your project (make sure that "Create groups" option is selected)

Then add the following line in didFinishLaunchingWithOptions: method of your AppDelegate

Swift
<pre>
NFX.sharedInstance().start()
</pre>

Objective-C
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

#### Usage 

Just shake your device and check what's going right or wrong! 
Shake again and go back to your app! fact
![](https://raw.githubusercontent.com/kasketis/netfox/master/assets/shake.png)

#### Stop

Call
<pre>
NFX.sharedInstance().stop()
</pre>
to stop netfox and clear all saved data. 
If you stop netfox its view will not be displayed until you call start method again. 

If you want to just enable/disable logging functionality or clear the data please use the buttons provided in the settings view

#### Custom gestures

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

#### Prevent logging for specific URLs

Use the following method to prevent requests for specified URL from being logged. You can ignore as many URLs as you want
<pre>
NFX.sharedInstance().ignoreURL("the_url")
</pre>
Tip: You can use the url of the host (for example "https://www.github.com") to ignore all paths of it 

#### Features

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
- More to come.. ;)

#### Other

- Alamofire users check [this](https://github.com/kasketis/netfox/blob/master/Workarounds.md#alamofire-workaround)
- If you can't log request body check [this](https://github.com/kasketis/netfox/blob/master/Workarounds.md#no-http-body-for-requests)
- Due to the large size of request/response bodies, the library provides disk storage for low memory overhead

#### Licence

All source code is licensed under [MIT License](https://github.com/kasketis/netfox/blob/master/LICENSE). Which means you could do virtually anything with the code. I will appreciate it very much if you keep an attribution where appropriate.

