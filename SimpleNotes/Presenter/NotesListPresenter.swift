import UIKit

// MARK: - NotesListPresenter
final class NotesListPresenter {

    // MARK: - Properties and Initializers
    private weak var viewController: NotesListController?
    private let coreDataManager = CoreDataManager.shared

    init(viewController: NotesListController? = nil) {
        self.viewController = viewController
    }
}

// MARK: - Helpers
extension NotesListPresenter {

    func configureCell(for indexPath: IndexPath, from tableView: UITableView) -> UITableViewCell {
        let note = coreDataManager.notesArray[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell",
                                                       for: indexPath) as? NoteCell else { return UITableViewCell() }
        guard let date = note.date?.formatDate(),
              let text = note.text else { return cell}
        var description = ""
        if text.contains("\n") {
            description = String(text.suffix(from: text.index(after: text.firstIndex(of: "\n")!)))
        } else {
            description = text
        }
        cell.titleLabel.text = text
        cell.noteLabel.text = "\(date) | \(description)"
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }

    func editNote(at indexPath: IndexPath) {
        coreDataManager.editedNoteIndex = indexPath.row
        viewController?.navigationController?.pushViewController(
            NoteController(withNoteToEdit: coreDataManager.notesArray[coreDataManager.editedNoteIndex].text ?? "None"),
            animated: false)
    }

    func removeNote(at indexPath: IndexPath, from tableView: UITableView) {
        coreDataManager.editedNoteIndex = indexPath.row
        coreDataManager.deleteNote()
        tableView.reloadData()
    }
}
