//
//  Day10VC.swift
//  AdventOfCode2016
//
//  Created by Geir-Kåre S. Wærp on 07/11/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day10VC: AoCVC, AdventDay, InputLoadable {
    enum Instruction {
        case give(giverID: String, lowID: String, highID: String)
        case assign(value: Int, botID: String)
        
        static func from(string: String) -> Instruction {
            let components = string.components(separatedBy: " ")
            if components[0] == "value" {
                let value = components[1].intValue!
                let botID = "bot \(components.last!)"
                
                return .assign(value: value, botID: botID)
            } else {
                let giverID = "bot \(components[1])"
                let lowPrefix = components[5]
                let lowID = "\(lowPrefix) \(components[6])"
                let highPrefix = components[10]
                let highID = "\(highPrefix) \(components[11])"
                
                return .give(giverID: giverID, lowID: lowID, highID: highID)

            }
        }
    }
    
    class Bot {
        let id: String
        var values: [Int] = []
        
        init(id: String) {
            self.id = id
        }
        
        var canGive: Bool {
            return self.values.count == 2
        }
        
        var isOutput: Bool {
            return self.id.contains("output")
        }
        
        var canReceive: Bool {
            self.isOutput || self.values.count < 2
        }
        
        func receive(value: Int) {
            guard self.canReceive else { fatalError("Can't receive values!") }
            self.values.append(value)
        }
        
        var highValue: Int {
            return self.values.max()!
        }
        
        var lowValue: Int {
            return self.values.min()!
        }
        
        func clear() {
            self.values = []
        }
    }
    
    class Manager {
        var bots: [Bot] = []
        var instructions: [Instruction] = []
        var targetBotID: String!
        
        func start(with instructions: [Instruction], lookFor values: [Int]) {
            self.instructions = instructions
            while !self.instructions.isEmpty {
                self.instructions.removeAll(where: {self.apply(instruction: $0, lookFor: values)})
            }
        }
        
        private func apply(instruction: Instruction, lookFor values: [Int]) -> Bool {
            switch instruction {
            case .give(let giverID, let lowID, let highID):
                let giverBot = self.findOrCreateBot(with: giverID)
                let lowBot = self.findOrCreateBot(with: lowID)
                let highBot = self.findOrCreateBot(with: highID)
                
                guard giverBot.canGive && highBot.canReceive && lowBot.canReceive else { return false }
                
                if giverBot.highValue == values.max()! && giverBot.lowValue == values.min()! {
                    self.targetBotID = giverBot.id
                }
                
                lowBot.receive(value: giverBot.lowValue)
                highBot.receive(value: giverBot.highValue)
                giverBot.clear()
            case .assign(let value, let botID):
                let bot = self.findOrCreateBot(with: botID)
                guard bot.canReceive else { return false }
                
                bot.receive(value: value)
            }
            
            return true
        }
        
        private func findOrCreateBot(with id: String) -> Bot {
            if let found = self.bots.first(where: {$0.id == id}) {
                return found
            }
            let newBot = Bot(id: id)
            self.bots.append(newBot)
            return newBot
        }
        
        func getValues(for botID: String) -> [Int] {
            guard let found = self.bots.first(where: {$0.id == botID}) else { fatalError("Bot not found") }
            return found.values
        }
    }
    
    private var instructions: [Instruction] = []
    
    func loadInput() {
        self.instructions = self.defaultInputFileString.loadAsTextStringArray().map({Instruction.from(string: $0)})
    }
    
    func solveFirst() {
        let manager = Manager()
        let values = [61, 17]
        manager.start(with: self.instructions, lookFor: values)
        self.setSolution(challenge: 0, text: manager.targetBotID)
    }
    
    func solveSecond() {
        let manager = Manager()
        let values = [61, 17]
        manager.start(with: self.instructions, lookFor: values)
        let outputIDs = ["output 0", "output 1", "output 2"]
        let product = outputIDs
            .map({manager.getValues(for: $0)
                .reduce(1, *)})
            .reduce(1, *)
        
        self.setSolution(challenge: 1, text: "\(product)")
    }
}

extension Day10VC: TestableDay {
    private var testInput: String {
        """
        value 5 goes to bot 2
        bot 2 gives low to bot 1 and high to bot 0
        value 3 goes to bot 1
        bot 1 gives low to output 1 and high to bot 0
        bot 0 gives low to output 2 and high to output 0
        value 2 goes to bot 2
        """
    }
    
    func runTests() {
        let arrayed = self.testInput.components(separatedBy: "\n")
        let instructions = arrayed.map({Instruction.from(string: $0)})
        let manager = Manager()
        manager.start(with: instructions, lookFor: [5, 2])
        assert(manager.targetBotID == "bot 2")
    }
}
