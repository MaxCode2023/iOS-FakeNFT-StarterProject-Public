//
//  UserService.swift
//  FakeNFT
//
//  Created by macOS on 22.06.2023.
//

protocol NftService {
    func getNft(nftId: Int, onCompletion: @escaping (Result<Nft, Error>) -> Void)
}
