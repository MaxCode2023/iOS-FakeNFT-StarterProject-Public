//
//  ProfileViewModel.swift
//  FakeNFT
//
//  Created by Суворов Дмитрий Владимирович on 23.06.2023.
//
import Foundation

final class ProfileViewModel {
    private let profileRepository = ProfileRepository.shared

    @Observable
    private (set) var profileViewState: ProfileViewState = ProfileViewState.loading

    @Observable
    private (set) var profileViewRoute: ProfileViewRoute?

    private var currentProfile: Profile?

    func onViewCreated() {
        getProfileData()
    }

    func onUrlButtonClick() {
        guard let currentProfile = currentProfile,
              let url = URL(string: currentProfile.website) else { return }

        profileViewRoute = ProfileViewRoute.toUrl(url)
    }

    func onEditButtonClick() {
        profileViewRoute = ProfileViewRoute.toEdit
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
        profileRepository.$isProfileUpdating.bind { [weak self] isUpdating in
            guard let self = self else { return }
            if isUpdating {
                self.profileViewState = ProfileViewState.loading
            }
        }
    }

    private func resolveUpdatedProfileInfo(profile: Profile) {
        self.currentProfile = profile
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
