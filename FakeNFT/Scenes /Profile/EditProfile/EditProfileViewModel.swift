//
//  EditProfileViewModel.swift
//  FakeNFT
//
//  Created by Суворов Дмитрий Владимирович on 30.06.2023.
//

final class EditProfileViewModel {
    private let profileRepository = ProfileRepository.shared

    private let currentProfile: Profile?

    @Observable
    private (set) var editProfileViewState: EditProfileViewState?

    init() {
        self.currentProfile = profileRepository.currentProfile
    }

    func onViewDidLoad() {
        loadCurrentProfileData()
    }

    func updateName(newName: String?) {
        print("\(newName)")
    }

    func updateDescription(newDescription: String?) {
        print("\(newDescription)")
    }

    func updateAvatar(newAvatar: String?) {
        print("\(newAvatar)")
    }

    func updateWebsite(newWebsite: String?) {
        print("\(newWebsite)")
    }

    private func loadCurrentProfileData() {
        guard let currentProfile else { return }
        let editProfileData = EditProfileViewState.EditProfileData(
            name: currentProfile.name,
            description: currentProfile.description,
            avatar: currentProfile.avatar,
            website: currentProfile.website
        )
        editProfileViewState = EditProfileViewState.content(editProfileData)
    }
}
