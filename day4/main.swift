import Foundation

struct Card {
    let id: Int
    let winingNumbers: [Int]
    let myNumbers: [Int]

    var matching: Int {
        Set(myNumbers).intersection(winingNumbers).count
    }

    var points: Int {
        guard matching > 0 else { return 0 }
        return Int.power(2, matching - 1)
    }
}

private func _parseLineToCard(id: Int, line: String) -> Card {
    let numbers = line.components(separatedBy: ":").last!.components(separatedBy: "|")
    let winingNumbers = numbers.first!.toInts()
    let myNumbers = numbers.last!.toInts()
    return Card(id: id, winingNumbers: winingNumbers, myNumbers: myNumbers)
}

private func _solvePartOne() {
    let input = Common.readAndSplitFileByNewLine(path: "input.txt")
    let cards = input.enumerated().map { offset, line in _parseLineToCard(id: offset + 1, line: line) }
    let answer = cards.map { $0.points }.reduce(0, +)
    print("answer 1: \(answer)")
}

private func _solvePartTwo() {
    let input = Common.readAndSplitFileByNewLine(path: "input.txt")
    let cards = input.enumerated().map { offset, line in _parseLineToCard(id: offset + 1, line: line) }
    var copies: [Int: Int] = [:]
    cards.forEach { copies[$0.id] = 1 }
    let answer = cards
        .reduce(into: copies, { acc, card in
            guard card.matching > 0 else {
                return
            }
            let count = acc[card.id]!
            for i in 1...card.matching {
                let curr = acc[i + card.id] ?? 1
                acc[i + card.id] = curr + count
            }
        })
        .map { $0.value }
        .reduce(0, +)
    print("answer 2: \(answer)")
}

_solvePartOne()
_solvePartTwo()
