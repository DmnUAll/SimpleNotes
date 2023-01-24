import UIKit

// MARK: - NotesListController
final class NotesListController: UIViewController {

    // MARK: - Properties and Initializers
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private var presenter: NotesListPresenter?
    private let coreDataManager = CoreDataManager.shared
    private lazy var notesListView: NotesListView = {
        let view = NotesListView()
        return view
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .snPinkLight
        self.title = "Simple Notes"
        presenter = NotesListPresenter(viewController: self)
        (navigationController as? NavigationController)?.buttonsDelegate = self
        notesListView.tableView.dataSource = self
        notesListView.tableView.delegate = self
        notesListView.delegate = self
        view.addSubview(notesListView)
        setupConstraints()
        view.addKeyboardHiddingFeature()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notesListView.searchTextField.text = ""
        coreDataManager.loadItems()
        notesListView.tableView.reloadData()
    }
}

// MARK: - Helpers
extension NotesListController {

    private func setupConstraints() {
        let constraints = [
            notesListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            notesListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            notesListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            notesListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: - NavigationButtonsDelegate
extension NotesListController: NavigationButtonsDelegate {

    func addTapped() {
        navigationController?.pushViewController(NoteController(), animated: false)
    }
}

// MARK: - UITableViewDataSource
extension NotesListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataManager.notesArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = presenter?.configureCell(for: indexPath, from: tableView) else { return UITableViewCell() }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NotesListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.editNote(at: indexPath)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteButton = UIContextualAction(style: .destructive, title: "Remove") { [weak self] _, _, _ in
            guard let self = self else { return }
            self.presenter?.removeNote(at: indexPath, from: tableView)
        }
        deleteButton.backgroundColor = .systemRed
        deleteButton.image = UIImage(systemName: "trash")
        let config = UISwipeActionsConfiguration(actions: [deleteButton])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
}

// MARK: - NotesListViewDelegate
extension NotesListController: NotesListViewDelegate {

    func searchNote() {
        guard let text = notesListView.searchTextField.text else { return }
        if text == "" {
            coreDataManager.loadItems()
            self.view.endEditing(true)
        } else {
            coreDataManager.searchNotes(with: text)
        }
        notesListView.tableView.reloadData()
    }
}
