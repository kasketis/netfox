## 99%

The most common issue requests don't get logged is the use of a custom NSURLSession (search for "NSURLSession" or "NSURLSessionConfiguration" in your code or in the 3rd party library's code).
In this case you must add the following in the default configuration

#### Swift
<pre>
let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
configuration.protocolClasses?.insert(NFXProtocol.self, atIndex: 0)
</pre>

#### Obj-C
<pre>
NSURLSessionConfiguration* config = NSURLSessionConfiguration.defaultSessionConfiguration;
config.protocolClasses = @[[NFXProtocol class]];
</pre>

Below you can find some library-specific workarounds

### Alamofire

Due to the way Alamofire uses NSURLSession, you’ll need to do a little more than the standard installation to monitor all requests. The simplest way to do this is to create a subclass of Manager to handle your requests as this

<pre>
import Alamofire

class NFXManager: Alamofire.Manager
{
    static let sharedManager: NFXManager = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.protocolClasses?.insert(NFXProtocol.self, atIndex: 0)
        configuration.HTTPAdditionalHeaders = Manager.defaultHTTPHeaders
        let manager = NFXManager(configuration: configuration)
        return manager
    }()
}
</pre>

Then just use NFXManager.sharedManager instead of Alamofire.request()

More [#4](https://github.com/kasketis/netfox/issues/4)

### KFSwiftImageLoader

Same here. Please replace

<pre>
internal lazy var session: NSURLSession = {
    let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
    configuration.requestCachePolicy = .ReturnCacheDataElseLoad
    configuration.URLCache = .sharedURLCache()
    return NSURLSession(configuration: configuration)
}()
</pre>

with

<pre>
internal lazy var session: NSURLSession = {
    let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
    configuration.protocolClasses?.insert(NFXProtocol.self, atIndex: 0) //added line
    configuration.requestCachePolicy = .ReturnCacheDataElseLoad
    configuration.URLCache = .sharedURLCache()
    return NSURLSession(configuration: configuration)
}()
</pre>

in the KFImageCacheManager.swift file

Note: You will get image log only the first time because KFSwiftImageLoader caches the images and doesn't request them again

More [#21](https://github.com/kasketis/netfox/issues/21)

## No HTTP body for requests

Unfortunately, due to a limitation in NSURLProtocol, netfox is unable to log the HTTP body of some requests (check [this](http://openradar.appspot.com/15993891) radar for more details)

[jasoncabot](https://github.com/jasoncabot) posted a nice workaround on this:

You can do the following to monitor these requests
<pre>
if let bodyData = mutableURLRequest.HTTPBody {
    NSURLProtocol.setProperty(bodyData, forKey: "NFXBodyData", inRequest: mutableURLRequest)
}
</pre>

Tip for Alamofire users: Subclass URLRequestConvertible and make all the work there

More [#16](https://github.com/kasketis/netfox/issues/16)
