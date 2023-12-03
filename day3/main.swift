import Foundation

struct Engine {
    enum Part {
        case number(Int)
        case dot
        case symbol
        case gear

        var number: Int? {
            switch self {
                case .number(let number): return number
                default: return nil
            }
        }

        var isSymbol: Bool {
            switch self {
                case .symbol, .gear: return true
                case .number: return false
                default: return false
            }
        }

        var isGear: Bool {
            switch self {
                case .gear: return true
                default: return false
            }
        }

        static func fromString(_ s: Character) -> Part? {
            if let number = s.wholeNumberValue {
                return .number(number)
            }
            if s == "." {
                return .dot
            }
            if s == "*" {
                return .gear
            }
            return .symbol
        }
    }
    let schema: [[Part]]

    private func _getPartAt(x: Int, y: Int) -> Engine.Part? {
        schema[safeIndex: x]?[safeIndex: y]
    }

    private func _isSymbolAt(x: Int, y: Int) -> Bool {
        _getPartAt(x: x, y: y)?.isSymbol ?? false
    }

    private func _isNumberAt(x: Int, y: Int) -> Bool {
        guard let part = _getPartAt(x: x, y: y) else { return false }
        return part.number != nil
    }

    func hasAdjacentSymbolsAt(row: Int, column: Int) -> Bool {
        for x in [-1, 0, 1] {
            for y in [-1, 0, 1] {
                if x == 0 && y == 0 {   
                    continue 
                }
                if _isSymbolAt(x: x + row, y: y + column) {
                    return true
                }
            }
        }
        return false
    }

    private func _getWholeNumberPartRight(row: Int, column: Int) -> Int? {
        var index = column
        var result = ""
        while index < schema[row].count {
            if let number = _getPartAt(x: row, y: index)?.number {
                result += "\(number)"
                index += 1
            } else {
                break
            }
        }
        return Int(result)
    }

    private func _getWholeNumberFrom(row: Int, column: Int) -> Int? {
        var probe = column
        while _isNumberAt(x: row, y: probe) && _isNumberAt(x: row, y: probe - 1) {
            probe -= 1
        }
        return _getWholeNumberPartRight(row: row, column: probe)
    }

    private func _getRowNumbersAt(row: Int, column: Int) -> [Int] {
        if !_isNumberAt(x: row, y: column) {
            return [
                _getWholeNumberFrom(row: row, column: column + 1),
                _getWholeNumberFrom(row: row, column: column - 1),
            ]
            .compactMap { $0 }
        }
        return [_getWholeNumberFrom(row: row, column: column)]
            .compactMap { $0 }
    }

    func getAdjacentNumbers(row: Int, column: Int) -> [Int] {
        var result: [Int] = []
        if let leading = _getWholeNumberFrom(row: row, column: column - 1) {
            result.append(leading)
        }
        if let trailing = _getWholeNumberFrom(row: row, column: column + 1) {
            result.append(trailing)
        }
        let top = _getRowNumbersAt(row: row - 1, column: column)
        let bottom = _getRowNumbersAt(row: row + 1, column: column)
        return result + top + bottom
    }
}

private func _parseInputToEngine(_ input: [String]) -> Engine {
    let schema: [[Engine.Part]] = input
        .map { line -> [Engine.Part] in
            line.compactMap { Engine.Part.fromString($0) }
        }
    return Engine(schema: schema)
}

private func _solvePartOne() {
    let input = Common.readAndSplitFileByNewLine(path: "input.txt")
    let engine = _parseInputToEngine(input)
    
    let answer = engine.schema
        .enumerated()
        .flatMap { row, rowParts -> [Int] in
            return rowParts.enumerated()
                .split(whereSeparator: { offset, part in 
                    return part.number == nil
                })
                .compactMap { elem -> Int? in 
                    let include = elem.contains(where: { offset, part in
                        return engine.hasAdjacentSymbolsAt(row: row, column: offset)
                    })
                    guard include else { return nil }
                    return elem.compactMap { _, part in part.number }
                        .reduce(0, { $0 * 10 + $1 })
                }
        }
        .reduce(0, +)
    print("The sum of all parts numbers is: \(answer)")
}

private func _solvePartTwo() {
    struct Gear {
        let x: Int
        let y: Int
    }
    let input = Common.readAndSplitFileByNewLine(path: "input.txt")
    let engine = _parseInputToEngine(input)

    let gears: [Gear] = engine.schema
        .enumerated()
        .flatMap { row, rowParts in 
            rowParts
                .enumerated()
                .compactMap { column, part in
                    guard part.isGear else { return nil }
                    return Gear(x: row, y: column)
            }
        }
    let answer = gears
        .compactMap { gear -> Int? in
            let adjacentNumbers = engine.getAdjacentNumbers(row: gear.x, column: gear.y)
            guard adjacentNumbers.count == 2 else { return nil }
            return adjacentNumbers.reduce(1, *)
        }
        .reduce(0, +)
    print("The sum of all gear ratios is: \(answer)")
}

_solvePartOne()
_solvePartTwo()
