//
//  Day04VC.swift
//  AdventOfCode2016
//
//  Created by Geir-Kåre S. Wærp on 05/11/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day04VC: AoCVC, AdventDay, InputLoadable {
    struct Room {
        let encryptedName: String
        let sectorID: Int
        let checksum: String
        
        var calculatedChecksum: String {
            var letterOccurrences: [String : Int] = [:]
            let letters = encryptedName.toStringArray()
            for letter in  letters {
                if letter == "-" {
                    continue
                }
                
                letterOccurrences[letter, default: 0] += 1
            }
            
            let sorted = letterOccurrences.keys.sorted(by: { (key1, key2) -> Bool in
                let occurrences1 = letterOccurrences[key1, default: 0]
                let occurrences2 = letterOccurrences[key2, default: 0]
                
                if occurrences1 == occurrences2 {
                    return key1 < key2
                }
                return occurrences1 > occurrences2
                }).prefix(5)
            
            return sorted.joined(separator: "")
        }
        
        var isReal: Bool {
            return self.calculatedChecksum == self.checksum
            
        }
        
        static func from(string: String) -> Room {
            let components = string.components(separatedBy: "[")
            let checksum = components[1].replacingOccurrences(of: "]", with: "")
            let parts = components[0].components(separatedBy: "-")
            let sectorID = parts.last!.intValue!
            let lettersCount = parts.count - 1
            let encryptedName = parts[0..<lettersCount].joined(separator: "-")
            
            return Room(encryptedName: encryptedName, sectorID: sectorID, checksum: checksum)
        }
        
        var decryptedName: String {
            var result: String = ""
            
            for letter in self.encryptedName {
                guard letter != "-" else {
                    result.append(" ")
                    continue
                }
                let valueA = Character("a").asciiValue!
                let shiftedValue = letter.asciiValue! - valueA
                let newLetterValue = (shiftedValue + UInt8(self.sectorID % 26)) % 26 + valueA
                let newLetter = String(UnicodeScalar(newLetterValue))
                result.append(newLetter)
            }
            
            return result
        }
    }
    
    private var rooms: [Room] = []
    
    func loadInput() {
        self.rooms = self.defaultInputFileString.loadAsTextStringArray().map({Room.from(string: $0)})
        
    }
    
    func solveFirst() {
        let sectorSum = self.rooms.filter({$0.isReal}).map({$0.sectorID}).reduce(0, +)
        self.setSolution(challenge: 0, text: "\(sectorSum)")
    }
    
    func solveSecond() {
        let targetRoom = self.rooms.filter({$0.isReal}).filter({$0.decryptedName.contains("north")})
        self.setSolution(challenge: 1, text: "\(targetRoom.first!.sectorID)")
    }
}

extension Day04VC: TestableDay {
    func runTests() {
        let rooms = ["aaaaa-bbb-z-y-x-123[abxyz]",
            "a-b-c-d-e-f-g-h-987[abcde]",
            "not-a-real-room-404[oarel]",
            "totally-real-room-200[decoy]"].map({Room.from(string: $0)})
        assert(rooms[0].checksum == "abxyz")
        assert(rooms[1].checksum == "abcde")
        assert(rooms[2].checksum == "oarel")
        assert(rooms[3].checksum == "decoy")
        
        assert(rooms[0].sectorID == 123)
        assert(rooms[1].sectorID == 987)
        assert(rooms[2].sectorID == 404)
        assert(rooms[3].sectorID == 200)
        
        assert(rooms[0].isReal == true)
        assert(rooms[1].isReal == true)
        assert(rooms[2].isReal == true)
        assert(rooms[3].isReal == false)
                
        let room2 = Room(encryptedName: "qzmt-zixmtkozy-ivhz", sectorID: 343, checksum: "")
        assert(room2.decryptedName == "very encrypted name")
        
        let room3 = Room(encryptedName: "abcdefghijklmnopqrstuvwxyz", sectorID: 1, checksum: "")
        assert(room3.decryptedName == "bcdefghijklmnopqrstuvwxyza")
    }
}
