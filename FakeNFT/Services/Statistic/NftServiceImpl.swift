//
//  UserServiceImpl.swift
//  FakeNFT
//
//  Created by macOS on 22.06.2023.
//

class NftServiceImpl: NftService {
    
    private let client = DefaultNetworkClient()
    
    func getNft(nftId: Int, onCompletion: @escaping (Result<Nft, Error>) -> Void) {
        let request = GetNftRequest(userId: nftId)
        
        client.send(request: request, type: Nft.self, onResponse: onCompletion)
    }
    
}
