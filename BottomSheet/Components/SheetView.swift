import UIKit

protocol SheetViewDelegate: AnyObject {

    func cancelButtonWasClicked()
    func confirmButtonWasClicked()
}

public class SheetView: UIView {

    // MARK: Views

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Title text"
        titleLabel.textColor = .black
        return titleLabel
    }()

    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.text = "Description text"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        button.addTarget(self, action: #selector(cancelButtonWasClicked), for: .touchUpInside)
        return button
    }()

    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .green.withAlphaComponent(0.8)
        button.contentEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        button.addTarget(self, action: #selector(confirmButtonWasClicked), for: .touchUpInside)
        return button
    }()

    // MARK: Properties

    weak var delegate: SheetViewDelegate?

    // MARK: Initialization

    override public init(frame: CGRect) {
        super.init(frame: .zero)
        buildViewHierarchy()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Methods

    private func buildViewHierarchy() {
        addSubview(titleLabel)
        addSubview(textLabel)
        addSubview(confirmButton)
        addSubview(cancelButton)
    }

    private func setupConstraints() {
        titleLabelConstraints()
        textLabelConstraints()
        confirmButtonConstraints()
        cancelButtonConstraints()
    }

    private func titleLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 24).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }

    private func textLabelConstraints() {
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 34).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }

    private func confirmButtonConstraints() {
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        confirmButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        confirmButton.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 46).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        confirmButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    private func cancelButtonConstraints() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: confirmButton.centerYAnchor).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: confirmButton.leadingAnchor, constant: -16).isActive = true
    }

    @objc private func cancelButtonWasClicked() {
        delegate?.cancelButtonWasClicked()
    }

    @objc private func confirmButtonWasClicked() {
        delegate?.confirmButtonWasClicked()
    }
}
