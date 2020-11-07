//
//  Day09VC.swift
//  AdventOfCode2016
//
//  Created by Geir-Kåre S. Wærp on 06/11/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day09VC: AoCVC, AdventDay, InputLoadable {
    private var input: String!
    
    func loadInput() {
        self.input = self.defaultInputFileString.loadAsTextString().trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func solveFirst() {
        let decompressed = self.decompress(string: self.input!)
        let count = decompressed.filter({!$0.isWhitespace}).count
        self.setSolution(challenge: 0, text: "\(count)")
    }
    
    func solveSecond() {
        let decompressedCount = self.getDecompressedCountV2(string: self.input!)
        self.setSolution(challenge: 1, text: "\(decompressedCount)")
    }
    
    private func decompress(string input: String) -> String {
        var decompressed = ""
        
        let arrayed = input.toStringArray()
        var isInMarkerMode = false
        
        var rangeStart = 0
        var rangeEnd = 0
        
        var numLettersToRepeat = 0
        var numRepetitions = 0
        
        var index = 0
        while index < arrayed.count {
            let letter = arrayed[index]
            if letter == "(" && !isInMarkerMode {
                rangeStart = index + 1
                isInMarkerMode = true
                index += 1
                continue
            }
            else if letter == ")" && isInMarkerMode {
                rangeEnd = index - 1
                isInMarkerMode = false
                
                let marker = arrayed[rangeStart...rangeEnd].joined(separator: "")
                let parts = marker.components(separatedBy: "x")
                numLettersToRepeat = parts[0].intValue!
                numRepetitions = parts[1].intValue!
                
                let repeatStartIndex = index + 1
                let repeatEndIndex = repeatStartIndex + numLettersToRepeat
                let lettersToRepeat = arrayed[repeatStartIndex..<repeatEndIndex].joined(separator: "")
                for _ in 0..<numRepetitions {
                    decompressed.append(lettersToRepeat)
                }
                
                index += numLettersToRepeat + 1
                
                continue
            }
            
            if !isInMarkerMode {
                decompressed.append(letter)
            }
            
            index += 1
        }
        
        return decompressed
    }
    
    private func getDecompressedCountV2(string input: String) -> Int {
        var count = 0
        
        let arrayed = input.toStringArray()
        var isInMarkerMode = false
        
        var rangeStart = 0
        var rangeEnd = 0
        
        var numLettersToRepeat = 0
        var numRepetitions = 0
        
        var index = 0
        while index < arrayed.count {
            let letter = arrayed[index]
            if letter == "(" && !isInMarkerMode {
                rangeStart = index + 1
                isInMarkerMode = true
                index += 1
                continue
            }
            else if letter == ")" && isInMarkerMode {
                rangeEnd = index - 1
                isInMarkerMode = false
                
                let marker = arrayed[rangeStart...rangeEnd].joined(separator: "")
                let parts = marker.components(separatedBy: "x")
                numLettersToRepeat = parts[0].intValue!
                numRepetitions = parts[1].intValue!
                
                let repeatStartIndex = index + 1
                let repeatEndIndex = (repeatStartIndex + numLettersToRepeat - 1).clamp(max: arrayed.count - 1)
                if repeatEndIndex >= repeatStartIndex {
                    let lettersToRepeat = arrayed[repeatStartIndex...repeatEndIndex].joined(separator: "")
                    let numDecompressedLettersToRepeat = self.getDecompressedCountV2(string: lettersToRepeat)
                    count += numDecompressedLettersToRepeat * numRepetitions
                    
                    index += numLettersToRepeat + 1
                    
                    continue
                }
            }
            
            if !isInMarkerMode && !letter.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                count += 1
            }
            
            index += 1
        }
        return count
    }
}

extension Day09VC: TestableDay {
    func runTests() {
        assert(self.decompress(string: "ADVENT") == "ADVENT")
        assert(self.decompress(string: "A(1x5)BC") == "ABBBBBC")
        assert(self.decompress(string: "(3x3)XYZ") == "XYZXYZXYZ")
        assert(self.decompress(string: "A(2x2)BCD(2x2)EFG") == "ABCBCDEFEFG")
        assert(self.decompress(string: "(6x1)(1x3)A") == "(1x3)A")
        assert(self.decompress(string: "X(8x2)(3x3)ABCY") == "X(3x3)ABC(3x3)ABCY")
        
        assert(self.getDecompressedCountV2(string: "ADVENT") == "ADVENT".count)
        assert(self.getDecompressedCountV2(string: "(3x3)XYZ") == "XYZXYZXYZ".count)
        assert(self.getDecompressedCountV2(string: "X(8x2)(3x3)ABCY") == "XABCABCABCABCABCABCY".count)
        assert(self.getDecompressedCountV2(string: "(27x12)(20x12)(13x14)(7x10)(1x12)A") == 241920)
        assert(self.getDecompressedCountV2(string: "(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN") == 445)
    }
}
