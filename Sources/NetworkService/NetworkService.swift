import Alamofire
import Foundation
import AuthenticationService

public struct NetworkService {
    static let shared = NetworkService()
    
    private let session = Session()
    private let credential = JWTCredential(accessToken: UserDefaults.standard.accessToken ?? "", expiration: Date(timeIntervalSinceNow: 60 * 60))
    private let authenticator = JWTAuthenticator()
    
    private let timout: Double = 30
    
    private var interceptor: AuthenticationInterceptor<JWTAuthenticator> {
        return AuthenticationInterceptor(authenticator: authenticator, credential: credential)
    }
    
    func get<Model: Decodable>(url: String, query: [String: Any]? = nil, success: @escaping (Model) -> Void, failed: @escaping (Int, String?) -> Void){
        print("http:url: \(url)")
        let header: HTTPHeaders = [
            .authorization("Bearer \(credential.accessToken)")
        ]
        
        session.request(url, method: .get, parameters: query, encoding: URLEncoding.queryString, headers: header, interceptor: interceptor) { (urlRequest: inout URLRequest) in
            urlRequest.timeoutInterval = self.timout
        }.responseDecodable(of: Model.self) { response in
            print("http:res: \(response.debugDescription)")
            switch response.result {
            case .success(let res):
                success(res)
            case .failure(let error):
                failed(0, error.errorDescription)
            }
        }
    }
    
    func post<Model: Decodable>(url: String, body: [String: Any], success: @escaping (Model) -> Void, failed: @escaping (Int, String?) -> Void){
        print("http:url: \(url)")
        print("http:body: \(body)")
        let header: HTTPHeaders = [
            .authorization("Bearer \(credential.accessToken)")
        ]
        
        session.request(url, method: .post, parameters: body, encoding: JSONEncodingWithoutEscapingSlashes.prettyPrinted, headers: header, interceptor: interceptor){ (urlRequest: inout URLRequest) in
            urlRequest.timeoutInterval = self.timout
        }.responseDecodable(of: Model.self) { response in
            print("http:res: \(response.debugDescription)")
            switch response.result {
            case .success(let res):
                success(res)
            case .failure(let error):
                failed(0, error.errorDescription)
            }
        }
    }
    
    func put(url: String, body: [String: Any]? = nil, success: @escaping () -> Void, failed: @escaping (Int, String?) -> Void){
        print("http:url: \(url)")
        print("http:body: \(body)")
        let header: HTTPHeaders = [
            .authorization("Bearer \(credential.accessToken)")
        ]
        session.request(url, method: .put, parameters: body, encoding: JSONEncoding.default, headers: header){ (urlRequest: inout URLRequest) in
            urlRequest.timeoutInterval = self.timout
        }.response { response in
            print("http:res: \(response.debugDescription)")
            switch response.result {
            case .success(_):
                success()
            case .failure(let error):
                failed(0, error.errorDescription)
            }
        }
    }
    
    func refreshToken(completion: @escaping (Result<JWTCredential, Error>) -> Void) {
        FirebasePhoneAuth.getUser{ user in
            if user != nil {
                FirebasePhoneAuth.refreshToken() { token in
                    completion(.success(JWTCredential(accessToken: token, expiration: Date(timeIntervalSinceNow: 60 * 60))))
                }
            } else {
                //TODO: - Add refresh token when using twillio
            }
        }
    }
}
