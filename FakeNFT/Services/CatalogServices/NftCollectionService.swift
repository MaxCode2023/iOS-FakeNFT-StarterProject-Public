protocol NftCollectionService {
    func getNftCollections(onCompletion: @escaping (Result<[NftCollection], Error>) -> Void)
}
