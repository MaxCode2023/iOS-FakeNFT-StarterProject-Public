//
//  ProfileRepository.swift
//  FakeNFT
//
//  Created by Суворов Дмитрий Владимирович on 23.06.2023.
//

final class ProfileRepository {
    static let shared = ProfileRepository()
    
    private let profileService = ProfileService.shared
    
    private init() {}
    
    func getProfile(onCompletion: @escaping (Result<Profile, Error>) -> Void) {
        return profileService.getProfile(onCompletion: onCompletion)
    }
}
