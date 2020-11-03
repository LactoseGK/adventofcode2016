//
//  Day01VC.swift
//  AdventOfCode2016
//
//  Created by Geir-Kåre S. Wærp on 03/11/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day01VC: AoCVC, AdventDay, InputLoadable {
    
    struct Movement {
        let leftTurn: Bool
        let numSteps: Int
        
        static func from(string: String) -> Movement {
            let arrayed = string.trimmingCharacters(in: .whitespacesAndNewlines).toStringArray()
            let leftTurn = arrayed[0].lowercased() == "l"
            let steps = arrayed.dropFirst()
            let numSteps = steps.joined(separator: "").intValue!
            return Movement(leftTurn: leftTurn, numSteps: numSteps)
        }
    }
    
    private var movements: [Movement] = []
    
    func loadInput() {
        self.movements = self.defaultInputFileString.loadAsTextString()
            .components(separatedBy: ",")
            .map({Movement.from(string: $0)})
    }

    
    func solveFirst() {
        let startPos: IntPoint = .origin
        let finalPosition = self.getPosition(after: self.movements)
        let distance = finalPosition.manhattanDistance(to: startPos)
        self.setSolution(challenge: 0, text: "\(distance)")
    }
    
    func solveSecond() {
        let startPos: IntPoint = .origin
        guard let firstDuplicatePosition = self.getFirstDuplicatePosition(with: self.movements) else { fatalError("No duplicate positions found.") }
        let distance = firstDuplicatePosition.manhattanDistance(to: startPos)
        self.setSolution(challenge: 1, text: "\(distance)")
    }
    
    private func getPosition(after movements: [Movement]) -> IntPoint {
        var currPos: IntPoint = .origin
        var currDirection: Direction = .north
        for movement in movements {
            currDirection.turn(left: movement.leftTurn)
            currPos = currPos.move(in: currDirection, numSteps: movement.numSteps)
        }
        return currPos
    }
    
    private func getFirstDuplicatePosition(with movements: [Movement]) -> IntPoint? {
        var seenPositions: Set<IntPoint> = []
        var currPos: IntPoint = .origin
        var currDirection: Direction = .north
        seenPositions.insert(currPos)
        
        for movement in movements {
            currDirection.turn(left: movement.leftTurn)
            for _ in 0..<movement.numSteps {
                currPos = currPos.move(in: currDirection, numSteps: 1)
                if !seenPositions.insert(currPos).inserted {
                    return currPos
                }
            }
            
        }
        
        return nil
    }
}

extension Day01VC: TestableDay {
    func runTests() {
        let input1 = "R2, L3"
        let movements1 = input1.components(separatedBy: ",").map({Movement.from(string: $0)})
        let finalPos1 = self.getPosition(after: movements1)
        assert(finalPos1.manhattanDistance(to: .origin) == 5)
        
        let input2 = "R2, R2, R2"
        let movements2 = input2.components(separatedBy: ",").map({Movement.from(string: $0)})
        let finalPos2 = self.getPosition(after: movements2)
        assert(finalPos2.manhattanDistance(to: .origin) == 2)
        
        let input3 = "R5, L5, R5, R3"
        let movements3 = input3.components(separatedBy: ",").map({Movement.from(string: $0)})
        let finalPos3 = self.getPosition(after: movements3)
        assert(finalPos3.manhattanDistance(to: .origin) == 12)
        
        let input4 = "R8, R4, R4, R8"
        let movements4 = input4.components(separatedBy: ",").map({Movement.from(string: $0)})
        let firstDuplicate = self.getFirstDuplicatePosition(with: movements4)
        assert(firstDuplicate!.manhattanDistance(to: .origin) == 4)
    }
}
