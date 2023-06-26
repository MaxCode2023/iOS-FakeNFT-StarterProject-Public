import Foundation

final class NftCollectionViewModel {
    private let nftItemsService: NftItemService = NftItemServiceImpl()
    private let userService: UserService = UserServiceImpl()
    
    @Observable
    private(set) var nftItems: [NftItem] = []
    
    @Observable
    private(set) var user: User?
    
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
    
    func getUser(userId: String) {
        userService.getUser(userId: userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.user = user
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
