//
//  AppLogic.swift
//  SimpleNotes
//
//  Created by Илья Валито on 14.09.2022.
//

import UIKit
import CoreData

struct AppLogic {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var index: Int = 0
    var notesArray = [Note]()
    
    private mutating func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving cintext: \(error)")
        }
    }
    
    mutating func loadItems(with request: NSFetchRequest<Note> = Note.fetchRequest(), sortedBy sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "date", ascending: false)) {
        request.sortDescriptors = [sortDescriptor]
        do {
            notesArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }
    
    mutating func addNote(noteText: String) {
        let newNote = Note(context: context)
        newNote.text = noteText
        newNote.date = Date()
        notesArray.append(newNote)
        saveItems()
    }
    
    mutating func deleteNote() {
        context.delete(notesArray[index])
        notesArray.remove(at: index)
        saveItems()
    }
    
    mutating func searchNotes(with text: String) {
        
        // Create a search request
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        request.predicate = NSPredicate(format: "text CONTAINS[cd] %@", text)
        
        // Sending the request
        loadItems(with: request)
    }
}
