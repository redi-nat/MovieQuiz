//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Natasha on 01/09/2024.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func showAlert(with model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) {_ in
            model.completion()
            
        }
        
        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
        
    }
}

