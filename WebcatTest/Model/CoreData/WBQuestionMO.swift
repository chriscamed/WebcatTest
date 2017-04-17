//
//  WBQuestionMO.swift
//  WebcatTest
//
//  Created by Camilo Medina on 4/15/17.
//  Copyright © 2017 webcat. All rights reserved.
//

import Foundation
import CoreData

class WBQuestionMO: NSManagedObject {
    
    @NSManaged var title: String?
    @NSManaged var url: String?
    @NSManaged var published_at: String?
    @NSManaged var choice_relation: Set<WBChoiceMO>?
    
    static func saveQuestionToLocalDatabase(_ question: Question) {
        let moc = CoreDataController.sharedInstance.managedObjectContext
        
        let questionFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "QuestionEntity")
        let questionPredicate = NSPredicate(format: "published_at = %@", question.publishedAt)
        questionFetch.predicate = questionPredicate
        
        do {
            let data = try moc.fetch(questionFetch) as? [WBQuestionMO]
            if data?.first == nil {
                print("No record found. Saving to local database.")
                var choices = Set<WBChoiceMO>()
                for choice in question.choices {
                    let choiceEntity = NSEntityDescription.insertNewObject(forEntityName: "ChoiceEntity", into: moc) as! WBChoiceMO
                    choiceEntity.setValue(choice.name, forKey: "name")
                    choiceEntity.setValue(choice.url, forKey: "url")
                    choiceEntity.setValue(NSNumber(value: choice.votes), forKey: "votes")
                    
                    choices.insert(choiceEntity)
                }
                
                let questionEntity = NSEntityDescription.insertNewObject(forEntityName: "QuestionEntity", into: moc) as! WBQuestionMO
                
                questionEntity.setValue(question.title, forKey: "title")
                questionEntity.setValue(question.url, forKey: "url")
                questionEntity.setValue(question.publishedAt, forKey: "published_at")
                questionEntity.setValue(choices, forKey: "choice_relation")
                
                
                do {
                    try moc.save()
                    print("Data saved successfully!")
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            } else {
                print("Record found. Skipping save.")
            }
            
        } catch let error as NSError {
            print("Error \(error)")
        }
        
    }
    
    static func loadQuestionsFromLocalDatabase() -> [Question]? {
        let moc = CoreDataController.sharedInstance.managedObjectContext
        let questionsFetch = NSFetchRequest<NSManagedObject>(entityName: "QuestionEntity")
        
        questionsFetch.returnsObjectsAsFaults = false
        
        do {
            let data = try moc.fetch(questionsFetch) as! [WBQuestionMO]
            var questions: [Question] = []
            
            for questionMO in data {
                let title = questionMO.title!
                let url = questionMO.url!
                let publishedAt = questionMO.published_at!
                let choicesMO = questionMO.choice_relation!
                var choices: [Choice] = []
                for choice in choicesMO {
                    let name = choice.name!
                    let url = choice.url!
                    let votes = choice.votes!.int32Value
                    
                    choices.append(Choice(name: name, url: url, votes: Int(votes)))
                }
                
                questions.append(Question(title: title, url: url, publishedAt: publishedAt, choices: choices.sorted { $0.votes > $1.votes }))
            }
            
            print("Data loaded successfully!")
            
            return questions
        } catch let error as NSError {
            print("Error \(error)")
            return nil
        }
    }
    
    static func incrementVotes(inChoiceWithId choiceUrl: String, andQuestionId questionId: String) {
        let moc = CoreDataController.sharedInstance.managedObjectContext
        let questionMO = getQuestionObject(withQuestionId: questionId)
        if let choices = questionMO?.choice_relation {
            let choice = choices.filter { $0.url == choiceUrl }.first
            choice?.setValue(NSNumber(value: choice!.votes!.int32Value + 1), forKey: "votes")
            
            do {
                try moc.save()
                print("Data saved successfully!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
        
    }
    
    static  func getQuestionObject(withQuestionId id: String) -> WBQuestionMO? {
        let moc = CoreDataController.sharedInstance.managedObjectContext
        let questionsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "QuestionEntity")
        let idPredicate = NSPredicate(format: "published_at = %@", id)
        questionsFetch.predicate = idPredicate
        questionsFetch.returnsObjectsAsFaults = false
        
        do {
            let question = try (moc.fetch(questionsFetch) as? [WBQuestionMO])?.first
            return question
        } catch {
            print(error)
        }
        
        return nil
    }
    
    
}
