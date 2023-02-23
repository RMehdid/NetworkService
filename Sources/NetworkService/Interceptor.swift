//
//  Interceptor.swift
//  
//
//  Created by Samy Mehdid on 23/2/2023.
//

import Foundation
import Alamofire

struct JWTCredential: AuthenticationCredential {
    let accessToken: String
    let expiration: Date
    
    var requiresRefresh: Bool { Date(timeIntervalSinceNow: 60 * 5) > expiration }
}

class JWTAuthenticator: Authenticator {
    func apply(_ credential: JWTCredential, to urlRequest: inout URLRequest) {
        urlRequest.headers.add(.authorization(bearerToken: credential.accessToken))
    }

    func refresh(_ credential: JWTCredential,
                 for session: Session,
                 completion: @escaping (Result<JWTCredential, Error>) -> Void) {
        NetworkService.shared.refreshToken(completion: completion)
    }

    func didRequest(_ urlRequest: URLRequest,
                    with response: HTTPURLResponse,
                    failDueToAuthenticationError error: Error) -> Bool {
        // If authentication server CANNOT invalidate credentials, return `false`
        
        return response.statusCode == 401

        // If authentication server CAN invalidate credentials, then inspect the response matching against what the
        // authentication server returns as an authentication failure. This is generally a 401 along with a custom
        // header value.
        // return response.statusCode == 401
    }

    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: JWTCredential) -> Bool {
        // If authentication server CANNOT invalidate credentials, return `true`

        // If authentication server CAN invalidate credentials, then compare the "Authorization" header value in the
        // `URLRequest` against the Bearer token generated with the access token of the `Credential`.
         let bearerToken = HTTPHeader.authorization(bearerToken: credential.accessToken).value
         return urlRequest.headers["Authorization"] == bearerToken
    }
}
