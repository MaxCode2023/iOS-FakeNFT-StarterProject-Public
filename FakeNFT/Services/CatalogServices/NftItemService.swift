protocol NftItemService {
    func getNftItems(onCompletion: @escaping (Result<[NftItem], Error>) -> Void)
}
