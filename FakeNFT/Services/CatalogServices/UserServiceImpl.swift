class UserServiceImpl: UserService {
    private let client = DefaultNetworkClient()
    
    func getUser(userId: String, onCompletion: @escaping (Result<User, Error>) -> Void) {
        let request = GetUserRequest(userId: userId)
        
        client.send(request: request, type: User.self, onResponse: onCompletion)
    }
}
