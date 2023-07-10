class NftCollectionService: NftCollectionProtocol {
    private let client = DefaultNetworkClient.shared
    
    func getNftCollections(onCompletion: @escaping (Result<[NftCollection], Error>) -> Void) {
        let request = GetNftCollectionsRequest()
        
        client.send(request: request, type: [NftCollection].self, onResponse: onCompletion)
    }
}
