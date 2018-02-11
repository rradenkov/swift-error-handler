class RootCoordinator: Coordinator {

    lazy var errorHandler: ErrorHandler = {
        return ErrorHandler(action: self.handleError)
    }()

    init() {
        //errorHandler = ErrorHandler(action: handleError)
    }

    func start() {

    }

    private func handleError(_ error: Error) -> Bool {
        if let networkError = error as? NetworkError {
            switch networkError {
            case .sessionExpired:
                print("Session expired")
                return true
            case .invalidCredentials:
                print("Invalid credentials")
                return true
            default:
                return false
            }

        }

        return false
    }
}
