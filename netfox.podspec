Pod::Spec.new do |s|
  s.name             = "netfox"
  s.version          = "1.7.2"
  s.summary          = "A lightweight, one line setup, iOS network debugging library!"
 
  s.description      = <<-DESC
A lightweight, one line setup, network debugging library that provides a quick look on all executed network requests performed by your app. It grabs all requests - of course yours, requests from 3rd party libraries (such as AFNetworking or else), UIWebViews, and more. Very useful and handy for network related issues and bugs.
DESC

  s.homepage         = "https://github.com/kasketis/netfox"
  s.screenshots      = "https://raw.githubusercontent.com/kasketis/netfox/master/assets/overview1_5_3.gif"
  s.license          = 'MIT'
  s.author           = "Christos Kasketis"
  s.source           = { :git => "https://github.com/kasketis/netfox.git", :tag => '1.7.2' }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = "netfox"
end
