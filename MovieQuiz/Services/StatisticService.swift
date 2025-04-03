//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Vladislava Scherbo on 2.04.25.
//

import Foundation

final class StatisticService : StatisticServiceProtocol{
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case gamesCount
        case correctAnswers
        case totalQuestions
        case date
        case totalCorrectAnswers
        case totalGamesQuestions
    }
    
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    private var totalGamesQuestions: Int {
        get {
            storage.integer(forKey: Keys.totalGamesQuestions.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalGamesQuestions.rawValue)
        }
    }
    
    private var totalCorrectAnswers: Int {
        get {
            storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correctAnswers = storage.integer(forKey: Keys.correctAnswers.rawValue)
            let totalQuestions = storage.integer(forKey: Keys.totalQuestions.rawValue)
            let date = storage.object(forKey: Keys.date.rawValue) as? Date ?? Date()
            
            return GameResult(correctAnswers: correctAnswers, totalQuestions: totalQuestions, date: date)
        }
        set {
            storage.set(newValue, forKey: Keys.correctAnswers.rawValue)
            storage.set(newValue, forKey: Keys.totalQuestions.rawValue)
            storage.set(newValue, forKey: Keys.date.rawValue)
        }
    }
    
    var averageAccuracy: Double {
        guard gamesCount > 0  else { return 0.0 }
        return (Double(totalCorrectAnswers) / Double(gamesCount)) * 10
    }
    
    func store(currentGameResult: GameResult) {
        let totalGamesQuestions = storage.integer(forKey: Keys.totalGamesQuestions.rawValue) + currentGameResult.totalQuestions
        storage.set(totalGamesQuestions, forKey: Keys.totalGamesQuestions.rawValue)
        
        let totalCorrectAnswers = storage.integer(forKey: Keys.totalCorrectAnswers.rawValue) + currentGameResult.correctAnswers
        storage.set(totalCorrectAnswers, forKey: Keys.totalCorrectAnswers.rawValue)
        
        gamesCount += 1
        
        if currentGameResult.isBetter(bestGame) {
            bestGame = currentGameResult
        }
    }
    
}
