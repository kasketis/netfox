### Alamofire workaround

Due to the way Alamofire uses NSURLSession, you’ll need to do a little more than the standard installation to monitor all requests. The simplest way to do this is to create a subclass of Manager to handle your requests as this

<pre>
import Alamofire

class NFXManager: Alamofire.Manager
{
    static let sharedManager: NFXManager = {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.protocolClasses?.insert(NFXProtocol.self, atIndex: 0)
        let manager = NFXManager(configuration: configuration)
        return manager
    }()
}
</pre>

 Then just use NFXManager.sharedManager instead of Alamofire.request()