protocol NftCollectionProtocol {
    func getNftCollections(onCompletion: @escaping (Result<[NftCollection], Error>) -> Void)
}
