public typealias ErrorHandleAction = (Error) -> (Bool)

public protocol ErrorHandlable {
    func handle(_: Error)
}

public class ErrorHandler: ErrorHandlable {

    private var parent: ErrorHandler?
    private let action: ErrorHandleAction

    convenience init(action: @escaping ErrorHandleAction = { error in return false }) {
        self.init(action: action, parent: nil)
    }

    init(action: @escaping ErrorHandleAction, parent: ErrorHandler? = nil) {
        self.action = action
        self.parent = parent
    }

    public func handle(_ error: Error) {
        bubbleUp(error, previous: [])
    }

    private func bubbleUp(_ error: Error, previous: [ErrorHandler]) {
        if let parent = parent {
            parent.bubbleUp(error, previous: previous + [self])
        } else {
            process(error, next: AnyCollection(previous.reversed()))
        }
    }

    private func process(_ error: Error, next: AnyCollection<ErrorHandler>) {
        let handled = action(error)

        if !handled, let nextHandler = next.first {
                nextHandler.process(error, next: next.dropFirst())
        } else {
            // TODO
        }
    }
}
