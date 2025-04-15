//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Vladislava Scherbo on 27.03.25.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
