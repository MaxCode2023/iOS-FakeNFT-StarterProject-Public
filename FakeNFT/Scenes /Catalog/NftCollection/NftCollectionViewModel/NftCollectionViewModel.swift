import Foundation

final class NftCollectionViewModel {
    private let nftItemsService: NftItemService = NftItemServiceImpl()
    
    @Observable
    private(set) var nftItems: [NftItem] = []
    
    @Observable
    private(set) var errorMessage: String? = nil
    
    func getNftItems() {
        UIBlockingProgressHUD.show()
        nftItemsService.getNftItems(onCompletion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let nftItems):
                    UIBlockingProgressHUD.dismiss()
                    self?.nftItems = nftItems
                case .failure(let error):
                    UIBlockingProgressHUD.dismiss()
                    self?.errorMessage = error.localizedDescription
                }
            }
        })
    }
}
