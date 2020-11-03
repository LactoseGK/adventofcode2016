//
//  Day03VC.swift
//  AdventOfCode2016
//
//  Created by Geir-Kåre S. Wærp on 03/11/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day03VC: AoCVC, AdventDay, InputLoadable {
    private var input: [String] = []
    
    func loadInput() {
        self.input = self.defaultInputFileString.loadAsTextStringArray()

    }
    
    func solveFirst() {
        let sides = self.input
            .map({ $0.components(separatedBy: " ")
            .filter({!$0.isEmpty})
            .map({ $0.intValue!} )})
        let filtered = sides.filter({self.isValidTriangle(sides: $0)})
        self.setSolution(challenge: 0, text: "\(filtered.count)")
    }
    
    func solveSecond() {
        var sides: [[Int]] = []
        let numColumns = 3
        var side: [Int] = []
        for i in 0..<numColumns {
            for line in self.input {
                let components = line.components(separatedBy: " ")
                    .filter({!$0.isEmpty})
                side.append(components[i].intValue!)
                if side.count == 3 {
                    sides.append(side)
                    side = []
                }
            }
        }
        
        let filtered = sides.filter({self.isValidTriangle(sides: $0)})
        self.setSolution(challenge: 1, text: "\(filtered.count)")
    }
    
    func isValidTriangle(sides: [Int]) -> Bool {
        guard sides.count == 3 else { fatalError("Must be 3 sides.") }
        return sides[0] + sides[1] > sides[2]
        && sides[1] + sides[2] > sides[0]
        && sides[2] + sides[0] > sides[1]
    }
}

extension Day03VC: TestableDay {
    func runTests() {
        assert(self.isValidTriangle(sides: [5, 10, 25]) == false)
        assert(self.isValidTriangle(sides: [3, 4, 5]) == true)
    }
}
