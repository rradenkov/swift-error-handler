struct TestError: Error {

}

enum NetworkError: Error {
    case timeout
    case invalidResponse
    case sessionExpired
    case invalidCredentials
}
