import UIKit

// MARK: - NotePresenter
final class NotePresenter {

    private weak var viewController: NoteController?
    private let coreDataManager = CoreDataManager.shared

    init(viewController: NoteController? = nil) {
        self.viewController = viewController
        addNavigationButtons()
    }
}

// MARK: - Helpers
extension NotePresenter {

    private func addNavigationButtons() {
        let saveButton = UIBarButtonItem(title: "Save", primaryAction: UIAction(handler: { [weak self] _ in
            guard let self = self,
                  let viewController = self.viewController else { return }
            print("toSave")
            let noteView = viewController.noteView
            if noteView.textView.text != "" && viewController.isEditingMode {
                self.coreDataManager.deleteNote()
                self.coreDataManager.addNote(noteText: noteView.textView.text!)
            } else if noteView.textView.text != "" {
                self.coreDataManager.addNote(noteText: noteView.textView.text!)
            }
            self.viewController?.navigationController?.popToRootViewController(animated: true)
        }))

        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),
                                          primaryAction: UIAction(handler: { [weak self] _ in
            guard let self = self,
                  let text = self.viewController?.noteView.textView.text,
                  text != "" else { return }
            let textToShare = [text]
            let activityViewController = UIActivityViewController(activityItems: textToShare,
                                                                  applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.viewController?.view
            activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop,
                                                            UIActivity.ActivityType.postToFacebook]
            self.viewController?.present(activityViewController, animated: true, completion: nil)
        }))
        viewController?.navigationItem.rightBarButtonItems = [saveButton, shareButton]
    }
}
