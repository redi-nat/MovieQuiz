//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Natasha on 02/09/2024.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    private let storage: UserDefaults = .standard
    private enum Keys: String {
        case correct
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
        case gamesCount
    }
    
    var gamesCount: Int {
        get {
            return storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            let totalCorrectAnswers = Double(storage.integer(forKey: Keys.correct.rawValue))
            let gamesCount = Double(storage.integer(forKey: Keys.gamesCount.rawValue))
            
            guard gamesCount > 0 else { return 0.0 }
            
            return (totalCorrectAnswers / (10 * gamesCount)) * 100
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        let previousCorrectAnswers = storage.integer(forKey: Keys.correct.rawValue)
        storage.set(previousCorrectAnswers + count, forKey: Keys.correct.rawValue)
        
        let previousGamesCount = storage.integer(forKey: Keys.gamesCount.rawValue)
        gamesCount += 1
        
        let currentGameResult = GameResult(correct: count, total: amount, date: Date())
        let previousBestGame = self.bestGame
        
        if currentGameResult.correct > previousBestGame.correct {
            self.bestGame = currentGameResult
            
        }
    }
}
