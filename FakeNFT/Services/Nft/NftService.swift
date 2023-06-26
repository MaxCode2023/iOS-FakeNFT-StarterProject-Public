//
//  UserService.swift
//  FakeNFT
//
//  Created by macOS on 22.06.2023.
//

protocol NftService {
    func getNftList(nftIds: [Int], onCompletion: @escaping (Result<[Nft], Error>) -> Void)
    func getNft(nftId: Int, onCompletion: @escaping (Result<Nft, Error>) -> Void)
}
