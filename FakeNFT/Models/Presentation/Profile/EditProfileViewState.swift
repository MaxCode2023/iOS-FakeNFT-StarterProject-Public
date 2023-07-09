//
//  EditProfileViewState.swift
//  FakeNFT
//
//  Created by Суворов Дмитрий Владимирович on 05.07.2023.
//

enum EditProfileViewState {

    struct EditProfileData {
        let name: String
        let description: String
        let avatar: String
        let website: String
    }

    case content(EditProfileData)
}
