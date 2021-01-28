//
//  ApiService.swift
//  Movee
//
//  Created by jjurlits on 10/27/20.
//

import Foundation


class ApiService {
    enum NetworkError: Error {
        case badResponse(Int)
        case emptyResponse
        //case jsonParsingFailed(Error)
        case noData
        case badUrl
        case badRequest
    }
    
    @discardableResult
    func fetch<T: Decodable>(
        url: URL?,
        completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTask? {
        guard let url = url else { return nil }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            //sleep(1)
            if let error = error {
                print(error)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.emptyResponse))
                }
                return
            }
            
            if response.statusCode != 200 {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.badResponse(response.statusCode)))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.emptyResponse))
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let object = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(object))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
        return task
    }

    
    @discardableResult
    func fetch<T: Decodable>(urlString: String,
                            completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTask? {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.badUrl))
            return nil
        }
        
       return fetch(url: url, completion: completion)
    }
    
//
//    func taskForGETRequest<ResponseType: Decodable>(
//        url: URL,
//        responseType: ResponseType.Type,
//        completion: @escaping (Result<ResponseType, NetworkError>) -> Void
//    ) -> URLSessionDataTask {
//        let task = URLSession.shared.dataTask(with: url) {
//            (data, response, error) in
//
//            if let networkError = error as? NetworkError {
//                DispatchQueue.main.async {
//                    completion(.failure(networkError))
//                }
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse else {
//                DispatchQueue.main.async {
//                    completion(.failure(.emptyResponse))
//                }
//                return
//            }
//
//            if response.statusCode != 200 {
//                DispatchQueue.main.async {
//                    completion(.failure(.badResponse(response.statusCode)))
//                }
//                return
//            }
//
//            guard let data = data else {
//                DispatchQueue.main.async {
//                    completion(.failure(.emptyResponse))
//                }
//                return
//            }
//
//            let decoder = JSONDecoder()
//
//            do {
//                let responseObject = try decoder.decode(ResponseType.self, from: data)
//                DispatchQueue.main.async {
//                    completion(.success(responseObject))
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(.failure(.jsonParsingFailed(error)))
//                }
//            }
//        }
//        return task
//    }

}
