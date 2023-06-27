//
//  ProfileRepository.swift
//  FakeNFT
//
//  Created by Суворов Дмитрий Владимирович on 23.06.2023.
//

final class ProfileRepository {
    static let shared = ProfileRepository()

    private let profileService: ProfileService = ProfileService.shared
    private let nftService: NftService = NftServiceImpl.shared

    private var currentProfile: Profile?

    private init() {}

    func getProfile(onCompletion: @escaping (Result<Profile, Error>) -> Void) {
        profileService.getProfile { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let profile):
                self.currentProfile = profile
            case .failure:
                self.currentProfile = nil
            }
            onCompletion(result)
        }
    }

    func getMyNft(onCompletion: @escaping (Result<[Nft], Error>) -> Void) {
        guard let currentProfile = currentProfile else { return }
        let idNfts = currentProfile.nfts.map { nftString in Int(nftString) ?? -1 }
        nftService.getNftList(nftIds: idNfts, onCompletion: onCompletion)
    }

    func getFavoriteNft(onCompletion: @escaping (Result<[Nft], Error>) -> Void) {
        guard let currentProfile = currentProfile else { return }
        let idNfts = currentProfile.likes.map { nftString in Int(nftString) ?? -1 }
        nftService.getNftList(nftIds: idNfts, onCompletion: onCompletion)
    }

    func checkNftIsLiked(nft: Nft) -> Bool {
        guard let currentProfile = currentProfile else { return false }
        return currentProfile.likes.contains(nft.id)
    }
}
