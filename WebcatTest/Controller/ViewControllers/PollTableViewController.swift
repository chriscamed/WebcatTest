//
//  PollTableViewController.swift
//  WebcatTest
//
//  Created by Camilo Medina on 4/16/17.
//  Copyright © 2017 webcat. All rights reserved.
//

import UIKit

class PollTableViewController: UITableViewController {
    
    fileprivate var questions: [Question] = []
    fileprivate var currentIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        UIApplication.shared.statusBarStyle = .default
        let apiConnection = APIConnection()
        apiConnection.delegate = self
        apiConnection.fetchQuestions { data in
            if let questions = data as? [Question] {
                self.questions = questions
                self.loadNextQuestion()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func loadNextQuestion() {
        currentIndex += 1
        if currentIndex > questions.count - 1 && questions.count != 0{
            navigationController?.popToRootViewController(animated: true)
        } else {
            title = "Question \(currentIndex + 1) of \(questions.count)"
            let range = NSMakeRange(0, tableView.numberOfSections)
            let sections = NSIndexSet(indexesIn: range)
            //tableView.reloadData()
            DispatchQueue.main.async {
                self.tableView.reloadSections(sections as IndexSet, with: .automatic)
            }
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if questions.count == 0 {
            return 0
        } else {
            switch section {
            case 0:
                return 1
            case 1:
                return questions[currentIndex].choices.count
            default:
                return 0
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var headerTitle: String
        switch section {
        case 0:
            headerTitle = "QUESTION"
        case 1:
            headerTitle = "CHOICES"
        default:
            headerTitle = ""
        }
        
        return headerTitle
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath)
            cell.textLabel?.text = questions[currentIndex].title
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "choiceCell", for: indexPath)
            cell.textLabel?.text = questions[currentIndex].choices[indexPath.row].name
            cell.detailTextLabel?.text = "\(questions[currentIndex].choices[indexPath.row].votes)"
        default:
            cell = UITableViewCell()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.detailTextLabel!.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            UIView.animate(withDuration: 0.5) {
                cell.detailTextLabel!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                cell.detailTextLabel!.text = "\(Int(cell.detailTextLabel!.text!)! + 1)"
            }
        }
        
        delayWithSeconds(0.6) {
            WBQuestionMO.incrementVotes(inChoiceWithId: self.questions[self.currentIndex].choices[indexPath.row].url,
                                        andQuestionId: self.questions[self.currentIndex].publishedAt)
            self.loadNextQuestion()
        }
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    func showAlertMessage(withMessage message: String) {
        let alertView = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        present(alertView, animated: true, completion: nil)
    }
    
}

extension PollTableViewController: APIConnectionDelegate {
    func noInternetConnection() {
        showAlertMessage(withMessage: "There's no internet connection")
    }
}
