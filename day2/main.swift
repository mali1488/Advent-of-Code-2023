import Foundation

struct Game {
    enum Cube {
        case red(Int)
        case green(Int)
        case blue(Int)

        var isRed: Bool { 
            switch self {
                case .red: return true
                default: return false
            }
         }

        var isGreen: Bool { 
            switch self {
                case .green: return true
                default: return false
            }
        }

        var isBlue: Bool {
            switch self {
                case .blue: return true
                default: return false
            }
        }

        var count: Int {
            switch self {
                case let .red(count), let .green(count), let .blue(count):
                return count
            }
        }

        var isPossible: Bool {
            switch self {
                case .red(let count): return count < 13
                case .green(let count): return count < 14
                case .blue(let count): return count < 15
            }
        }

        static func fromString(str: String, count: Int) -> Cube? {
            switch str {
                case "red": return .red(count)
                case "green": return .green(count)
                case "blue": return .blue(count)
                default: return nil
            }
        }
    }
    struct Set {
        let cubes: [Cube]
        
        var isPossible: Bool {
            cubes.allSatisfy { $0.isPossible }
        }

        var maxRed: Int {
            cubes.filter { $0.isRed }.map { $0.count }.reduce(0, +)
        }
        var maxGreen: Int {            
            cubes.filter { $0.isGreen }.map { $0.count }.reduce(0, +)
        }
        var maxBlue: Int {
            cubes.filter { $0.isBlue }.map { $0.count }.reduce(0, +)
        }
    }
    var isPossible: Bool {
        sets.allSatisfy { $0.isPossible }
    }
    let sets: [Set]
    let id: Int
}

private func _parseToGame(line: String) -> Game? {
    let lines = line.components(separatedBy: ":")
    guard let gameId = lines.first?.components(separatedBy: " ").last else {
        return nil
    }
    guard let lineSets = lines.last else {
        return nil
    }
    let sets: [Game.Set] = lineSets
        .components(separatedBy: ";")
        .map { $0.trimmingCharacters(in: .whitespaces) }
        .compactMap { set -> [Game.Cube] in
            return set.components(separatedBy: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .map { $0.components(separatedBy: " ") }
                .compactMap { setStr -> Game.Cube? in
                    switch (setStr.first, setStr.last) {
                    case (.some(let count), .some(let color)):
                        return Int(count).map { Game.Cube.fromString(str: color, count: $0) } ?? nil
                    default: return nil
                    }
                }
        }
        .map { Game.Set(cubes: $0) }
    return Game(sets: sets, id: Int(gameId)!)
}

private func _solvePartOne() {
    let input = Common.readAndSplitFileByNewLine(path: "input.txt")
    let games = input.compactMap { _parseToGame(line: $0) }
    let answer = games.filter { $0.isPossible }.map { $0.id }.reduce(0, +)
    
    print("The sum of all possible games are: \(answer)")
}

private func _solvePartTwo() {
    let input = Common.readAndSplitFileByNewLine(path: "input.txt")
    let games = input.compactMap { _parseToGame(line: $0) }
    let answer = games.map { game in
        let maxRed = game.sets.map { $0.maxRed }.max() ?? 0
        let maxGreen = game.sets.map { $0.maxGreen }.max() ?? 0
        let maxBlue = game.sets.map { $0.maxBlue }.max() ?? 0
        return maxRed * maxGreen * maxBlue
    }.reduce(0, +)
    
    print("The sum of the power of the sets: \(answer)")
}

_solvePartOne()
_solvePartTwo()
