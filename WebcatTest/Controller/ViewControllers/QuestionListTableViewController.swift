//
//  QuestionListTableViewController.swift
//  WebcatTest
//
//  Created by Camilo Medina on 4/16/17.
//  Copyright © 2017 webcat. All rights reserved.
//

import UIKit

class QuestionListTableViewController: UITableViewController {
    
    var questions: [Question] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        UIApplication.shared.statusBarStyle = .default
        questions = WBQuestionMO.loadQuestionsFromLocalDatabase()!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "statisticChartCell", for: indexPath)
        cell.textLabel?.text = questions[indexPath.row].title

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "chartViewSegue", sender: questions[indexPath.row])
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ChartViewController {
            let vc = segue.destination as! ChartViewController
            let question = sender as? Question
            vc.barTitle = question!.title
            vc.question = question
        }
    }

}
