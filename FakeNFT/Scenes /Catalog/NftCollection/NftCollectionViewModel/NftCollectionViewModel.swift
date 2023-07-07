import Foundation

final class NftCollectionViewModel {
    private let nftItemsService: NftItemService
    private let userService: UserService
    
    @Observable
    private(set) var nftItems: [NftItem] = []
    
    @Observable
    private(set) var user: User?
    
    @Observable
    private(set) var errorMessage: String? = nil
    
    @Observable
    private(set) var isLoading: Bool = false
    
    init(
        nftItemsService: NftItemService = NftItemService(),
        userService: UserService = UserService()
    ) {
        self.nftItemsService = nftItemsService
        self.userService = userService
    }
    
    func getNftItems() {
        isLoading = true
        nftItemsService.getNftItems(onCompletion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let nftItems):
                    self?.nftItems = nftItems
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
                
                self?.isLoading = false
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
