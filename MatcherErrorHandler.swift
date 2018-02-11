public class MatcherErrorHandler: ErrorHandler {

    fileprivate var errorActions: [(ErrorMatcher, ErrorHandleAction)] = []
    fileprivate var onNoMatch: [ErrorHandleAction] = []

    init(parent: ErrorHandler?) {
        super.init(action: { error in
            return false
        }, parent: parent)
    }
    
    public func on(_ matcher: ErrorMatcher, do action: @escaping ErrorHandleAction) {
        errorActions.append((matcher, action))
    }

    public func on<E: Error & Equatable>(_ error: E, do action: @escaping ErrorHandleAction) {
        errorActions.append(
            (EquatableErrorMatcher(error), action)
        )
    }

    public func onError<T: Error>(ofType type: T.Type, do action: @escaping ErrorHandleAction) {
        on(ErrorTypeMatcher<T>(), do: action)
    }

    public func onNoMatch(do action: @escaping ErrorHandleAction) {
        onNoMatch.append(action)
    }

    private func handleError(_ error: Error) -> Bool {

        for (matcher, action) in errorActions.reversed() {
            if matcher.matches(error) {
                if action(error) {
                    return true
                }
            }
        }

        // else
        for otherwise in onNoMatch.reversed() {
            if otherwise(error) {
                return true
            }
        }

        return false
    }
}

public protocol ErrorMatcher {
    /**
    The `ErrorMatcher` is considered to match the error if this function returns true.
    - Returns: `true` if the matcher matches the `error` otherwise `false`
    */
   func matches(_ error: Error) -> Bool
}

/**
A generic `ErrorMatcher` over type `E` that `matches` an error if the error `is` `T`
*/
public class ErrorTypeMatcher<E: Error>: ErrorMatcher {

   public func matches(_ error: Error) -> Bool {
       return error is E
   }
}

public class EquatableErrorMatcher<E: Error & Equatable>: ErrorMatcher {

    private let handledError: E

    public init(_ error: E) {
        self.handledError = error
    }

    public func matches(_ error: Error) -> Bool {
        guard let error = error as? E else { return false }
        return handledError == error
    }
}


/**
 An `ErrorMatcher` that wraps a `matches` closure
 */
public class ClosureErrorMatcher: ErrorMatcher {
    private let matches: (Error) -> Bool

    public init(matches: @escaping (Error) -> Bool) {
        self.matches = matches
    }

    public func matches(_ error: Error) -> Bool {
        return self.matches(error)
    }
}
