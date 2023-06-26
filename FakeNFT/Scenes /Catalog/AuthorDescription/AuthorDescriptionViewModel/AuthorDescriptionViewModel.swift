import Foundation

final class AuthorDescriptionViewModel {
    private let userService: UserService = UserServiceImpl()
    
    @Observable
    private(set) var user: User?
    
    @Observable
    private(set) var errorMessage: String? = nil
    
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
