import XCTest

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day03Tests: XCTestCase {
  // Smoke test data provided in the challenge question
  let testData = """
    1...2....3$
    *...44..*..
    ...$..61..$
    """

  let testData2 = """
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
    """

  func testPart1() throws {
    let challenge = Day03(data: testData)
    XCTAssertEqual(String(describing: challenge.part1()), "109")
  }

  func testPart2() throws {
    let challenge = Day03(data: testData2)
    XCTAssertEqual(String(describing: challenge.part2()), "467835")
  }
}

