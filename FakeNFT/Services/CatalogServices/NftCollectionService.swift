protocol NftCollectionService {
    func getNftCollections(onCompletion: @escaping (Result<[NftCollection], Error>) -> Void)
    func getNftCollectionById(nftCollectionId: Int, onCompletion: @escaping (Result<NftCollection, Error>) -> Void)
}
