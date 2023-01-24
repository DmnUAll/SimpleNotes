import UIKit

// MARK: - NoteController
final class NoteController: UIViewController {

    // MARK: - Properties and Initializers
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private var presenter: NotePresenter?
    lazy var isEditingMode = false
    lazy var noteView: NoteView = {
        let view = NoteView()
        return view
    }()

    convenience init(withNoteToEdit text: String) {
        self.init()
        noteView.textView.text = text
        isEditingMode = true
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .snPinkLight
        presenter = NotePresenter(viewController: self)
        view.addSubview(noteView)
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        noteView.textView.becomeFirstResponder()
        registerKeyboardNotifications()
    }
}

// MARK: - Helpers
extension NoteController {

    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardKey = UIResponder.keyboardFrameEndUserInfoKey
        guard let keyboardSize = (notification.userInfo?[keyboardKey] as? NSValue)?.cgRectValue else { return }
        noteView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                         constant: -keyboardSize.height).isActive = true
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.noteView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    private func setupConstraints() {
        let constraints = [
            noteView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noteView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            noteView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noteView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
