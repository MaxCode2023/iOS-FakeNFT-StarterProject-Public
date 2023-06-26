//
//  RatingViewModel.swift
//  FakeNFT
//
//  Created by macOS on 21.06.2023.
//

import Foundation

class RatingProfileViewModel {

    @Observable
    private(set) var user: User?

    @Observable
    private(set) var errorMessage: String?

    private let userService: UserService = UserServiceImpl()

    func getUser(userId: Int) {
        userService.getUser(userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.user = user
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

}
