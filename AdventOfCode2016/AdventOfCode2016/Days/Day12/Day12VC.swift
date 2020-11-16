//
//  Day12VC.swift
//  AdventOfCode2016
//
//  Created by Geir-Kåre S. Wærp on 16/11/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day12VC: AoCVC, AdventDay, InputLoadable {
    enum Instruction {
        case cpy(source: String, destination: String)
        case inc(register: String)
        case dec(register: String)
        case jnz(source: String, offset: Int)
        
        static func from(string: String) -> Instruction {
            let components = string.components(separatedBy: " ")
            switch components[0] {
            case "cpy":
                let source = components[1]
                let destination = components[2]
                return .cpy(source: source, destination: destination)
            case "inc":
                let register = components[1]
                return .inc(register: register)
            case "dec":
                
                    let register = components[1]
                    return .dec(register: register)
            case "jnz":
                let source = components[1]
                let offset = Int(components[2])!
                return .jnz(source: source, offset: offset)
            default:
                fatalError()
            }
        }
    }
    
    class Machine {
        private var instructionPointer = 0
        var registers: [String: Int] = ["a" : 0,
                                        "b" : 0,
                                        "c" : 0,
                                        "d" : 0]
        
        func apply(instructions: [Instruction]) {
            while self.instructionPointer < instructions.count {
                self.apply(instruction: instructions[self.instructionPointer])
            }
        }
        
        private func apply(instruction: Instruction) {
            switch instruction {
            case .cpy(source: let source, destination: let destination):
                let value = Int(source) ?? self.registers[source]!
                self.registers[destination] = value
                self.instructionPointer += 1
            case .inc(register: let register):
                self.registers[register]! += 1
                self.instructionPointer += 1
            case .dec(register: let register):
                self.registers[register]! -= 1
                self.instructionPointer += 1
            case .jnz(source: let source, offset: let offset):
                let value = Int(source) ?? self.registers[source]!
                if value != 0{
                    self.instructionPointer += offset
                } else {
                    self.instructionPointer += 1
                }
            }
        }
    }
    
    private var instructions: [Instruction] = []
    
    func loadInput() {
        self.instructions = self.defaultInputFileString.loadAsTextStringArray().map({Instruction.from(string: $0)})
    }
    
    func solveFirst() {
        let machine = Machine()
        machine.apply(instructions: self.instructions)
        self.setSolution(challenge: 0, text: "\(machine.registers["a"]!)")
    }
    
    func solveSecond() {
        let machine = Machine()
        machine.registers["c"] = 1
        machine.apply(instructions: self.instructions)
        self.setSolution(challenge: 1, text: "\(machine.registers["a"]!)")
    }
}

extension Day12VC: TestableDay {
    func runTests() {
        let input = """
        cpy 41 a
        inc a
        inc a
        dec a
        jnz a 2
        dec a
        """.components(separatedBy: "\n")
        let instructions = input.map({Instruction.from(string: $0)})
        
        let machine = Machine()
        machine.apply(instructions: instructions)
        assert(machine.registers["a"] == 42)
    }
}
