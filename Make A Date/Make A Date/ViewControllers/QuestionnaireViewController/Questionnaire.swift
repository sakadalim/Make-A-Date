//
//  Questionnaire.swift
//  Make A Date
//
//  Created by Shefali Satpathy on 4/12/18.
//  Copyright © 2018 Sakada Lim. All rights reserved.
//

import Foundation

class Questionnaire : NSObject {
    var question_01 = [String]()
    var question_02 = [String]()
    var question_03 = [String]()
    var question_04 = [String]()
    var question_05 = [String]()
    
    private static var _current: Questionnaire?
    
    static var current : Questionnaire {
        guard let currentQuestions = _current else {
            fatalError("Error:...")
        }
        return currentQuestions
    }
    
    func setQuestion_01(_ viewModel: ViewModel) {
       question_01 = viewModel.selectedItems.map{$0.title}
        print("Data collected for question 1....")
        print(question_01)
    }
    
    func setQuestion_02(_ viewModel: ViewModel02) {
        question_02 = viewModel.selectedItems.map{$0.title}
        print("Data collected for question 2....")
        print(question_02)
    }
    
    func setQuestion_03(_ viewModel: ViewModel02) {
        question_03 = viewModel.selectedItems.map{$0.title}
        print("Data collected for question 3....")
        print(question_03)
    }
    
    func setQuestion_04(_ viewModel: ViewModel03) {
        question_04 = viewModel.selectedItems.map{$0.title}
        print("Data collected for question 4....")
        print(question_04)
    }
    
    func setQuestion_05(_ viewModel: ViewModel04) {
        question_05 = viewModel.selectedItems.map{$0.title}
        print("Data collected for question 5....")
        print(question_05)
    }
    
    func getQuestion_01() -> [String]{
        return question_01
    }
    
    func getQuestion_02() -> [String]{
        return question_02
    }
    
    func getQuestion_03() -> [String]{
        return question_03
    }
    
    func getQuestion_04() -> [String]{
        return question_04
    }
    
    func getQuestion_05() -> [String]{
        return question_05
    }
}
