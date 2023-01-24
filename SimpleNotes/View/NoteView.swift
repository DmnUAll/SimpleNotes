import UIKit

// MARK: - NoteView
final class NoteView: UIView {

    // MARK: - Properties and Initializers
    let textView: UITextView = {
        let textView = UITextView()
        textView.toAutolayout()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.backgroundColor = .snCream
        textView.tintColor = .snPinkDark
        textView.textColor = .snPinkDark
        return textView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        toAutolayout()
        addSubview(textView)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers
extension NoteView {

    private func setupConstraints() {
        let constraints = [
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
