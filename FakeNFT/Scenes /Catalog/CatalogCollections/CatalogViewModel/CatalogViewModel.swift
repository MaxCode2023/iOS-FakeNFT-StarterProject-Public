import Foundation

final class CatalogViewModel {
    private let nftCollectionsService: NftCollectionService
    
    @Observable
    private(set) var alertModel: AlertModel?
    
    @Observable
    private(set) var nftCollections: [NftCollection] = []
    
    @Observable
    private(set) var errorMessage: String? = nil
    
    @Observable
    private(set) var isLoading: Bool = false
    
    init(
        alertModel: AlertModel?,
        nftCollectionsService: NftCollectionService = NftCollectionService()
    ) {
        self.alertModel = alertModel
        self.nftCollectionsService = nftCollectionsService
    }
    
    func getNftCollections() {
        isLoading = true
        nftCollectionsService.getNftCollections(onCompletion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let nftCollections):
                    self?.nftCollections = nftCollections
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
                
                self?.isLoading = false
            }
        })
    }
    
    func showAlertToSort() {
        alertModel = createAlert()
    }
    
    private func createAlert() -> AlertModel {
        let alertModel = AlertModel(
            title: nil,
            message: "catalog.catalog_vc.sorting".localized,
            buttonTextFirst: "catalog.catalog_vc.by_name".localized,
            completionFirst: { [weak self] _ in
                self?.sortByName()
            },
            buttonTextSecond: "catalog.catalog_vc.by_count".localized,
            completionSecond: { [weak self] _ in
                self?.sortByNFTCount()
            },
            cancelText: "catalog.catalog_vc.close".localized,
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
