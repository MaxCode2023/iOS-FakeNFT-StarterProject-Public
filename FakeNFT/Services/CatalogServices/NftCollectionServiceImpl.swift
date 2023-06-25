class NftCollectionServiceImpl: NftCollectionService {
    private let client = DefaultNetworkClient()
    
    func getNftCollections(onCompletion: @escaping (Result<[NftCollection], Error>) -> Void) {
        let request = GetNftCollectionsRequest()
        
        client.send(request: request, type: [NftCollection].self, onResponse: onCompletion)
    }
}
