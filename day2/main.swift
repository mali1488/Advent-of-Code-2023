import Foundation

struct Game {
    struct Cube {
        enum Color {
            case red
            case green
            case blue

            static func fromString(str: String) -> Color? {
                switch str {
                    case "red": return .red
                    case "green": return .green
                    case "blue": return .blue
                    default: return nil
                }
            }
        }
        let color: Color
        let count: Int

        var isPossible: Bool {
            switch self.color {
                case .red: return count < 13
                case .green: return count < 14
                case .blue: return count < 15
            }
        }
    }
    struct Set {
        let cubes: [Cube]
        
        var isPossible: Bool {
            cubes.allSatisfy { $0.isPossible }
        }

        var maxRed: Int {
            cubes.filter { $0.color == .red }.map { $0.count }.reduce(0, +)
        }
        var maxGreen: Int {            
            cubes.filter { $0.color == .green }.map { $0.count }.reduce(0, +)
        }
        var maxBlue: Int {
            cubes.filter { $0.color == .blue }.map { $0.count }.reduce(0, +)
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
                        guard 
                            let color = Game.Cube.Color.fromString(str: color),
                            let count = Int(count) 
                        else {
                            return nil
                        }
                        return Game.Cube(color: color, count: count)
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
