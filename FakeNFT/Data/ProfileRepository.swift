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
    private var currentMyNft: [Nft] = []

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

    func toggleLikeNft(nftId: String, onCompletion: @escaping (Result<[Nft], Error>) -> Void) {
        guard let currentProfile = currentProfile else { return }
        let isNeedLike = !checkNftIsLiked(nftId: nftId)
        var currentlikes = currentProfile.likes
        if isNeedLike { currentlikes.append(nftId) } else { currentlikes.removeAll { $0 == nftId } }

        let newProfile = Profile(
            id: currentProfile.id,
            name: currentProfile.name,
            description: currentProfile.description,
            avatar: currentProfile.avatar,
            website: currentProfile.website,
            nfts: currentProfile.nfts,
            likes: currentlikes
        )
        updateProfile(newProfile: newProfile) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                // По успешному обновлению лайка возвращаем во ViewModel кэшированные Nft так как они не поменялись
                // Изначально попробовал по успешному состоянию запрашивать NFT заново, но часто 429 стреляла и + лишняя нагрузка на сеть
                onCompletion(.success(self.currentMyNft))
            case .failure(let error):
                onCompletion(.failure(error))
            }
        }
    }

    func getMyNft(onCompletion: @escaping (Result<[Nft], Error>) -> Void) {
        guard let currentProfile = currentProfile else { return }
        let idNfts = currentProfile.nfts.map { nftString in Int(nftString) ?? -1 }
        nftService.getNftList(nftIds: idNfts) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let nfts):
                self.currentMyNft = nfts
            case .failure:
                self.currentMyNft = []
            }
            onCompletion(result)
        }
    }

    func getFavoriteNft(onCompletion: @escaping (Result<[Nft], Error>) -> Void) {
        guard let currentProfile = currentProfile else { return }
        let idNfts = currentProfile.likes.map { nftString in Int(nftString) ?? -1 }
        nftService.getNftList(nftIds: idNfts, onCompletion: onCompletion)
    }

    func checkNftIsLiked(nftId: String) -> Bool {
        guard let currentProfile = currentProfile else { return false }
        return currentProfile.likes.contains(nftId)
    }

    func updateProfile(onCompletion: @escaping (Result<Profile, Error>) -> Void, mutateProfile: (Profile) -> Profile) {
        guard let currentProfile = currentProfile else { return }
        let newProfile = mutateProfile(currentProfile)
        updateProfile(newProfile: newProfile, onCompletion: onCompletion)
    }

    func updateProfile(newProfile: Profile, onCompletion: @escaping (Result<Profile, Error>) -> Void) {
        profileService.updateProfile(newProfile: newProfile) { [weak self] result in
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
}
