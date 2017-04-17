//
//  CreatePollTableViewController.swift
//  WebcatTest
//
//  Created by Camilo Medina on 4/16/17.
//  Copyright © 2017 webcat. All rights reserved.
//

import UIKit

class CreatePollTableViewController: UITableViewController {
    
    fileprivate var choicesNumber = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return choicesNumber
        default:
            return 1
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "createPollChoiceTitleCell", for: indexPath) as! CreatePollTableViewCell
        return cell
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    @IBAction func addNewCell(_ button: UIButton) {
        choicesNumber += 1
        let indexPath = IndexPath(row: tableView.numberOfRows(inSection: 1), section: 1)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @IBAction func removeLastCell(_ button: UIButton) {
        if choicesNumber != 0 {
            choicesNumber -= 1
            let indexPath = IndexPath(row: tableView.numberOfRows(inSection: 1) - 1, section: 1)
            let cell = tableView.cellForRow(at: indexPath) as! CreatePollTableViewCell
            cell.textField.text = ""
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    @IBAction func savePoll(_ sender: UIBarButtonItem) {
        let questionTitleCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! CreatePollTableViewCell
        if choicesNumber == 0 {
            showAlertMessage(withMessage: "There must be at least one choice")
        } else if questionTitleCell.textField.text!.isEmpty {
            showAlertMessage(withMessage: "The question title is missing.")
        } else {
            let publishedAt = getTimeStamp()
            var qNumber = ""
            if let questions = WBQuestionMO.loadQuestionsFromLocalDatabase() {
                qNumber = "\(questions.count + 1)"
            } else {
                qNumber = "1"
            }
            var choices: [Choice] = []
            for i in 0 ..< tableView.numberOfRows(inSection: 1) {
                let cell = tableView.cellForRow(at: IndexPath(row: i, section: 1)) as! CreatePollTableViewCell
                if !cell.textField.text!.isEmpty {
                    let url = "/questions/\(qNumber)/choices/123456789)"
                    let votes = 0
                    let name = cell.textField.text!
                    choices.append(Choice(name: name, url: url, votes: votes))
                }
            }
            
            if choices.count == 0 {
                showAlertMessage(withMessage: "There must be at least one choice with a title")
            } else {
                let url = "/questions/\(qNumber)"
                let questionTitle = questionTitleCell.textField.text!
                let question = Question(title: questionTitle, url: url, publishedAt: publishedAt, choices: choices)
                
                /*
                 As every time the user taps on 'Start Poll' the data is downloaded from the server,
                 there's no need to store the new question in the local database. All the new data
                 are fetched and stored locally from the service instead.
                 */
                //WBQuestionMO.saveQuestionToLocalDatabase(question)
                APIConnection().sendNewQuestion(question)
                navigationController?.popToRootViewController(animated: true)
            }
            
        }
    }
    
    private func getTimeStamp() -> String {
        let date = NSDate()
        
        var calendar = NSCalendar.current
        
        print(calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date as Date))
        
        let unitFlags = Set<Calendar.Component>([.hour, .year, .minute])
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        let components = calendar.dateComponents(unitFlags, from: date as Date)
        
        let hour = calendar.component(.hour, from: date as Date)
        let minutes = calendar.component(.minute, from: date as Date)
        let seconds = calendar.component(.second, from: date as Date)
        
        return "\(String(describing: components.year))-\(String(describing: components.month))-\(String(describing: components.day))T\(hour):\(minutes):\(seconds)"
    }
    
    func showAlertMessage(withMessage message: String) {
        let alertView = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        present(alertView, animated: true, completion: nil)
    }

}
