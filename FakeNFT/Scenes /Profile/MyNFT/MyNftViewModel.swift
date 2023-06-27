//
//  MyNftViewModel.swift
//  FakeNFT
//
//  Created by Суворов Дмитрий Владимирович on 26.06.2023.
//

final class MyNftViewModel {
    private let profileRepository = ProfileRepository.shared

    @Observable
    private (set) var myNftViewState: MyNftViewState = MyNftViewState.loading

    private var currentMyNfts: [Nft] = []

    func onViewCreated() {
        getMyNftData()
    }

    func onLikeTapped(nftView: NftView) {
        myNftViewState = MyNftViewState.loading
        profileRepository.toggleLikeNft(nftId: nftView.nft.id) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                self.resolveSuccessMyNftData(myNfts: self.currentMyNfts)
            case .failure:
                self.myNftViewState = MyNftViewState.error("Не удалось обновить данные NFT:(")
            }
        }
    }

    private func getMyNftData() {
        myNftViewState = MyNftViewState.loading
        profileRepository.getMyNft { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let myNfts):
                self.resolveSuccessMyNftData(myNfts: myNfts)
            case .failure:
                self.myNftViewState = MyNftViewState.error("Не удалось загрузить данные об NFT:(")
            }
        }
    }

    private func resolveSuccessMyNftData(myNfts: [Nft]) {
        guard !myNfts.isEmpty else {
            myNftViewState = MyNftViewState.placeholder("У вас ещё нет NFT")
            return
        }
        currentMyNfts = myNfts
        myNftViewState = MyNftViewState.content(
            myNfts.map { myNft in
                NftView(nft: myNft, isLiked: self.profileRepository.checkNftIsLiked(nftId: myNft.id))
            }
        )
    }
}
