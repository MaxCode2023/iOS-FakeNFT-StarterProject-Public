protocol UserService {
    func getUser(userId: String, onCompletion: @escaping (Result<User, Error>) -> Void)
}
