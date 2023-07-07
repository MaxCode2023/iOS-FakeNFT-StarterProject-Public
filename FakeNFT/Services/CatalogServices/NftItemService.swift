class NftItemService: NftItemProtocol {
    private let client = DefaultNetworkClient.shared
    
    func getNftItems(onCompletion: @escaping (Result<[NftItem], Error>) -> Void) {
        let request = GetNftItemsRequest()
        
        client.send(request: request, type: [NftItem].self, onResponse: onCompletion)
    }
}
