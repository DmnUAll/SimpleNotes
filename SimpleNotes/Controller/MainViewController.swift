//
//  ViewController.swift
//  SimpleNotes
//
//  Created by Илья Валито on 14.09.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    var appLogic = AppLogic()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9254901961, green: 0.8, blue: 0.6980392157, alpha: 1)]
            )
        if let clearButton = searchTextField.value(forKeyPath: "_clearButton") as? UIButton {
            clearButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
            clearButton.setImage(UIImage(named:"xmark.circle"), for: .highlighted)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchTextField.text = ""
        appLogic.loadItems()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editNote" {
            guard let destinationVC = segue.destination as? NoteDetailsViewController else { return }
            guard let index = tableView.indexPathForSelectedRow?.row else { return }
            appLogic.index = index
            destinationVC.setUI(noteText: appLogic.notesArray[index].text ?? "None")
            destinationVC.isEditingNote = true
        }
    }
    
    @IBAction func unwindToFirstScreen(_ segue: UIStoryboardSegue) {
    }

    @IBAction func searchTextFieldEditingChanged() {
        if searchTextField.text != "" {
            guard let searchRequest = searchTextField.text else { return }
            appLogic.searchNotes(with: searchRequest)
            tableView.reloadData()
        } else {
            appLogic.loadItems()
            tableView.reloadData()
            searchTextField.resignFirstResponder()
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appLogic.notesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteTableViewCell
        
        cell.noteTitleLabel.text = appLogic.notesArray[indexPath.row].text
        cell.noteDetailLabel.text = "\(appLogic.notesArray[indexPath.row].date!.formatted(date: .numeric, time: .omitted)) \(appLogic.notesArray[indexPath.row].text!)"
        
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editNote", sender: self)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteButton = UIContextualAction(style: .destructive, title: "Remove") { _, _, _ in
            self.appLogic.index = indexPath.row
            self.appLogic.deleteNote()
            tableView.reloadData()
        }
        deleteButton.backgroundColor = .systemRed
        deleteButton.image = UIImage(systemName: "trash")
        
        let config = UISwipeActionsConfiguration(actions: [deleteButton])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}
