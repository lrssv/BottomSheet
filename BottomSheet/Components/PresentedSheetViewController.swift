import UIKit

public class PresentedSheetViewController: UIViewController {

    // MARK: Views

    private lazy var containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        return stackView
    }()

    // MARK: Properties

    public let sheet: UIView

    // MARK: Initialization

    public init(sheet: UIView) {
        self.sheet = sheet
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
        containerView.addArrangedSubview(sheet)
    }

    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func setupAditionalConfiguration() {
        modalPresentationStyle = .custom
        view.backgroundColor = .white
    }
}
