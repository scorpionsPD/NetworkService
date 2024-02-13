# NetworkService

** NetworkServicePackage ** 

NetworkServicePackage is a Swift package that provides an easy-to-use, generic network service for fetching and decoding data from RESTful APIs. It leverages Swift's powerful async/await syntax and generics to simplify network calls and data decoding in your Swift applications.

Features

Generic network service capable of fetching and decoding any Decodable type.
Simple and clean API to make network requests with minimal boilerplate.
Built-in error handling through the use of a custom NetworkError enum.
Utilizes Swift 5's async/await for clear and concise asynchronous code.
Installation

To add NetworkServicePackage to your Swift project, edit your Package.swift file and add the following dependency:

** Installation

To add NetworkServicePackage to your Swift project, edit your Package.swift file and add the following dependency:

dependencies: [
    .package(url: "https://github.com/scorpionsPD/NetworkServicePackage.git", .upToNextMajor(from: "1.0.0"))
]

Then, add NetworkServicePackage to your target dependencies:

targets: [
    .target(
        name: "YourTargetName",
        dependencies: ["NetworkService"]),
]

** Usage

Making a Request
First, define a model that conforms to the Decodable protocol:

struct DataItem: Decodable {
    let id: Int
    let name: String
}
Next, use the NetworkService to fetch data:

import NetworkServicePackage

@MainActor
class DataItemViewModel: ObservableObject {
    @Published var dataItems: [DataItem] = []
    @Published var networkError: NetworkError?

    private let networkService = NetworkService()

    func loadData() {
        guard let url = URL(string: "https://api.example.com/data") else {
            self.networkError = .invalidURL
            return
        }

        Task {
            do {
                let items: [DataItem] = try await networkService.request(endpoint: url)
                self.dataItems = items
            } catch let error as NetworkError {
                self.networkError = error
            } catch {
                self.networkError = .unknownError(description: error.localizedDescription)
            }
        }
    }
}
** Error Handling
NetworkService uses the NetworkError enum for error handling:

public enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError
    case unknownError(description: String)
}
Handle errors in your application logic as shown in the usage example above.

** Contributions

Contributions are welcome! Please submit a pull request or create an issue for any features or improvements.
