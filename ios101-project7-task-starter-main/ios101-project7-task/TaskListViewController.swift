//
//  TaskListViewController.swift
//

import UIKit

class TaskListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateLabel: UILabel!

    var tasks = [Task]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableHeaderView = UIView()
        tableView.dataSource = self
        tableView.delegate = self

        // Load saved tasks
        tasks = Task.getTasks()
        emptyStateLabel.isHidden = !tasks.isEmpty
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshTasks()
    }

    @IBAction func didTapNewTaskButton(_ sender: Any) {
        performSegue(withIdentifier: "ComposeSegue", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ComposeSegue" {
            if let navController = segue.destination as? UINavigationController,
               let composeVC = navController.topViewController as? TaskComposeViewController {

                // If editing, pass the selected task
                composeVC.taskToEdit = sender as? Task

                composeVC.onComposeTask = { [weak self] task in
                    guard let self = self else { return }

                    if let index = self.tasks.firstIndex(where: { $0.id == task.id }) {
                        // Update existing task
                        self.tasks[index] = task
                    } else {
                        // Add new task
                        self.tasks.append(task)
                    }

                    Task.save(self.tasks)
                    self.refreshTasks()
                }
            }
        }
    }

    private func refreshTasks() {
        var tasks = Task.getTasks()

        tasks.sort { lhs, rhs in
            if lhs.isComplete && rhs.isComplete {
                return lhs.completedDate! < rhs.completedDate!
            } else if !lhs.isComplete && !rhs.isComplete {
                return lhs.createdDate < rhs.createdDate
            } else {
                return !lhs.isComplete && rhs.isComplete
            }
        }

        self.tasks = tasks
        emptyStateLabel.isHidden = !tasks.isEmpty
        tableView.reloadData()
    }
}

// MARK: - DataSource
extension TaskListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        let task = tasks[indexPath.row]

        cell.configure(with: task) { [weak self] updatedTask in
            updatedTask.save()
            self?.refreshTasks()
        }

        return cell
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            Task.save(tasks)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - Delegate
extension TaskListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        let selectedTask = tasks[indexPath.row]
        performSegue(withIdentifier: "ComposeSegue", sender: selectedTask)
    }
}
