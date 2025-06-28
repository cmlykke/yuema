import gleam/dict.{type Dict}
import gleam/list
import gleam/regexp
import gleam/result
import gleam/string
import gleam/option.{Some}
import simplifile

// Path to the Conway official file
const conwayofficial_file_path = "./src/resources/other/codepoint-character-sequence.txt"

pub fn parse_conway_files() -> Result(Dict(String, String), String) {
  // Read the file using simplifile
  case simplifile.read(from: conwayofficial_file_path) {
    Ok(content) -> {
      // Compile regex for valid lines: Unicode code point, character, stroke sequence
      let assert Ok(re) = regexp.from_string(
//    "^U\\+[0-9A-F]{4,6}\\s+([^\\x00-\\x{2E7E}][*^]?)\\s+([0-9|()]+)(?:\\s*.*)?$",
      "^U\\+[0-9A-F]{4,6}\\s+([\\u2E7F-\\u{10FFFF}][*^]?)\\s+([0-9|()]+)(?:\\s*.*)?$",
      )

      // Process lines
      let dictionary = content
      |> string.split("\n")
      |> list.filter(fn(line) { string.trim(line) != "" })
      |> list.fold(
      dict.new(),
      fn(acc, line) {
        // Use regexp.scan to get matches
        let matches = regexp.scan(with: re, content: line)
        case matches {
          [regexp.Match(content: _, submatches: [Some(char), Some(stroke_seq)])] -> {
            // Clean the character (remove optional * or ^)
            let clean_char = char
            |> string.replace("*", "")
            |> string.replace("^", "")
            // Insert character and stroke sequence into dictionary
            dict.insert(acc, clean_char, stroke_seq)
          }
          _ -> acc // Skip lines that don't match or have incorrect submatches
        }
      },
      )

      Ok(dictionary)
    }
    Error(error) -> Error("Failed to read file: " <> simplifile.describe_error(error))
  }
}