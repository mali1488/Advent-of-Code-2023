import Foundation

var standardError = FileHandle.standardError

extension FileHandle: TextOutputStream {
  public func write(_ string: String) {
    let data = Data(string.utf8)
    self.write(data)
  }
}

enum Common {
    static func readFile(path: String) -> String? {
        do {
            return try String(contentsOfFile: path, encoding: .utf8)
        } catch {
            print("[ERROR]: Failed to read file - \(error.localizedDescription)", to: &standardError)
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
