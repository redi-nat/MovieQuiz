//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Natasha on 01/09/2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
    
}
