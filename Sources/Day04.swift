//
//  File.swift
//
//
//  Created by Alex Kostenko on 03.12.2023.
//

import Foundation

struct Day04: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  func lines() -> [String] {
    data.split(separator: "\n").map {
      String($0)
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    var sum: UInt64 = 0
    for line in lines() {
      let whole = line.split(separator: ":")[1].split(separator: "|")
      let winning = whole[0].trimmingCharacters(in: .whitespaces).split(separator: " ").compactMap { Int($0) }
      let mine = whole[1].trimmingCharacters(in: .whitespaces).split(separator: " ").compactMap { Int($0) }
      let matches = winning.reduce(into: 0) { result, value in
        if mine.contains(value) {
          result += 1
        }
      }

      if matches > 0 {
        sum += NSDecimalNumber(decimal: pow(2, matches - 1)).uint64Value
      }
    }
    return sum
  }
}
