//
//  NftView.swift
//  FakeNFT
//
//  Created by Суворов Дмитрий Владимирович on 26.06.2023.
//

enum MyNftViewState {
    case loading
    case placeholder(String)
    case content([NftView])
    case error(String)
}

struct NftView {
    let nft: Nft
    let isLiked: Bool
}
