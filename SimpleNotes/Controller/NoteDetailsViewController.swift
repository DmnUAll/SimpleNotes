//
//  NoteDetailsViewController.swift
//  SimpleNotes
//
//  Created by Илья Валито on 14.09.2022.
//

import UIKit

class NoteDetailsViewController: UIViewController {
    
    var isEditingNote: Bool = false
    
    @IBOutlet private weak var noteTextView: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        noteTextView.becomeFirstResponder()
    }
    
    func setUI(noteText: String) {
        DispatchQueue.main.async {
            self.noteTextView.text = noteText
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? MainViewController else { return }
        if noteTextView.text != "" && isEditingNote {
            destinationVC.appLogic.deleteNote()
            destinationVC.appLogic.addNote(noteText: noteTextView.text!)
        } else if noteTextView.text != "" {
            destinationVC.appLogic.addNote(noteText: noteTextView.text!)
        }
    }
    @IBAction func shareButtonTapped(_ sender: UIBarButtonItem) {
        
        guard let text = noteTextView.text else { return }
        
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
}
