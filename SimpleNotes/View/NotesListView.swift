import UIKit

// MARK: - NotesListViewDelegate protocol
protocol NotesListViewDelegate: AnyObject {
    func searchNote()
}

// MARK: - NotesListView
final class NotesListView: UIView {

    // MARK: - Properties and Initializers
    weak var delegate: NotesListViewDelegate?
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.toAutolayout()
        textField.layer.cornerRadius = 5
        textField.backgroundColor = .snCream
        textField.textColor = .snPinkDark
        textField.tintColor = .snPinkDark
        textField.attributedPlaceholder = NSAttributedString(
            string: " Search",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.addTarget(nil, action: #selector(searchBegan), for: .editingChanged)
        return textField
    }()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.toAutolayout()
        tableView.register(NoteCell.self, forCellReuseIdentifier: "noteCell")
        tableView.backgroundColor = .snCream
        tableView.separatorColor = .snPinkDark
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        toAutolayout()
        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers
extension NotesListView {

    @IBAction func searchBegan() {
        delegate?.searchNote()
    }

    private func addSubviews() {
        addSubview(searchTextField)
        addSubview(tableView)
    }

    private func setupConstraints() {
        let constraints = [
            searchTextField.heightAnchor.constraint(equalToConstant: 33),
            searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            searchTextField.topAnchor.constraint(equalTo: topAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 9),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
