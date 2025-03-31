//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Vladislava Scherbo on 24.03.25.
//

import Foundation

class QuestionFactory : QuestionFactoryProtocol {
    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Dark Knight",
                     correctAnswer: true),
        QuizQuestion(image: "The Godfather",
                     correctAnswer: true),
        QuizQuestion(image: "Kill Bill",
                     correctAnswer: true),
        QuizQuestion(image: "The Avengers",
                     correctAnswer: true),
        QuizQuestion(image: "Deadpool",
                     correctAnswer: true),
        QuizQuestion(image: "The Green Knight",
                     correctAnswer: true),
        QuizQuestion(image: "Old",
                     correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
                     correctAnswer: false),
        QuizQuestion(image: "Tesla",
                     correctAnswer: false),
        QuizQuestion(image: "Vivarium",
                     correctAnswer: false)
    ]
    
    weak var delegate: QuestionFactoryDelegate?
    
    func instalDelegat(delegat: QuestionFactoryDelegate){
        self.delegate = delegat
    }
    
    
    func requestNextQuestion() {
        guard let index = (0..<questions.count).randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        
        let question = questions[safe: index]
        delegate?.didReceiveNextQuestion(question: question)
    }
}
