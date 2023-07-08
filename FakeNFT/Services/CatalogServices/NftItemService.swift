class NftItemService: NftItemProtocol {
    private let client = DefaultNetworkClient.shared
    
    func getNftItems(onCompletion: @escaping (Result<[Nft], Error>) -> Void) {
        let request = GetNftItemsRequest()
        
        client.send(request: request, type: [Nft].self, onResponse: onCompletion)
    }
}
