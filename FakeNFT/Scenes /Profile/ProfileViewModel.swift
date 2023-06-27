//
//  ProfileViewModel.swift
//  FakeNFT
//
//  Created by Суворов Дмитрий Владимирович on 23.06.2023.
//

final class ProfileViewModel {
    private let profileRepository = ProfileRepository.shared

    @Observable
    private (set) var profileViewState: ProfileViewState = ProfileViewState.loading

    func onViewCreated() {
        getProfileData()
    }

    private func getProfileData() {
        profileViewState = ProfileViewState.loading
        profileRepository.getProfile { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let profile):
                self.resolveUpdatedProfileInfo(profile: profile)
                self.observeFutherProfileUpdates()
            case .failure:
                self.profileViewState = ProfileViewState.error("Не удалось загрузить данные профиля:(")
            }
        }
    }

    private func observeFutherProfileUpdates() {
        profileRepository.$currentProfile.bind { [weak self] profile in
            guard let self = self, let profile = profile else { return }
            self.resolveUpdatedProfileInfo(profile: profile)
        }
    }

    private func resolveUpdatedProfileInfo(profile: Profile) {
        profileViewState = ProfileViewState.content(.init(
            name: profile.name,
            description: profile.description,
            avatar: profile.avatar,
            website: profile.website,
            cellTitles: [
                "Мои NFT (\(profile.nfts.count))", "Избранные NFT (\(profile.likes.count))", "О разработчике"
            ]
        ))
    }
}
