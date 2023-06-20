//
//  UserService.swift
//  FakeNFT
//
//  Created by macOS on 20.06.2023.
//

import Foundation

protocol UserService {
    func getUserList(onCompletion: @escaping (Result<[User], Error>) -> Void)
    func getUser(userId: Int, onCompletion: @escaping (Result<User, Error>) -> Void)
}
