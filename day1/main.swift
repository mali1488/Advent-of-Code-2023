import Foundation

private func _solvePartOne() {
    let input = Common.readAndSplitFileByNewLine(path: "input.txt")
    let answer = input.compactMap { line -> Int? in
        let numbers = line.compactMap { $0.wholeNumberValue }
        let first = numbers.first ?? 0
        let last = numbers.last ?? 0
        return first * 10 + last
     }
     .reduce(0, +)

     print("Part 1: The sum of all the calibration values are: \(answer)")
}

private func _solvePartTwo() {
    func _parseLineToNumbers(_ s: String) -> [Int] {
        let wordsToInt: [String: Int] = ["one": 1, "two": 2, "three": 3, "four": 4, "five": 5, "six": 6, "seven": 7, "eight": 8, "nine": 9]
        return s.enumerated()
            .compactMap { offset, char in
                let subString = s.dropFirst(offset)
                if let numberFromWord = wordsToInt.first(where: { key, _ in subString.hasPrefix(key) }) {
                    return numberFromWord.value
                }
                return char.wholeNumberValue
            }
    }

    let input = Common.readAndSplitFileByNewLine(path: "input.txt")
    let answer = input.compactMap { line -> Int? in
        let numbers = _parseLineToNumbers(line)
        let first = numbers.first ?? 0
        let last = numbers.last ?? 0
        return first * 10 + last
     }
     .reduce(0, +)
    
    print("Part 2: The sum of all the calibration values are: \(answer)")
}

_solvePartOne()
_solvePartTwo()