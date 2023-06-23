//
//  ProfileViewState.swift
//  FakeNFT
//
//  Created by Суворов Дмитрий Владимирович on 23.06.2023.
//

enum ProfileViewState {
    
    struct ProfileData {
        let profile: Profile
    }
    
    case loading
    case content(ProfileData)
    case error(String)
}
