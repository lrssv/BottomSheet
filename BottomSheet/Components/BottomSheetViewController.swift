import UIKit

public class BottomSheetViewController: UIPresentationController {

    // MARK: Views

    private lazy var blurView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = .black.withAlphaComponent(0.8)
        return view
    }()

    // MARK: Properties

    private lazy var tapGesture: UITapGestureRecognizer = {
        .init(target: self, action: #selector(BottomSheetViewController.handleTapGesture))
    }()

    private lazy var panGesture: UIPanGestureRecognizer = {
        .init(target: self, action: #selector(BottomSheetViewController.handlePanGesture))
    }()

    // Update the frame of presented view to fit in your sheet
    public override var frameOfPresentedViewInContainerView: CGRect {
        guard let presentedView = presentedView, let containerView = containerView else { return .zero }
        let size = presentedView.systemLayoutSizeFitting(
            containerView.bounds.size,
            withHorizontalFittingPriority: UILayoutPriority.required,
            verticalFittingPriority: UILayoutPriority.fittingSizeLevel
        )
        return .init(x: 0, y: (containerView.bounds.height - size.height), width: size.width, height: size.height)
    }

    private var presentedViewOriginalFrame: CGRect = .zero // save the frame to keep the original reference
    private let edges: UIEdgeInsets // to margins
    private let sheetGestures: [UIGestureRecognizer] // previous gestures in your sheet
    private var isShowingKeyboard = false // controll keyboard display
    private var startOrigin = CGPoint(x: 0, y: 0) // to keep the origin of drag in pan gesture

    // MARK: Initialization

    public init(presented: UIViewController, presenting: UIViewController, edges: UIEdgeInsets?, sheetGestures: [UIGestureRecognizer]?) {
        self.edges = edges ?? UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        self.sheetGestures = sheetGestures ?? []
        super.init(presentedViewController: presented, presenting: presenting)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        removeKeyboardObserver()
    }

    // MARK: Public Methods

    public override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        // We don't want update frame in case of show/hide keyboard, we have a specific function to do this
        guard !isShowingKeyboard else { return }
        presentedView?.frame = frameOfPresentedViewInContainerView // to keep frame updated
    }

    public override func presentationTransitionWillBegin() {
        addGestures()
        addBlurView()
        updateMargins()
        setupPresentedView()
        startBlurAnimation()
        addKeyboardObserver()
    }

    public override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        presentedViewOriginalFrame = presentedView?.frame ?? .zero
    }

    public override func dismissalTransitionWillBegin() {
        stopBlurAnimation()
        delegate?.presentationControllerWillDismiss?(self)
    }

    // MARK: Private Methods

    private func addGestures() {
        blurView.addGestureRecognizer(tapGesture)
        presentedView?.addGestureRecognizer(panGesture)
        // If have previous gestures in the sheet, it's necessary establish a priority between then
        sheetGestures.forEach { panGesture.require(toFail: $0) }
    }

    private func addBlurView() {
        guard let containerView else { return }
        containerView.addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        blurView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        blurView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }

    private func updateMargins() {
        let cell = presentedView?.subviews.first as? UIStackView
        cell?.layoutMargins = edges
        cell?.isLayoutMarginsRelativeArrangement = true
    }

    private func setupPresentedView() {
        presentedView?.layer.cornerRadius = 20
        presentedView?.layer.masksToBounds = true
        presentedView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    private func startBlurAnimation() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.blurView.alpha = 1
        })
    }

    private func stopBlurAnimation() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.blurView.alpha = 0
        }, completion: { _ in
            self.blurView.removeFromSuperview()
        })
    }

    @objc private func handleTapGesture() {
        dismiss()
    }

    @objc private func handlePanGesture(_ pan: UIPanGestureRecognizer) {
        guard let view = pan.view, let superView = view.superview else { return }
        let location = pan.location(in: superView)
        let minHeight = presentedViewOriginalFrame.height/4 // minimum height that define show or hide bottom sheet
        let remainingHeight = UIScreen.main.bounds.height - location.y // remaining height in container view considering current location

        switch pan.state {
        case .began:
            startOrigin = location // save the starting point of the gesture
        case .changed:
            drag(to: location)
        case .ended:
            if remainingHeight < minHeight {
                dismiss()
            } else {
                present()
            }
        default: break
        }
    }

    private func drag(to location: CGPoint) {
        if location.y > startOrigin.y {
            let movement = location.y - startOrigin.y
            let yPosition = presentedViewOriginalFrame.origin.y + movement // current position + drag movement
            presentedView?.frame.origin.y = yPosition
        }
    }

    private func dismiss() {
        presentedViewController.dismiss(animated: true) {
            self.delegate?.presentationControllerDidDismiss?(self)
        }
    }

    private func present() {
        guard let presented = presentedView else { return }
        UIView.animate(
            withDuration: 0.8,
            delay: 0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0.5,
            options: .curveEaseInOut,
            animations: { [weak self] in
                guard let self else { return }
                presented.frame = self.presentedViewOriginalFrame
            }
        )
    }

    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        presentedView?.removeGestureRecognizer(panGesture)
        let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height

        guard !isShowingKeyboard, let keyboardHeight else { return }

        isShowingKeyboard = true
        presentedView?.frame.size.height -= getBottomSafeAreaHeight() // remove safe area spacing
        presentedView?.frame.origin.y -= (keyboardHeight - getBottomSafeAreaHeight()) // move y origin to the top of keyboard
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        isShowingKeyboard = false
        presentedView?.addGestureRecognizer(panGesture)
        presentedView?.frame = presentedViewOriginalFrame
        presentedView?.layoutIfNeeded()
    }

    private func getBottomSafeAreaHeight() -> CGFloat {
        let window = UIApplication.shared.windows[0]
        var bottomPadding = CGFloat()

        if #available(iOS 11.0, *) {
            bottomPadding = window.safeAreaInsets.bottom
        } else {
            bottomPadding = 0
        }

        return bottomPadding
    }
}

// MARK: Methods of UIViewControllerTransitioningDelegate

extension BottomSheetViewController: UIViewControllerTransitioningDelegate {

    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        self
    }
}
