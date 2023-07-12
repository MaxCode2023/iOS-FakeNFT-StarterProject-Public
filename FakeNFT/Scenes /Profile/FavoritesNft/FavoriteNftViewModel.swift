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

    private var currentFavoriteNfts: [Nft] = []

    func onViewCreated() {
        getFavoriteNftData()
    }

    func onLikeTapped(nftView: NftView) {
        favoriteNftViewState = FavoriteNftViewState.loading
        profileRepository.toggleLikeNft(nftId: nftView.nft.id) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                let updatedFavoriteNfts = self.currentFavoriteNfts.filter { nft in nft.id != nftView.nft.id }
                self.resolveSuccessFavoriteNftData(favoriteNfts: updatedFavoriteNfts)
            case .failure:
                self.favoriteNftViewState = FavoriteNftViewState.error("Не удалось обновить данные NFT:(")
            }
        }
    }

    private func getFavoriteNftData() {
        favoriteNftViewState = FavoriteNftViewState.loading
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
            favoriteNftViewState = FavoriteNftViewState.placeholder("У вас ещё нет избранных NFT")
            return
        }
        currentFavoriteNfts = favoriteNfts
        favoriteNftViewState = FavoriteNftViewState.content(
            favoriteNfts.map { favoriteNft in
                NftView(nft: favoriteNft, isLiked: true)
            }
        )
    }
}
