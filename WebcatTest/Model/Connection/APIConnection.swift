//
//  Connection.swift
//  Imaginamos
//
//  Created by Camilo Medina on 4/11/17.
//  Copyright © 2017 Imaginamos. All rights reserved.
//

import Foundation
import Alamofire
import ReachabilitySwift

protocol APIConnectionDelegate: class {
    func noInternetConnection()
}

class APIConnection {
    
    private let serviceUrl = "http://polls.apiblueprint.org/questions"
    weak var delegate: APIConnectionDelegate?
    
    func fetchQuestions(completion: @escaping (_ data: Any?) -> ()) {
        let internetConnection = Reachability()
        
        internetConnection?.whenReachable = { reachability in
            Alamofire.request(self.serviceUrl).responseJSON { response in
                //CoreDataController.sharedInstance.deleteDataFromEntity("RedditPostEntity")
                completion(self.parseData(response.result.value))
            }
        }
        
        internetConnection?.whenUnreachable = { reachability in
            self.delegate?.noInternetConnection()
            completion(WBQuestionMO.loadQuestionsFromLocalDatabase())
        }
        
        do {
            try internetConnection?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }

    }
    
    func sendNewQuestion(_ question: Question) {
        let internetConnection = Reachability()
        
        internetConnection?.whenReachable = { reachability in
            var choicesString: [String] = []
            var parameters: Parameters
            for choice in question.choices {
                choicesString.append(choice.name)
            }
            
            parameters = ["question": question.title, "choices": choicesString]
            Alamofire.request(self.serviceUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                print(response)
            }
        }
        
        internetConnection?.whenUnreachable = { reachability in
            self.delegate?.noInternetConnection()
        }
        
        do {
            try internetConnection?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    private func parseData(_ json: Any?) -> [Question] {
        
        if let dictionary = json as? [[String: NSObject]] {
            for jsonObject in dictionary {
                let title = jsonObject["question"] as! String
                let url = jsonObject["url"] as! String
                let publishedAt = jsonObject["published_at"] as! String
                var choices: [Choice] = []
                if let jsonChoices = jsonObject["choices"] as? [[String: NSObject]] {
                    for choice in jsonChoices {
                        let name = choice["choice"] as! String
                        let votes = choice["votes"] as! Int
                        let url = choice["url"] as! String
                        
                        choices.append(Choice(name: name, url: url, votes: votes))
                    }
                }
                
                let question = Question(title: title, url: url, publishedAt: publishedAt, choices: choices)
                WBQuestionMO.saveQuestionToLocalDatabase(question)
                //questions.append(question)
                
            }
            
            return WBQuestionMO.loadQuestionsFromLocalDatabase() ?? [Question]()
        }
        
        return [Question]()
    }
}
