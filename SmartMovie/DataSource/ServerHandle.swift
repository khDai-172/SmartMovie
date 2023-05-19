//
//  ServerHandle.swift
//  SmartMovie
//
//  Created by Khoa Dai on 31/03/2023.
//

import Foundation
import UIKit

protocol ServerCallingProtocol {
    func fetchAPIFromURL(_ url: String, completionHandler: @escaping (String?, String?) -> Void)
    func downloadImageFromURL(_ url: URL, completionHandler: @escaping (UIImage?, String?) -> Void)
}

enum APIError: Error {
    case failedTogetData
}

class ServerCalling {
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?
    var downloadTask: URLSessionDownloadTask?
}

extension ServerCalling: ServerCallingProtocol {
    func fetchAPIFromURL(_ url: String, completionHandler: @escaping (String?, String?) -> Void) {
        guard let url = URL(string: url) else {
            completionHandler(nil, "URL incorrect")
            return
        }
        dataTask = defaultSession.dataTask(with: url) { (data, response, error) in
            if let error = error?.localizedDescription {
                completionHandler(nil, error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completionHandler(nil, "Server failed")
                return
            }
            guard let data = data else {
                return
            }
            let string = String(data: data, encoding: .utf8)
            completionHandler(string, nil)
        }
        dataTask?.resume()
    }
    
    func downloadImageFromURL(_ url: URL, completionHandler: @escaping (UIImage?, String?) -> Void) {
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: Constant.timeOutInterval)
        downloadTask = defaultSession.downloadTask(with: request, completionHandler: { (localURL, response, error) in
            if let imageURL = localURL {
                do {
                    let imageData = try Data(contentsOf: imageURL)
                    if let image = UIImage(data: imageData) {
                        completionHandler(image, nil)
                    } else {
                        completionHandler(nil, "Error")
                    }
                } catch let error {
                    completionHandler(nil, error.localizedDescription)
                }
            } else {
                completionHandler(nil, "Error")
            }
        })
        downloadTask?.resume()
    }
    
    func fetchPopularMovie(currentPage: Int, completion: @escaping (Result<[MovieEntity], Error>) -> Void) {
        guard let url = URL(string: "\(Constant.baseURL)movie/popular?api_key=\(Constant.APIKey)&page=\(currentPage)") else { return }
        dataTask = defaultSession.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let popularList = try JSONDecoder().decode(MovieDataBase.self, from: data)
                completion(.success(popularList.results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        dataTask?.resume()
    }
    
    func fetchTopratedMovie(currentPage: Int, completion: @escaping (Result<[MovieEntity], Error>) -> Void) {
        guard let url = URL(string: "\(Constant.baseURL)movie/top_rated?api_key=\(Constant.APIKey)&page=\(currentPage)") else { return }
        dataTask = defaultSession.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let topratedList = try JSONDecoder().decode(MovieDataBase.self, from: data)
                completion(.success(topratedList.results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        dataTask?.resume()
    }
    
    func fetchUpcomingMovie(currentPage: Int, completion: @escaping (Result<[MovieEntity], Error>) -> Void) {
        guard let url = URL(string: "\(Constant.baseURL)movie/upcoming?api_key=\(Constant.APIKey)&page=\(currentPage)") else { return }
        dataTask = defaultSession.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let upcomingList = try JSONDecoder().decode(MovieDataBase.self, from: data)
                completion(.success(upcomingList.results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        dataTask?.resume()
    }
    
    func fetchNowplayingMovie(currentPage: Int, completion: @escaping (Result<[MovieEntity], Error>) -> Void) {
        guard let url = URL(string: "\(Constant.baseURL)movie/now_playing?api_key=\(Constant.APIKey)&page=\(currentPage)") else { return }
        dataTask = defaultSession.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let nowplayingList = try JSONDecoder().decode(MovieDataBase.self, from: data)
                completion(.success(nowplayingList.results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        dataTask?.resume()
    }
    
    func fetchSearchData(query: String, completion: @escaping (Result<[MovieEntity], Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constant.baseURL)search/movie?api_key=\(Constant.APIKey)&query=\(query)") else { return }
        print(url)
        dataTask = defaultSession.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(MovieDataBase.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        dataTask?.resume()
    }
    func fetchMovieDetails(movieId: Int, completion: @escaping (Result<MovieEntity, Error>) -> Void) {
        guard let detailURL = URL(string: "\(Constant.baseURL)movie/\(movieId)?api_key=\(Constant.APIKey)") else { return }
        dataTask = defaultSession.dataTask(with: URLRequest(url: detailURL)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let movieDetail = try JSONDecoder().decode(MovieEntity.self, from: data)
                completion(.success(movieDetail))
            } catch {
                print(error)
            }
        }
        self.dataTask?.resume()
    }
    
    func fetchGenres(completion: @escaping (Result<[Genre], Error>) -> Void) {
        guard let url = URL(string: "\(Constant.baseURL)genre/movie/list?api_key=\(Constant.APIKey)&language=en-US") else { return }
        dataTask = defaultSession.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let genreList = try JSONDecoder().decode(MovieGenre.self, from: data)
                completion(.success(genreList.genres))
            } catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        dataTask?.resume()
    }
    
    
}
