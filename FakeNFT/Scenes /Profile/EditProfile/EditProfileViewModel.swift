//
//  EditProfileViewModel.swift
//  FakeNFT
//
//  Created by Суворов Дмитрий Владимирович on 30.06.2023.
//

final class EditProfileViewModel {
    private let profileRepository = ProfileRepository.shared

    private let currentProfile: Profile?

    private var newName: String = ""
    private var newDescription: String = ""
    private var newAvatar: String = ""
    private var newWebsite: String = ""

    @Observable
    private (set) var editProfileViewState: EditProfileViewState?

    init() {
        self.currentProfile = profileRepository.currentProfile
    }

    func onViewDidLoad() {
        loadCurrentProfileData()
    }

    func onViewWillDisappear() {
        guard let currentProfile = currentProfile else { return }
        let nameChange = newName != currentProfile.name
        let descriptionChange = newDescription != currentProfile.description
        let avatarChange = newAvatar != currentProfile.avatar && newAvatar.isValidURL
        let websiteChange = newWebsite != currentProfile.website && newWebsite.isValidURL

        let needUpdate = nameChange || descriptionChange || avatarChange || websiteChange

        if needUpdate {
            safeUpdateProfile()
        }
    }

    func updateName(newName: String?) {
        guard let newName = newName else { return }
        self.newName = newName
    }

    func updateDescription(newDescription: String?) {
        guard let newDescription = newDescription else { return }
        self.newDescription = newDescription
    }

    func updateAvatar(newAvatar: String?) {
        guard let newAvatar = newAvatar, newAvatar.isValidURL else { return }
        self.newAvatar = newAvatar

        // обвноляем UI аватарки
        if let currentProfile {
            let editProfileData = EditProfileViewState.EditProfileData(
                name: currentProfile.name,
                description: currentProfile.description,
                avatar: newAvatar,
                website: currentProfile.website
            )
            editProfileViewState = EditProfileViewState.content(editProfileData)
        }
    }

    func updateWebsite(newWebsite: String?) {
        guard let newWebsite = newWebsite else { return }
        self.newWebsite = newWebsite
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
        newName = currentProfile.name
        newDescription = currentProfile.description
        newAvatar = currentProfile.avatar
        newWebsite = currentProfile.website
    }

    private func safeUpdateProfile() {
        guard let currentProfile else { return }
        var safeNewAvatar = newAvatar
        if !newAvatar.isValidURL {
            safeNewAvatar = currentProfile.avatar
        }
        var safeWebsite = newWebsite
        if !newWebsite.isValidURL {
            safeWebsite = currentProfile.website
        }
        let newProfile = Profile(
            id: currentProfile.id,
            name: newName,
            description: newDescription,
            avatar: safeNewAvatar,
            website: safeWebsite,
            nfts: currentProfile.nfts,
            likes: currentProfile.likes
        )
        profileRepository.updateProfile(newProfile: newProfile) { _ in }
    }
}
