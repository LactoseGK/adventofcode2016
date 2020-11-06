//
//  Day08VC.swift
//  AdventOfCode2016
//
//  Created by Geir-Kåre S. Wærp on 06/11/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day08VC: AoCVC, AdventDay, InputLoadable {
    enum Instruction {
        case rect(size: IntPoint)
        case rotateRow(row: Int, shifts: Int)
        case rotateColumn(column: Int, shifts: Int)
        
        static func from(string: String) -> Instruction {
            let components = string.components(separatedBy: " ")
            if components[0] == "rect" {
                let size = components[1].components(separatedBy: "x")
                return .rect(size: IntPoint(x: size[0].intValue!, y: size[1].intValue!))
                
            } else if components[1] == "row" {
                let numShifts = components.last!.intValue!
                let rowInfo = components[2].components(separatedBy: "=")
                let row = rowInfo[1].intValue!
                return .rotateRow(row: row, shifts: numShifts)
            } else {
                let numShifts = components.last!.intValue!
                let columnInfo = components[2].components(separatedBy: "=")
                let column = columnInfo[1].intValue!
                return .rotateColumn(column: column, shifts: numShifts)
                
            }
        }
    }
    
    struct Screen {
        private let grid: Grid
        init(size: IntPoint) {
            self.grid = Grid(size: size, fillWith: ".")
        }
        
        func getNumActive() -> Int {
            return self.grid.values.filter({$0 == "#"}).count
        }
        
        func apply(instruction: Instruction) {
            switch instruction {
            case .rect(let size):
                for point in size.gridPoints {
                    self.grid.setValue(at: point, to: "#")
                }
            case .rotateRow(let row, let shifts):
                var originalRow: [Grid.GridValue] = []
                for x in 0..<self.grid.width {
                    guard let existingValue = self.grid.getValue(at: IntPoint(x: x, y: row)) else { fatalError("Invalid index") }
                    originalRow.append(existingValue)
                }
                for x in 0..<self.grid.width {
                    let newX = (x + shifts) % self.grid.width
                    let newValue = originalRow[x]
                    self.grid.setValue(at: IntPoint(x: newX, y: row), to: newValue)
                }
            case .rotateColumn(let column, let shifts):
                var originalColumn: [Grid.GridValue] = []
                for y in 0..<self.grid.height {
                    guard let existingValue = self.grid.getValue(at: IntPoint(x: column, y: y)) else { fatalError("Invalid index") }
                    originalColumn.append(existingValue)
                }
                for y in 0..<self.grid.height {
                    let newY = (y + shifts) % self.grid.height
                    let newValue = originalColumn[y]
                    self.grid.setValue(at: IntPoint(x: column, y: newY), to: newValue)
                }
            }
        }
        
        func asText() -> String {
            return self.grid.asText()
        }
    }
    
    private var instructions: [Instruction] = []
    
    func loadInput() {
        self.instructions = self.defaultInputFileString
            .loadAsTextStringArray()
            .map({Instruction.from(string: $0)})
    }
    
    func solveFirst() {
        let screen = Screen(size: IntPoint(x: 50, y: 6))
        self.instructions.forEach({screen.apply(instruction: $0)})
        let numActive = screen.getNumActive()
        self.setSolution(challenge: 0, text: "\(numActive)")
    }
    
    func solveSecond() {
        let screen = Screen(size: IntPoint(x: 50, y: 6))
        self.instructions.forEach({screen.apply(instruction: $0)})
        let output = screen.asText()
        self.setSolution(challenge: 1, text: "\n\(output)\n")
    }
}

extension Day08VC: TestableDay {
    func runTests() {
        let input = """
rect 3x2
rotate column x=1 by 1
rotate row y=0 by 4
rotate column x=1 by 1
""".components(separatedBy: "\n")
        let screen = Screen(size: IntPoint(x: 7, y: 3))
        let instructions: [Instruction] = input.map({Instruction.from(string: $0)})

        for (index, instruction) in instructions.enumerated() {
            screen.apply(instruction: instruction)
            assert(screen.asText() == self.expectedResults[index])
        }
    }

    private var expectedResults: [String] {
        return [
"""
###....
###....
.......
""",

"""
#.#....
###....
.#.....
""",

"""
....#.#
###....
.#.....
""",

"""
.#..#.#
#.#....
.#.....
"""
        ]
    }
}
