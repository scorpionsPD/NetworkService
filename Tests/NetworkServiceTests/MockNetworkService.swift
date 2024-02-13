
import Foundation
@testable import NetworkService

@available(iOS 13.0.0, *)
class MockNetworkService: NetworkServiceProtocol {
    var result: Result<Data, Error>
    
    init(result: Result<Data, Error>) {
        self.result = result
    }
    
    func request<T>(endpoint: URL) async throws -> T where T : Decodable {
        switch result {
        case .success(let data):
            // Attempt to decode the data into the expected Decodable type (T).
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        case .failure(let error):
            // Propagate the error.
            throw error
        }
    }
}


struct MockData: Decodable, Equatable {
    let id: Int
    let name: String
    
    static var sampleData: MockData {
        return MockData(id: 1, name: "Test")
    }
}
