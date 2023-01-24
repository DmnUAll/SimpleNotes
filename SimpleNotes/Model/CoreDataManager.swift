import UIKit
import CoreData

// MARK: - CoreDataManager
final class CoreDataManager {

    // MARK: - Properties and Initializers
    // swiftlint:disable force_cast
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // swiftlint:enable force_cast
    static var shared = CoreDataManager()
    var editedNoteIndex: Int = 0
    var notesArray: [Note] = []
}

// MARK: - Helpers
extension CoreDataManager {

    private func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving cintext: \(error)")
        }
    }

    func loadItems(with request: NSFetchRequest<Note> = Note.fetchRequest(),
                   sortedBy sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
    ) {
        request.sortDescriptors = [sortDescriptor]
        do {
            notesArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }

    func addNote(noteText: String) {
        let newNote = Note(context: context)
        newNote.text = noteText
        newNote.date = Date()
        notesArray.append(newNote)
        saveItems()
    }

    func deleteNote() {
        context.delete(notesArray[editedNoteIndex])
        notesArray.remove(at: editedNoteIndex)
        saveItems()
    }

    func searchNotes(with text: String) {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        request.predicate = NSPredicate(format: "text CONTAINS[cd] %@", text)
        loadItems(with: request)
    }
}
