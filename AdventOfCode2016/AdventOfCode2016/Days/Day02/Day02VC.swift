
//
//  Day02VC.swift
//  AdventOfCode2016
//
//  Created by Geir-Kåre S. Wærp on 03/11/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day02VC: AoCVC, AdventDay, InputLoadable {
    typealias Keypad = [IntPoint : String] // Position --> Key
    private var instructions: [String] = []
    
    private let keypad1: Keypad = [IntPoint(x: 0, y: 0) : "7",
                                   IntPoint(x: 1, y: 0) : "8",
                                   IntPoint(x: 2, y: 0) : "9",
                                   IntPoint(x: 0, y: 1) : "4",
                                   IntPoint(x: 1, y: 1) : "5",
                                   IntPoint(x: 2, y: 1) : "6",
                                   IntPoint(x: 0, y: 2) : "1",
                                   IntPoint(x: 1, y: 2) : "2",
                                   IntPoint(x: 2, y: 2) : "3"]
    
    private let keypad2: Keypad = [IntPoint(x: 2, y: 4) : "1",
                                   IntPoint(x: 1, y: 3) : "2",
                                   IntPoint(x: 2, y: 3) : "3",
                                   IntPoint(x: 3, y: 3) : "4",
                                   IntPoint(x: 0, y: 2) : "5",
                                   IntPoint(x: 1, y: 2) : "6",
                                   IntPoint(x: 2, y: 2) : "7",
                                   IntPoint(x: 3, y: 2) : "8",
                                   IntPoint(x: 4, y: 2) : "9",
                                   IntPoint(x: 1, y: 1) : "A",
                                   IntPoint(x: 2, y: 1) : "B",
                                   IntPoint(x: 3, y: 1) : "C",
                                   IntPoint(x: 2, y: 0) : "D"]
    
    func loadInput() {
        self.instructions = self.defaultInputFileString.loadAsTextString().trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")
    }
    
    func solveFirst() {
        let code = self.getCode(on: self.keypad1, with: self.instructions, startPos: IntPoint(x: 1, y: 1))
        self.setSolution(challenge: 0, text: code)
    }
    
    func solveSecond() {
        let code = self.getCode(on: self.keypad2, with: self.instructions, startPos: IntPoint(x: 0, y: 2))
        self.setSolution(challenge: 1, text: code)
    }
    
    private func getCode(on keypad: Keypad, with instructions: [String], startPos: IntPoint) -> String {
        var finalCode: String = ""
        var currPos: IntPoint = startPos
        for instruction in instructions {
            for char in instruction {
                let candidatePos: IntPoint
                switch char {
                case "U":
                    candidatePos = currPos + IntPoint(x: 0, y: 1)
                case "D":
                    candidatePos = currPos + IntPoint(x: 0, y: -1)
                case "L":
                    candidatePos = currPos + IntPoint(x: -1, y: 0)
                case "R":
                    candidatePos = currPos + IntPoint(x: 1, y: 0)
                default: fatalError("Invalid character")
                }
                if keypad[candidatePos] != nil {
                    currPos = candidatePos
                }
            }
            finalCode.append(keypad[currPos]!)
        }
        
        return finalCode
    }
}

extension Day02VC: TestableDay {
    func runTests() {
        let input = """
ULL
RRDDD
LURDL
UUUUD
"""
        let instructions = input.components(separatedBy: "\n")
        assert(self.getCode(on: self.keypad1, with: instructions, startPos: IntPoint(x: 1, y: 1)) == "1985")
        assert(self.getCode(on: self.keypad2, with: instructions, startPos: IntPoint(x: 0, y: 2)) == "5DB3")
    }
}
