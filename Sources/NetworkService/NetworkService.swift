//
//  NetworkService.swift
//  chartsData
//
//  Created by Pradeep Dahiya on 12/02/2024.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError
    case unknownError(description: String)
}


@available(iOS 13.0.0, *)
public protocol NetworkServiceProtocol {
    func request<T: Decodable>(endpoint: URL) async throws -> T
}

@available(iOS 13.0.0, *)
public class NetworkService: NetworkServiceProtocol {
    public func request<T: Decodable>(endpoint: URL) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(from: endpoint)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            guard httpResponse.statusCode == 200 else {
                print("HTTP Error: Status code \(httpResponse.statusCode)")
                print("Response: \(String(describing: String(data: data, encoding: .utf8)))")
                throw NetworkError.requestFailed(URLError(.badServerResponse))
            }

            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                return decodedData
            } catch {
                print("Decoding Error: \(error)")
                throw NetworkError.decodingError
            }
        } catch {
            print("Network Error: \(error)")
            throw NetworkError.unknownError(description: error.localizedDescription)
        }

    }
}
