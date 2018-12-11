Pod::Spec.new do |s|
  s.name             = "netfox"
  s.version          = "1.14.0"
  s.summary          = "A lightweight, one line setup, iOS/OSX network debugging library!"
 
  s.description      = <<-DESC
A lightweight, one line setup, network debugging library that provides a quick look on all executed network requests performed by your app. It grabs all requests - of course yours, requests from 3rd party libraries (such as AFNetworking or else), UIWebViews, and more. Very useful and handy for network related issues and bugs.
DESC

  s.homepage         = "https://github.com/kasketis/netfox"
  s.screenshots      = "https://raw.githubusercontent.com/kasketis/netfox/master/assets/overview1_5_3.gif"
  s.license          = 'MIT'
  s.author           = "Christos Kasketis"
  s.source           = { :git => "https://github.com/kasketis/netfox.git", :tag => "#{s.version}" }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.11'
  s.requires_arc = true
  s.source_files = "netfox/Core/*.{swift,h,m}"
  s.ios.source_files = "netfox/iOS/*.swift"
  s.osx.source_files = "netfox/OSX/*.{swift,xib}"  
end
