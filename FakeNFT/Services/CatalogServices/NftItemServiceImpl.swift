class NftItemServiceImpl: NftItemService {
    private let client = DefaultNetworkClient()
    
    func getNftItems(onCompletion: @escaping (Result<[NftItem], Error>) -> Void) {
        let request = GetNftItemsRequest()
        
        client.send(request: request, type: [NftItem].self, onResponse: onCompletion)
    }
}
