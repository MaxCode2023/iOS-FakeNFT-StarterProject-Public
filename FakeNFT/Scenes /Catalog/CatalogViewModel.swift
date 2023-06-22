import Foundation

enum SortType {
    case name
    case count
}

final class CatalogViewModel {
    
    @Observable
    private(set) var alertModel: AlertModel?
    
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
}
