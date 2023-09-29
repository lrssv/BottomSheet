import UIKit

public class PresentedSheetViewController: UIViewController {

    // MARK: Views

    private lazy var containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        return stackView
    }()

    private lazy var containerIndicatorView = UIView()

    private lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 2
        return view
    }()

    // MARK: Properties

    public let sheet: UIView
    private let showIndicatorView: Bool

    // MARK: Initialization

    public init(sheet: UIView, showIndicatorView: Bool) {
        self.sheet = sheet
        self.showIndicatorView = showIndicatorView
        super.init(nibName: nil, bundle: nil)
        buildViewHierarchy()
        setupConstraints()
        setupAditionalConfiguration()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Methods

    private func buildViewHierarchy() {
        view.addSubview(containerView)
        containerView.addArrangedSubview(containerIndicatorView)
        containerIndicatorView.addSubview(indicatorView)
        containerView.addArrangedSubview(sheet)
    }

    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        containerIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        containerIndicatorView.heightAnchor.constraint(equalToConstant: 4).isActive = true

        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        indicatorView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        indicatorView.centerYAnchor.constraint(equalTo: containerIndicatorView.centerYAnchor).isActive = true
        indicatorView.centerXAnchor.constraint(equalTo: containerIndicatorView.centerXAnchor).isActive = true
    }

    private func setupAditionalConfiguration() {
        modalPresentationStyle = .custom
        view.backgroundColor = .white
        containerIndicatorView.isHidden = !showIndicatorView
    }
}
