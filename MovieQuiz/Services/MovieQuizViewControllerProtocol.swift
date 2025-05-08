//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Vladislava Scherbo on 8.05.25.
//

import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func setAnswerButtonsState(isEnabled: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
    
    func show(quiz step: QuizStepViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func presentFinishResults(quiz result: QuizResultsViewModel) 
}
