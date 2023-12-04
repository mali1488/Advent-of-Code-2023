import Foundation

private var _standardError = FileHandle.standardError

extension FileHandle: TextOutputStream {
  public func write(_ string: String) {
    let data = Data(string.utf8)
    self.write(data)
  }
}

func logError(_ error: String) {
    print("[ERROR]: \(error)", to: &_standardError)
}

enum Common {
    static func readFile(path: String) -> String? {
        do {
            return try String(contentsOfFile: path, encoding: .utf8)
        } catch {
            logError("Failed to read file - \(error.localizedDescription)")
            return nil
        }
    }

    static func readAndSplitFileByNewLine(path: String) -> [String] {
        guard let content = readFile(path: path) else {
            return []
        }
        return content.components(separatedBy: "\n").filter { $0 != "" }
    }
}

extension Array {
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}

extension Int {
    static func power(_ val: Int, _ exponent: Int) -> Int {
        pow(Decimal(val), exponent).asInt
    }
}

extension Decimal {
    var asInt: Int {
        NSDecimalNumber(decimal: self).intValue
    }
}

extension String {
    func toInts() -> [Int] {
        components(separatedBy: " ")
            .compactMap { $0.trimmingCharacters(in: .whitespaces) }
            .compactMap { Int($0) }
    }
}