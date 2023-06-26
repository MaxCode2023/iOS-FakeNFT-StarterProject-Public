//
//  ProfileViewState.swift
//  FakeNFT
//
//  Created by Суворов Дмитрий Владимирович on 23.06.2023.
//

enum ProfileViewState {

    struct ProfileData {
        let name: String
        let description: String
        let avatar: String
        let website: String
        let cellTitles: [String]
    }

    case loading
    case content(ProfileData)
    case error(String)
}
