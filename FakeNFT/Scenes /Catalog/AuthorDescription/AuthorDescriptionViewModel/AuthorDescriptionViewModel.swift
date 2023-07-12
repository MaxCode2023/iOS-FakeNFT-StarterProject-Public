import Foundation

final class AuthorDescriptionViewModel {
    private let userService: UserService
    
    @Observable
    private(set) var user: User?
    
    @Observable
    private(set) var errorMessage: String? = nil
    
    @Observable
    private(set) var isLoading: Bool = false
    
    init(userService: UserService = UserService()) {
        self.userService = userService
    }
    
    func getUser(userId: String) {
        isLoading = true
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
    
    func finishLoading() {
        isLoading = false
    }
}
