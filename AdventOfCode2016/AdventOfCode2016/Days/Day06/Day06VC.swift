//
//  Day06VC.swift
//  AdventOfCode2016
//
//  Created by Geir-Kåre S. Wærp on 06/11/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day06VC: AoCVC, AdventDay, InputLoadable {
    private var input: [String] = []
    
    func loadInput() {
        self.input = self.defaultInputFileString.loadAsTextStringArray()
    }
    
    func solveFirst() {
        let errorCorrectedMessage = self.getErrorCorrectedMessage(from: self.input, sortPredicate: (>))
        self.setSolution(challenge: 0, text: errorCorrectedMessage)
    }
    
    func solveSecond() {
        let errorCorrectedMessage = self.getErrorCorrectedMessage(from: self.input, sortPredicate: (<))
        self.setSolution(challenge: 1, text: errorCorrectedMessage)
    }
    
    private func getErrorCorrectedMessage(from messages: [String], sortPredicate: ((Int, Int) -> (Bool))) -> String {
        let length = messages.first!.count
        var result: String = ""
        
        
        var countDictionaries: [[String : Int]] = Array(repeating: [:], count: length)
        for message in messages {
            let arrayed = message.toStringArray()
            for i in 0..<length {
                let currCharacter = arrayed[i]
                countDictionaries[i][currCharacter, default: 0] += 1
            }
        }
        
        for countDictionary in countDictionaries {
            let nextCharacter = countDictionary.keys.min(by: { (key1, key2) -> Bool in
                let count1 = countDictionary[key1, default: 0]
                let count2 = countDictionary[key2, default: 0]
                return sortPredicate(count1, count2)
            })!
            result.append(nextCharacter)
        }
        
        return result
    }
}

extension Day06VC: TestableDay {
    func runTests() {
        let input = """
eedadn
drvtee
eandsr
raavrd
atevrs
tsrnev
sdttsa
rasrtv
nssdts
ntnada
svetve
tesnvt
vntsnd
vrdear
dvrsen
enarar
""".components(separatedBy: "\n")
        
        assert(self.getErrorCorrectedMessage(from: input, sortPredicate: (>)) == "easter")
        assert(self.getErrorCorrectedMessage(from: input, sortPredicate: (<)) == "advent")
    }
}
