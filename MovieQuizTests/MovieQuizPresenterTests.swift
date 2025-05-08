//
//  MovieQuizPresenterTests.swift
//  MovieQuizTests
//
//  Created by Vladislava Scherbo on 8.05.25.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func setAnswerButtonsState(isEnabled: Bool) {
        
    }
    
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {

    }
    
    func showNetworkError(message: String) {
        
    }
    
    func show(quiz step: QuizStepViewModel) {
        
    }

    func highlightImageBorder(isCorrectAnswer: Bool) {
        
    }
    
    func presentFinishResults(quiz result: QuizResultsViewModel) {
        
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
