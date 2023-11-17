//
//  ChildModel.swift
//  PauseParenting
//
//  Created by Dmytro Savka on 12.10.2023.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

struct ChildrenQuestions: Equatable, Hashable, Codable {
    var calmsDown: String
    var findHard: String
    var goodAt: String
    var loveFromParents: String
    
    init() {
        calmsDown = ""
        findHard = ""
        goodAt = ""
        loveFromParents = ""
    }
    
    init(calmsDown: String, findHard: String, goodAt: String, loveFromParents: String) {
        self.calmsDown = calmsDown
        self.findHard = findHard
        self.goodAt = goodAt
        self.loveFromParents = loveFromParents
    }
}

struct ChildModel: Identifiable, Equatable, Hashable, Codable {
    @DocumentID var id: String?
    
    var name: String
    
    var color: Color
    var image: String
    var age: Int
    var developmentalAge: Int
    var learningDisability: Bool
    var questions: ChildrenQuestions
    var parents: [String]
    let dateCreated: Date
    
    init() {
        name = ""
        color = .clear
        image = ""
        age = -1
        developmentalAge = -1
        questions = .init()
        learningDisability = false
        parents = []
        dateCreated = Date()
    }
    
    init(name: String, color: Color, image: String, age: Int, developmentalAge: Int, parents: [String], questions: ChildrenQuestions, learningDisability: Bool, dateCreated: Date) {
        self.name = name
        
        self.color = color
        self.image = image
        self.age = age
        self.developmentalAge = developmentalAge
        self.parents = parents
        self.questions = questions
        self.learningDisability = learningDisability
        self.dateCreated = dateCreated
    }
    
    public func getDetail(by type: ChildDetailType) -> String {
        switch type {
        case .developmentalAge: return developmentalAge >= 0 ? developmentalAge.description : ""
        case .whatCalmsMeDown: return questions.calmsDown
        case .whatAmIGoodAt: return questions.goodAt
        case .whatDoIFindHard: return questions.findHard
        case .whatDoILoveFromMyParents: return questions.loveFromParents
        }
    }
    
    static var mockChildJess: ChildModel {
        ChildModel(
            name: "Jess",
            
            color: .pink,
            image: "jessPhoto",
            age: 10,
            developmentalAge: 8,
            
            parents: [],
            questions: .init(
                calmsDown: "Playing with my toys and watching the ipad",
                findHard: "Concentrating",
                goodAt: "Maths, painting and cooking",
                loveFromParents: "Hugs, stories and playing together"
            ),
            learningDisability: true,
            dateCreated: Date()
        )
    }
    
    static var mockChildAlex: ChildModel {
        ChildModel(
            name: "Alex",
            
            color: .yellow,
            image: "alexPhoto",
            age: 8,
            developmentalAge: -1,
            
            parents: [],
            questions: .init(
                calmsDown: "Playing with my toys and watching the ipad",
                findHard: "Concentrating",
                goodAt: "Maths, painting and cooking",
                loveFromParents: "Hugs, stories and playing together"
            ),
            learningDisability: false,
            dateCreated: Date()
        )
    }
    
    static var mockChildKyle: ChildModel {
        ChildModel(
            name: "Kyle",
            
            color: .blue,
            image: "kylePhoto",
            age: 6,
            developmentalAge: 4,
            parents: [],
            questions: .init(
                calmsDown: "Playing with my toys and watching the ipad",
                findHard: "Concentrating",
                goodAt: "Maths, painting and cooking",
                loveFromParents: "Hugs, stories and playing together"
            ),
            learningDisability: false,
            dateCreated: Date()
        )
    }
    
    static var mockChildren: [ChildModel] {
        [mockChildAlex, mockChildJess, mockChildKyle]
    }
}
