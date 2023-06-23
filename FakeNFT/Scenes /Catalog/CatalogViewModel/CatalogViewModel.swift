import Foundation
import ProgressHUD

enum SortType {
    case name
    case count
}

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
    
    func showAlertToSort() {
        let alertModel = AlertModel(
            title: nil,
            message: "SORTING".localized,
            buttonTextFirst: "SORTING_BY_NAME".localized,
            completionFirst: { [weak self] _ in
                self?.sort()
            },
            buttonTextSecond: "SORTING_BY_COUNT".localized,
            completionSecond: { [weak self] _ in
                self?.sort()
            },
            cancelText: "CLOSE".localized,
            cancelCompletion: nil
        )
        
        self.alertModel = alertModel
    }
    
    private func sort() {
        
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
}
