import XCTest
@testable import NetworkService

@available(iOS 13.0.0, *)
final class NetworkServiceTests: XCTestCase {
    
    func testSuccessfulRequest() async {
        // Prepare the JSON string that represents your model.
        let jsonString = """
        {
            "id": 1,
            "name": "Test"
        }
        """
        // Convert the JSON string to Data.
        guard let jsonData = jsonString.data(using: .utf8) else {
            XCTFail("Failed to convert JSON string to Data")
            return
        }

        // Use the jsonData for your mock result.
        let networkService = MockNetworkService(result: .success(jsonData))

        do {
            // Attempt to fetch the data using the mocked service.
            let result: MockData = try await networkService.request(endpoint: URL(string: "https://example.com")!)
            XCTAssertEqual(result.id, 1)
            XCTAssertEqual(result.name, "Test")
        } catch {
            XCTFail("Expected successful request, received error: \(error)")
        }
    }

    
    func testRequestWithInvalidURL() async {
        let networkService = NetworkService()
        do {
            let _: MockData = try await networkService.request(endpoint: URL(string: "htp://invalid-url")!)
            XCTFail("Request with invalid URL should fail")
        } catch NetworkError.invalidURL {
            // Expected outcome
        } catch {
            XCTFail("Expected invalid URL error, received \(error)")
        }
    }
    
    func testDecodingError() async {
        let networkService = MockNetworkService(result: .success(Data()))
        do {
            let _: MockData = try await networkService.request(endpoint: URL(string: "https://example.com")!)
            XCTFail("Expected decoding error")
        } catch NetworkError.decodingError {
            // Expected outcome
        } catch {
            XCTFail("Expected decoding error, received \(error)")
        }
    }
}
