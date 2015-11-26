#### Alamofire workaround

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

#### No HTTP body for requests

Unfortunately, due to a limitation in NSURLProtocol, netfox is unable to log the HTTP body of some requests (check [this](http://openradar.appspot.com/15993891) radar for more details)

[jasoncabot](https://github.com/jasoncabot) posted a nice workaround on this:

You can do the following to monitor these requests
<pre>
if let bodyData = mutableURLRequest.HTTPBody {
    NSURLProtocol.setProperty(bodyData, forKey: "NFXBodyData", inRequest: mutableURLRequest)
}
</pre>

Tip for Alamofire users: Subclass URLRequestConvertible and make all the work there