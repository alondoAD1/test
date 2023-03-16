//
//  NetworkingService.swift
//  test
//
//  Created by Ricardo Alonso Diaz Alvarado on 15/03/23.
//

import Foundation
import RxSwift

enum HTTPMethod: String {
    case GET = "GET"
    case HEAD = "HEAD"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case CONNECT = "CONNECT"
    case OPTIONS = "OPTIONS"
    case TRACE = "TRACE"
    case PATCH = "PATCH"
}

enum NetworkError: String, Error {
    case invalidURL
    case serializationFailed
    case generic
    case couldNotDecodeData
    case httpResponseError
    case statusCodeError = "Oucrrio un error al tratar de consultar el Api: status code"
    case jsonDecoder = "Error al intentar extraer datos del Json."
    case unauthorized
    case user_pass = "Invalid username and/or password. You did not provide a valid login."
}

class NetworkingService {
    
    public static var shared: NetworkingService = NetworkingService()
    private static let baseURL = "https://api.themoviedb.org/3/"
    
    static func request<T: Decodable>(endPoint: String,
                                      parameters: [String: Any]? = nil,
                                      model: T.Type,
                                      method: HTTPMethod) -> Observable<T> {
        
        return Observable.create { observer in
            
            guard let url = URL(string: baseURL+endPoint) else {
                return Disposables.create {
                    
                }
            }
            var json: [String: Any] = [:]
            json = ["api_key": "7662169d6cde796d24b257cd0f8a268e"]
            json = parameters ?? [:]
            let parameters = try? JSONSerialization.data(withJSONObject: json)
            var request = URLRequest(url: url)
            
            request.httpMethod = method.rawValue
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            if !(json.isEmpty) { request.httpBody = parameters }
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil, let response = response as? HTTPURLResponse
                else { return }
                
                if response.statusCode == 200 {
                    do {
                        let decoder = JSONDecoder()
                        let data = try decoder.decode(T.self, from: data)
                        observer.onNext(data)
                    } catch let error {
                        observer.onError(error)
                    }
                } else if response.statusCode == 401 {
                    print("Error 401")
                }
                
            }
            task.resume()
            
      
            
            return Disposables.create {
                task.cancel()
            }
        }
        
    }
    

    
}
