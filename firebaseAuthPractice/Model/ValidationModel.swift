//
//  ValidationModel.swift
//  firebaseAuthPractice
//
//  Created by Macbook Pro on 24/06/2024.
//

import Foundation

struct Validation {
    func isEmailValid (_ email : String) -> Bool {
        return !email.isEmpty
    }
    
    func isPasswordValid (_ password : String) -> Bool {
        return !password.isEmpty
    }
}
