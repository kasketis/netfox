//
//  NFXAuthenticationChallengeSender.swift
//  netfox_ios
//
//  Created by Nathan Jangula on 3/5/18.
//  Copyright © 2018 kasketis. All rights reserved.
//

import Foundation

internal class NFXAuthenticationChallengeSender : NSObject, URLAuthenticationChallengeSender {
    
    typealias NFXAuthenticationChallengeHandler = (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    
    fileprivate var handler: NFXAuthenticationChallengeHandler
    
    init(handler: @escaping NFXAuthenticationChallengeHandler) {
        self.handler = handler
        super.init()
    }
    
    public func use(_ credential: URLCredential, for challenge: URLAuthenticationChallenge) {
        handler(URLSession.AuthChallengeDisposition.useCredential, credential)
    }
    
    public func continueWithoutCredential(for challenge: URLAuthenticationChallenge) {
        handler(URLSession.AuthChallengeDisposition.useCredential, nil)
    }

    public func cancel(_ challenge: URLAuthenticationChallenge) {
        handler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
    }

    public func performDefaultHandling(for challenge: URLAuthenticationChallenge) {
        handler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
    }

    public func rejectProtectionSpaceAndContinue(with challenge: URLAuthenticationChallenge) {
        handler(URLSession.AuthChallengeDisposition.rejectProtectionSpace, nil)
    }
}
