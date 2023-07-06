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

    @Observable
    private (set) var currentProfile: Profile?

    @Observable
    private (set) var isProfileUpdating: Bool = false

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

    func toggleLikeNft(nftId: String, onCompletion: @escaping (Result<Profile, Error>) -> Void) {
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
        updateProfile(newProfile: newProfile, onCompletion: onCompletion)
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
        isProfileUpdating = true
        profileService.updateProfile(newProfile: newProfile) { [weak self] result in
            guard let self = self else { return }

            self.isProfileUpdating = false
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
