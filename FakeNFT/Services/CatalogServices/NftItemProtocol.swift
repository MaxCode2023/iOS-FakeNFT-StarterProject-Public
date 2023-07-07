protocol NftItemProtocol {
    func getNftItems(onCompletion: @escaping (Result<[NftItem], Error>) -> Void)
}
