//
//  UserModel.swift
//  PauseParenting
//
//  Created by Ruslan Duda on 18.10.2023.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

struct UserQuestions: Equatable, Hashable, Codable {
    var bestDay: String
    var doDifferently: String
    var goals: String
    var liked: String
    var relax: String
    var whoHelps: String
    var stressed: String
    
    init() {
        bestDay = ""
        doDifferently = ""
        goals = ""
        liked = ""
        relax = ""
        whoHelps = ""
        stressed = ""
    }
    
    init(bestDay: String, doDifferently: String, goals: String, liked: String, relax: String, whoHelps: String, stressed: String) {
        self.bestDay = bestDay
        self.doDifferently = doDifferently
        self.goals = goals
        self.liked = liked
        self.relax = relax
        self.whoHelps = whoHelps
        self.stressed = stressed
    }
}

struct UserModel: Identifiable, Equatable, Hashable, Codable {
    @DocumentID var id: String?
    
    var firstName: String
    var lastName: String
    var age: Int
    var image: String
    var color: Color
    var postcode: String
    var isRegistered: Bool
    var questions: UserQuestions
    var children: [String]
    let dateCreated: Date
    
    var name: String {
        [firstName, lastName]
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
    
    init() {
        postcode = ""
        firstName = ""
        lastName = ""
        age = -1
        image = ""
        color = .clear
        isRegistered = false
        children = []
        questions = .init()
        dateCreated = Date()
    }
    
    init(userID: String, postcode: String) {
        self.id = userID
        self.postcode = postcode
        
        firstName = ""
        lastName = ""
        age = -1
        image = ""
        color = .clear
        isRegistered = false
        questions = .init()
        children = []
        dateCreated = Date()
    }
    
    init(firstName: String, lastName: String, age: Int, image: String, color: Color, postcode: String, isRegistered: Bool, questions: UserQuestions, children: [String], dateCreated: Date) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.image = image
        self.color = color
        self.postcode = postcode
        self.isRegistered = isRegistered
        self.questions = questions
        self.children = children
        self.dateCreated = dateCreated
    }
    
    public func getDetail(by type: ParentDetailType) -> String {
        switch type {
        case .whatIdoToRelax: return questions.relax
        case .whatMakesMeStressed: return questions.stressed
        }
    }
    
    static let mock = UserModel(
        firstName: "Hannah",
        lastName: "Last",
        age: 32,
        image: "hannahImage",
        color: .darkBlue,
        postcode: "WR6PLf",
        isRegistered: true,
        questions: .init(
            bestDay: "",
            doDifferently: "",
            goals: "",
            liked: "",
            relax: "Reading a book, watching TV",
            whoHelps: "",
            stressed: "Loud children, not being listened too"
        ),
        children: [],
        dateCreated: Date()
    )
}
    
