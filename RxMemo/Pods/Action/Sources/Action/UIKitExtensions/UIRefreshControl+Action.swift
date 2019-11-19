#if os(iOS)
    import RxCocoa
    import RxSwift
    import UIKit

    public extension Reactive where Base: UIRefreshControl {
        // Binds enabled state of action to refresh control, and subscribes to value changed control event to execute action.
        // These subscriptions are managed in a private, inaccessible dispose bag. To cancel
        // them, set the rx.action to nil or another action.

        var action: CocoaAction? {
            get {
                var action: CocoaAction?
                action = objc_getAssociatedObject(base, &AssociatedKeys.Action) as? Action
                return action
            }

            set {
                // Store new value.
                objc_setAssociatedObject(base, &AssociatedKeys.Action, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

                // This effectively disposes of any existing subscriptions.
                base.resetActionDisposeBag()

                // Set up new bindings, if applicable.
                if let action = newValue {
                    bind(to: action, input: ())
                }
            }
        }

        func bind<Input, Output>(to action: Action<Input, Output>, inputTransform: @escaping (Base) -> (Input)) {
            unbindAction()

            controlEvent(.valueChanged)
                .map { inputTransform(self.base) }
                .bind(to: action.inputs)
                .disposed(by: base.actionDisposeBag)

            action
                .executing
                .bind(to: isRefreshing)
                .disposed(by: base.actionDisposeBag)

            action
                .enabled
                .bind(to: isEnabled)
                .disposed(by: base.actionDisposeBag)
        }

        func bind<Input, Output>(to action: Action<Input, Output>, input: Input) {
            bind(to: action) { _ in input }
        }

        /// Unbinds any existing action, disposing of all subscriptions.
        func unbindAction() {
            base.resetActionDisposeBag()
        }
    }
#endif
