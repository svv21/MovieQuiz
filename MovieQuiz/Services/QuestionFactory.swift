//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Vladislava Scherbo on 24.03.25.
//

import Foundation

final class QuestionFactory : QuestionFactoryProtocol {
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    
    init(moviesLoader: MoviesLoading, delegat: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegat
    }
    
    private var movies: [MostPopularMovie] = []
    
    /* private let questions: [QuizQuestion] = [
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
     ] */
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.imageURL)
            } catch {
                print("Failed to load image")
            }
            
            let rating = Float(movie.rating) ?? 0
            let correctAnswer = rating > 6
            
            let question = QuizQuestion(image: imageData,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
}
