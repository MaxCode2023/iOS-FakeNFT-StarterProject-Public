//
//  UserServiceImpl.swift
//  FakeNFT
//
//  Created by macOS on 22.06.2023.
//

import Foundation

class NftServiceImpl: NftService {
    static let shared = NftServiceImpl()

    private let client = DefaultNetworkClient()
    
    private init() { }

    func getNftList(nftIds: [Int], onCompletion: @escaping (Result<[Nft], Error>) -> Void) {
        var nfts: [Nft] = []
        let group = DispatchGroup()

        for nftId in nftIds {
            group.enter()
            getNft(nftId: nftId) { result in
                switch result {
                case .success(let nft):
                    nfts.append(nft)
                case .failure(let error):
                    onCompletion(.failure(error))
                    return
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            onCompletion(.success(nfts))
        }
    }

    func getNft(nftId: Int, onCompletion: @escaping (Result<Nft, Error>) -> Void) {
        let request = GetNftRequest(nftId: nftId)

        client.send(request: request, type: Nft.self, onResponse: onCompletion)
    }

}
