//
//  File.swift
//  
//
//  Created by Alex Kostenko on 03.12.2023.
//

import Foundation

struct Day03: AdventDay {
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
    let lines = lines()
    for (lineIndex, line) in lines.enumerated() {
      let startLineIndex = lineIndex > 0 ? lineIndex - 1 : 0
      let endLineIndex = lineIndex < lines.count - 1 ? lineIndex + 1 : lines.count - 1
      var iterator = NumbersIterator(line: line)
      while let info = iterator.next() {
        for checkedLineIndex in startLineIndex ... endLineIndex {
          if lines[checkedLineIndex].numberHasAdjacentSymbol(numberIndexes: (info.start, info.end)) {
            sum += info.value
            break
          }
        }
      }
    }
    return sum
  }

  func part2() -> Any {
    var sum: UInt64 = 0
    let lines = lines()
    for (lineIndex, line) in lines.enumerated() {
      let startLineIndex = lineIndex > 0 ? lineIndex - 1 : 0
      let endLineIndex = lineIndex < lines.count - 1 ? lineIndex + 1 : lines.count - 1
      var iterator = GearIterator(line: line)
      while let gearIndex = iterator.next() {
        let adjacentIndicesInfo = (startLineIndex ... endLineIndex).reduce(into: [((Int, Int), Int)]()) { result, lineIndex in
          if let singleIndices = lines[lineIndex].numberIndices(position: gearIndex) {
            result.append((singleIndices, lineIndex))
          } else {
            if let leftIndices = lines[lineIndex].numberIndices(position: gearIndex - 1) {
              result.append((leftIndices, lineIndex))
            }

            if let rightIndices = lines[lineIndex].numberIndices(position: gearIndex + 1) {
              result.append((rightIndices, lineIndex))
            }
          }
        }

        if adjacentIndicesInfo.count == 2 {
          sum += adjacentIndicesInfo.map { info in
            lines[info.1].number(indices: info.0)
          }
          .reduce(1, *)
        }
      }
    }

    return sum
  }
}

private struct GearIterator: IteratorProtocol {
  let line: String

  init(line: String) {
    self.line = line
  }

  mutating func next() -> Int? {
    while position < line.count, line[line.index(line.startIndex, offsetBy: position)] != "*" {
      position += 1
    }

    guard position < line.count else {
      return nil
    }

    let result = position
    position += 1
    return result
  }

  private var position = 0
}

private struct NumbersIterator: IteratorProtocol {
  let line: String

  init(line: String) {
    self.line = line
  }

  mutating func next() -> NumberInfo? {
    guard position < line.count,
          let numberIndexes = line.nextNumberIndexes(start: position)
    else {
      return nil
    }

    position = numberIndexes.1 + 1

    let startIndex = line.index(line.startIndex, offsetBy: numberIndexes.0)
    let endIndex = line.index(line.startIndex, offsetBy: numberIndexes.1)

    return .init(start: numberIndexes.0, end: numberIndexes.1, raw: String(line[startIndex ... endIndex]))
  }

  struct NumberInfo {
    let start: Int
    let end: Int
    let raw: String

    var value: UInt64 {
      UInt64(raw)!
    }
  }

  private var position = 0
}

extension String {
  fileprivate func nextNumberIndexes(start: Int) -> (Int, Int)? {
    var numberStart = start
    while numberStart < count {
      if self[index(startIndex, offsetBy: numberStart)].isNumber {
        break
      }

      numberStart += 1
    }

    guard numberStart < count else {
      return nil
    }

    var endIndex = numberStart

    while endIndex < count - 1 {
      let nextIndex = endIndex + 1
      if self[index(startIndex, offsetBy: nextIndex)].isNumber {
        endIndex = nextIndex
      } else {
        break
      }
    }

    return (numberStart, endIndex)
  }

  fileprivate func numberHasAdjacentSymbol(numberIndexes: (Int, Int)) -> Bool {
    let start = numberIndexes.0 - 1 > 0 ? numberIndexes.0 - 1 : 0
    let end = numberIndexes.1 + 1 < count ? numberIndexes.1 + 1 : count - 1

    for lineIndex in (start ... end) {
      if self[index(startIndex, offsetBy: lineIndex)].isSymbol() {
        return true
      }
    }

    return false
  }

  fileprivate func numberIndices(position: Int) -> (Int, Int)? {
    guard position >= 0,
          position < count,
          self[index(startIndex, offsetBy: position)].isNumber
    else {
      return nil
    }

    var start = position
    var prev = start - 1
    while prev >= 0, self[index(startIndex, offsetBy: prev)].isNumber {
      start = prev
      prev -= 1
    }

    var end = position
    var next = end + 1
    while next < count, self[index(startIndex, offsetBy: next)].isNumber {
      end = next
      next += 1
    }

    return (start, end)
  }

  fileprivate func number(indices: (Int, Int)) -> UInt64 {
    let start = index(startIndex, offsetBy: indices.0)
    let end = index(startIndex, offsetBy: indices.1)
    return UInt64(self[start ... end])!
  }
}

extension Character {
  fileprivate func isSymbol() -> Bool {
    !isNumber && self != "."
  }
}
