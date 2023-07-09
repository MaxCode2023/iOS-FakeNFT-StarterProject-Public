protocol NftItemProtocol {
    func getNftItems(onCompletion: @escaping (Result<[Nft], Error>) -> Void)
}
