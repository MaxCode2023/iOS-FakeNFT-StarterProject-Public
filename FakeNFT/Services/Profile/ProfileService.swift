//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Суворов Дмитрий Владимирович on 23.06.2023.
//

final class ProfileService {
    static let shared = ProfileService()
    
    private let client = DefaultNetworkClient()
    
    private init() {}

    func getProfile(onCompletion: @escaping (Result<Profile, Error>) -> Void) {
        let request = GetProfileRequest()
        
        client.send(request: request, type: Profile.self, onResponse: onCompletion)
    }
}
