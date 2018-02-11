let string = "Test string"
print(string)

/*
let rootHandler = ErrorHandler()

let middleHandler = ErrorHandler(action: { error in
    print("Error: \(error)")
    return true
}, parent: rootHandler)

middleHandler.handle(NetworkError.sessionExpired)
*/

let rootCoordinator = RootCoordinator()

let childCoordinator = ChildCoordinator(errorHandler: rootCoordinator.errorHandler)

childCoordinator.throwCriticalError()
print("===========")
childCoordinator.throwNetworkError()
print("===========")
childCoordinator.throwUnknownError()
