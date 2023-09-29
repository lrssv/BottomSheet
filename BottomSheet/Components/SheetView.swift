import UIKit

protocol SheetViewDelegate: AnyObject {

    func cancelButtonWasClicked()
    func confirmButtonWasClicked()
    func didDismiss()
}

class SheetView: UIView, UITextFieldDelegate, BottomSheetProtocol {

    // MARK: Views

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "This is a title text"
        titleLabel.textColor = .black
        return titleLabel
    }()

    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.text =  "This is a description text where you can put some information"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Insert something"
        textField.delegate = self
        return textField
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
        button.backgroundColor = .systemGreen
        button.contentEdgeInsets = .init(top: 16, left: 16, bottom: 16, right: 16)
        button.layer.cornerRadius = 8
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
        addSubview(textField)
        addSubview(confirmButton)
        addSubview(cancelButton)
    }

    private func setupConstraints() {
        titleLabelConstraints()
        textLabelConstraints()
        textFieldConstraints()
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
        textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }

    private func textFieldConstraints() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 24).isActive = true
        textField.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }

    private func confirmButtonConstraints() {
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        confirmButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        confirmButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 46).isActive = true
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         endEditing(true)
         return false
     }

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        delegate?.didDismiss()
    }
}
