//
//  Day07VC.swift
//  AdventOfCode2016
//
//  Created by Geir-Kåre S. Wærp on 06/11/2020.
//  Copyright © 2020 Geir-Kåre S. Wærp. All rights reserved.
//

import UIKit

class Day07VC: AoCVC, AdventDay, InputLoadable {
    struct IP {
        let string: String
        
        private var supernetSequences: [String] {
            var trimmed = self.string
            while let start = trimmed.firstIndex(of: "["), let end = trimmed.firstIndex(of: "]") {
                let range = start...end
                trimmed = trimmed.replacingCharacters(in: range, with: "_")
            }
            
            return trimmed.components(separatedBy: "_")
        }
        
        private var hypernetSequences: [String] {
            var result: [String] = []
            var trimmed = self.string
            while let start = trimmed.firstIndex(of: "["), let end = trimmed.firstIndex(of: "]") {
                let range = start...end
                let substring = trimmed[range].replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
                result.append(substring)
                trimmed = trimmed.replacingCharacters(in: range, with: "_")
            }
            return result
        }
        
        var supportsTLS: Bool {
            guard self.hypernetSequences.allSatisfy({!self.contains_abba(string: $0)}) else { return false }
            return !self.supernetSequences.allSatisfy({!self.contains_abba(string: $0)})
        }
        
        private func contains_abba(string: String) -> Bool {
            let arrayed = string.toStringArray()
            
            for (index, letter) in arrayed.enumerated() {
                guard index < arrayed.count - 3 else { continue }
                guard letter == arrayed[index + 3] else { continue }
                guard letter != arrayed[index + 1] else { continue }
                guard arrayed[index + 1] == arrayed[index + 2] else { continue }
                
                return true
            }
            
            return false
        }
        
        var supportsSSL: Bool {
            for supernetSequence in self.supernetSequences {
                let abas = self.contains_aba(string: supernetSequence, aba: nil)
                for hypernetSequence in self.hypernetSequences {
                    for aba in abas {
                        if !self.contains_aba(string: hypernetSequence, aba: (a: aba.b, b: aba.a)).isEmpty {
                            return true
                        }
                    }
                }
            }
            return false
        }
        
        private func contains_aba(string: String, aba: (a: String, b: String)?) -> [(a: String, b: String)] {
            var results: [(a: String, b: String)] = []
            let arrayed = string.toStringArray()
            for (index, letter) in arrayed.enumerated() {
                guard index < arrayed.count - 2 else { continue }
                guard letter != arrayed[index + 1] else { continue }
                guard letter == arrayed[index + 2] else { continue }
                if let aba = aba {
                    guard letter == aba.a else { continue }
                    guard arrayed[index + 1] == aba.b else { continue }
                }
                results.append((a: letter, b: arrayed[index + 1]))
            }
            return results
        }
    }
    
    private var ips: [IP] = []
    
    func loadInput() {
        self.ips = self.defaultInputFileString.loadAsTextStringArray().map({IP(string: $0)})
    }
    
    func solveFirst() {
        let filtered = self.ips.filter({$0.supportsTLS})
        self.setSolution(challenge: 0, text: "\(filtered.count)")
    }
    
    func solveSecond() {
        let filtered = self.ips.filter({$0.supportsSSL})
        self.setSolution(challenge: 1, text: "\(filtered.count)")
    }
}

extension Day07VC: TestableDay {
    func runTests() {
        let ips = """
abba[mnop]qrst
abcd[bddb]xyyx
aaaa[qwer]tyui
ioxxoj[asdfgh]zxcvbn
""".components(separatedBy: "\n")
    .map({IP(string: $0)})
        
        assert(ips[0].supportsTLS == true)
        assert(ips[1].supportsTLS == false)
        assert(ips[2].supportsTLS == false)
        assert(ips[3].supportsTLS == true)
        
        
        let ip1 = IP(string: "rnqfzoisbqxbdlkgfh[lwlybvcsiupwnsyiljz]kmbgyaptjcsvwcltrdx[ntrpwgkrfeljpye]jxjdlgtntpljxaojufe")
        assert(ip1.supportsTLS == false)
        
        let ip2 = IP(string: "aba[bab]xyz")
        assert(ip2.supportsSSL == true)
        
        let ip3 = IP(string: "xyx[xyx]xyx")
        assert(ip3.supportsSSL == false)
        
        let ip4 = IP(string: "aaa[kek]eke")
        assert(ip4.supportsSSL == true)
        
        let ip5 = IP(string: "zazbz[bzb]cdb")
        assert(ip5.supportsSSL == true)
    }
}
