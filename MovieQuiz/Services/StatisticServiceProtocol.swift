//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Vladislava Scherbo on 2.04.25.
//

import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var averageAccuracy: Double { get }
    
    func store(currentGameResult: GameResult)
}
