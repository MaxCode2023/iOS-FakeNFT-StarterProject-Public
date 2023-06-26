//
//  FavoriteNftViewModel.swift
//  FakeNFT
//
//  Created by Суворов Дмитрий Владимирович on 26.06.2023.
//

final class FavoriteNftViewModel {
    private let profileRepository = ProfileRepository.shared
    
    @Observable
    private (set) var favoriteNftViewState: FavoriteNftViewState = FavoriteNftViewState.loading

    func onViewCreated() {
        getFavoriteNftData()
    }

    private func getFavoriteNftData() {
        profileRepository.getMyNft { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let favoriteNfts):
                self.resolveSuccessFavoriteNftData(favoriteNfts: favoriteNfts)
            case .failure:
                self.favoriteNftViewState = FavoriteNftViewState.error("Не удалось загрузить данные об NFT:(")
            }
        }
    }
    
    private func resolveSuccessFavoriteNftData(favoriteNfts: [Nft]) {
        guard !favoriteNfts.isEmpty else {
            favoriteNftViewState = FavoriteNftViewState.placeholder("У вас ещё избранных NFT")
            return
        }
        favoriteNftViewState = FavoriteNftViewState.content(
            favoriteNfts.map { favoriteNft in
                NftView(nft: favoriteNft, isLiked: true)
            }
        )
    }
}
