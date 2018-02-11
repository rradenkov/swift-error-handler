class ChildCoordinator: Coordinator {

    let errorHandler: MatcherErrorHandler

    init(errorHandler: ErrorHandler) {
        self.errorHandler = MatcherErrorHandler(parent: errorHandler)

        self.errorHandler.on(NetworkError.timeout) { error in
            print("Timeout")
            return true
        }

        self.errorHandler.onNoMatch(do: { error in
            print("Not handled: \(error)")
            return false
        })
    }

    func start() {

    }

    func throwUnknownError() {
        errorHandler.handle(TestError())
    }

    func throwCriticalError() {
        errorHandler.handle(NetworkError.sessionExpired)
    }

    func throwNetworkError() {
        errorHandler.handle(NetworkError.timeout)
    }
}
