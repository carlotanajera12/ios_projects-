//
//  TaskComposeViewController.swift
//

import UIKit

class TaskComposeViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var noteField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!

    var taskToEdit: Task?
    var onComposeTask: ((Task) -> Void)? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // If editing, pre-fill fields
        if let task = taskToEdit {
            titleField.text = task.title
            noteField.text = task.note
            datePicker.date = task.dueDate
            self.title = "Edit Task"
        }
    }

    @IBAction func didTapDoneButton(_ sender: Any) {
        // 1. Validate title
        guard let title = titleField.text, !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            presentAlert(title: "Oops...", message: "Make sure to add a title!")
            return
        }

        var task: Task

        if var editTask = taskToEdit {
            // Edit existing task
            editTask.title = title
            editTask.note = noteField.text
            editTask.dueDate = datePicker.date
            task = editTask
        } else {
            // Create new task
            task = Task(
                title: title,
                note: noteField.text,
                dueDate: datePicker.date
            )
        }

        // Pass task back
        onComposeTask?(task)

        // Close screen
        dismiss(animated: true)
    }

    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }

    private func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)

        present(alertController, animated: true)
    }
}
