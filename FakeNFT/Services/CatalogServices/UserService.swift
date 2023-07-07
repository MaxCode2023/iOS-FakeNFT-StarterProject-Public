class UserService: UserProtocol {
    private let client = DefaultNetworkClient.shared
    
    func getUser(userId: String, onCompletion: @escaping (Result<User, Error>) -> Void) {
        let request = GetUserRequest(userId: userId)
        
        client.send(request: request, type: User.self, onResponse: onCompletion)
    }
}
