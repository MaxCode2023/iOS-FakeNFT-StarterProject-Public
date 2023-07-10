import Foundation

struct GetNftCollectionsRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "https://648cbc238620b8bae7ed51a1.mockapi.io/api/v1/collections")
    }
    var httpMethod: HttpMethod {
        .get
    }
}
