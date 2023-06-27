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

    func onViewCreated() {
        getMyNftData()
    }

    private func getMyNftData() {
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
        myNftViewState = MyNftViewState.content(
            myNfts.map { myNft in
                NftView(nft: myNft, isLiked: self.profileRepository.checkNftIsLiked(nft: myNft))
            }
        )
    }
}
