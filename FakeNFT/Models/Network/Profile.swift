//
//  Profile.swift
//  FakeNFT
//
//  Created by Суворов Дмитрий Владимирович on 23.06.2023.
//

struct Profile: Decodable {
    let id: String
    let name: String
    let description: String
    let avatar: String
    let website: String
    let nfts: [String]
    let likes: [String]
}
