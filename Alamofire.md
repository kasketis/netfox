{\rtf1\ansi\ansicpg1252\cocoartf1348\cocoasubrtf170
{\fonttbl\f0\fnil\fcharset0 Menlo-Regular;\f1\froman\fcharset0 Times-Roman;\f2\fmodern\fcharset0 Courier;
}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;\red170\green13\blue145;\red92\green38\blue153;
\red63\green110\blue116;\red46\green13\blue110;\red28\green0\blue207;}
\paperw11900\paperh16840\margl1440\margr1440\vieww16940\viewh8400\viewkind0
\deftab626
\pard\tx626\pardeftab626\pardirnatural

\f0\fs26 \cf0 \CocoaLigature0 ### Alamofire workaround\
\
\pard\pardeftab720\sa240

\f1\fs24 \cf2 \expnd0\expndtw0\kerning0
\CocoaLigature1 \outl0\strokewidth0 \strokec2 Due to the way Alamofire uses NSURLSession, you\'92ll need to do a little more than the standard installation to monitor all requests. The simplest way to do this is to create a subclass of 
\f2 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 Manager
\f1 \expnd0\expndtw0\kerning0
\outl0\strokewidth0  to handle your requests as this\
\pard\tx626\pardeftab626\pardirnatural

\f0\fs26 \cf0 \kerning1\expnd0\expndtw0 \CocoaLigature0 \outl0\strokewidth0 \
<pre>\
\pard\tx626\pardeftab626\pardirnatural
\cf3 import\cf0  Alamofire\
\
\cf3 class\cf0  NFXManager: \cf4 Alamofire\cf0 .\cf5 Manager\cf0 \
\{\
    \cf3 static\cf0  \cf3 let\cf0  sharedManager: NFXManager = \{\
        \cf3 let\cf0  configuration = \cf4 NSURLSessionConfiguration\cf0 .\cf6 defaultSessionConfiguration\cf0 ()\
        configuration.\cf4 protocolClasses\cf0 ?.\cf6 insert\cf0 (\cf5 NFXProtocol\cf0 .\cf3 self\cf0 , atIndex: \cf7 0\cf0 )\
        \cf3 let\cf0  manager = NFXManager(configuration: configuration)\
        \cf3 return\cf0  manager\
    \}()\
\}\
</pre>\
\
\pard\pardeftab720\sa240

\f1\fs24 \cf0 \expnd0\expndtw0\kerning0
\CocoaLigature1  Then just use 
\f0\fs26 \kerning1\expnd0\expndtw0 \CocoaLigature0 NFXManager.sharedManager
\f1\fs24 \expnd0\expndtw0\kerning0
\CocoaLigature1  instead of 
\f2 \expnd0\expndtw0\kerning0
Alamofire.request()}