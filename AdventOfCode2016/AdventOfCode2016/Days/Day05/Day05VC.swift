//
//  Day05VC.swift
//  AdventOfCode2016
//
//  Created by Geir-Kåre S. Wærp on 05/11/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day05VC: AoCVC, AdventDay {
    private var input = "ojvtpuvg"
    
    func solveFirst() {
        let password = self.generatePassword(for: self.input)
        self.setSolution(challenge: 0, text: password)
    }
    
    func solveSecond() {
        let password = self.generateAdvancedPassword(for: self.input)
        self.setSolution(challenge: 1, text: password)
    }
    
    private func generatePassword(for input: String) -> String {
        var password: String = ""
        var numFound = 0
        var currIndex = 0
        while numFound < 8 {
            let currCheck = "\(input)\(currIndex)"
            let md5 = currCheck.md5AsHex
            if md5.hasPrefix("00000") {
                let arrayed = md5.toStringArray()
                let nextCharacterInPassword = arrayed[5]
                password.append(nextCharacterInPassword)
                print("Found \(nextCharacterInPassword)")
                numFound += 1
            }
            currIndex += 1
        }
        return password
    }
    
    private func generateAdvancedPassword(for input: String) -> String {
        var password: [String] = Array(repeating: "_", count: 8)
        
        var numFound = 0
        var currIndex = 0
        while numFound < 8 {
            let currCheck = "\(input)\(currIndex)"
            let md5 = currCheck.md5AsHex
            if md5.hasPrefix("00000") {
                let arrayed = md5.toStringArray()
                if let nextPosition = arrayed[5].intValue,
                    nextPosition < 8,
                    password[nextPosition] == "_" {
                    let nextCharacterInPassword = arrayed[6]
                    password[nextPosition] = nextCharacterInPassword
                    print("Found '\(nextCharacterInPassword)' at position \(nextPosition)")
                    print("Password so far: \(password.joined(separator: ""))")
                    numFound += 1
                }
            }
            currIndex += 1
        }
        
        return password.compactMap({$0}).joined(separator: "")
    }
}

// Disabled, takes 7 minutes to run.
//extension Day05VC: TestableDay {
//    func runTests() {
//        let input = "abc"
//        let password = self.generatePassword(for: input)
//        assert(password == "18f47a30")
//
//        let advancedPassword = self.generateAdvancedPassword(for: input)
//        assert(advancedPassword == "05ace8e3")
//    }
//}
