import Foundation
import ProgressHUD

final class CatalogViewModel {
    private let nftCollectionsService: NftCollectionService = NftCollectionServiceImpl()
    
    @Observable
    private(set) var alertModel: AlertModel?
    
    @Observable
    private(set) var nftCollections: [NftCollection] = []
    
    @Observable
    private(set) var errorMessage: String? = nil
    
    init(alertModel: AlertModel?) {
        self.alertModel = alertModel
    }
    
    func getNftCollections() {
        UIBlockingProgressHUD.show()
        nftCollectionsService.getNftCollections(onCompletion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let nftCollections):
                    UIBlockingProgressHUD.dismiss()
                    self?.nftCollections = nftCollections
                case .failure(let error):
                    UIBlockingProgressHUD.dismiss()
                    self?.errorMessage = error.localizedDescription
                }
            }
        })
    }
    
    func showAlertToSort() {
        alertModel = createAlert()
    }
    
    private func createAlert() -> AlertModel {
        let alertModel = AlertModel(
            title: nil,
            message: "SORTING".localized,
            buttonTextFirst: "SORTING_BY_NAME".localized,
            completionFirst: { [weak self] _ in
                self?.sortByName()
            },
            buttonTextSecond: "SORTING_BY_COUNT".localized,
            completionSecond: { [weak self] _ in
                self?.sortByNFTCount()
            },
            cancelText: "CLOSE".localized,
            cancelCompletion: nil
        )
        
        return alertModel
    }
    
    private func sortByName() {
        nftCollections.sort { (collection1, collection2) in
            return collection1.name.localizedCaseInsensitiveCompare(collection2.name) == .orderedAscending
        }
    }

    private func sortByNFTCount() {
        nftCollections.sort { (collection1, collection2) in
            return collection1.nfts.count < collection2.nfts.count
        }
    }
}
