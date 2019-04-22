//
//  NFXAuthenticationChallengeSender.swift
//  netfox_ios
//
//  Created by Nathan Jangula on 3/5/18.
//  Copyright © 2018 kasketis. All rights reserved.
//

import Foundation

class NFXAuthenticationChallengeSender : NSObject, URLAuthenticationChallengeSender {
    
    typealias NFXAuthenticationChallengeHandler = (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    
    let handler: NFXAuthenticationChallengeHandler
    
    init(handler: @escaping NFXAuthenticationChallengeHandler) {
        self.handler = handler
        super.init()
    }
    
    func use(_ credential: URLCredential, for challenge: URLAuthenticationChallenge) {
        handler(.useCredential, credential)
    }
    
    func continueWithoutCredential(for challenge: URLAuthenticationChallenge) {
        handler(.useCredential, nil)
    }

    func cancel(_ challenge: URLAuthenticationChallenge) {
        handler(.cancelAuthenticationChallenge, nil)
    }

    func performDefaultHandling(for challenge: URLAuthenticationChallenge) {
        handler(.performDefaultHandling, nil)
    }

    func rejectProtectionSpaceAndContinue(with challenge: URLAuthenticationChallenge) {
        handler(.rejectProtectionSpace, nil)
    }
}
