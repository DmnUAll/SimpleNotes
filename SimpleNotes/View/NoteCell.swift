import UIKit

// MARK: - NoteCell
final class NoteCell: UITableViewCell {

    // MARK: - Properties and Initializers
    lazy var titleLabel: UILabel = {
        makeLabel(withFontSize: 18, andColor: .snPinkDark)
    }()

    lazy var noteLabel: UILabel = {
        makeLabel(withFontSize: 15, andColor: .snPink)
    }()

    private let mainStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.toAutolayout()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 3
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .snCream
        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers
extension NoteCell {

    private func addSubviews() {
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(noteLabel)
        addSubview(mainStackView)
    }

    private func setupConstraints() {
        let constraints = [
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3),
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func makeLabel(withFontSize size: CGFloat, andColor color: UIColor) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: size)
        label.textColor = color
        return label
    }
}
