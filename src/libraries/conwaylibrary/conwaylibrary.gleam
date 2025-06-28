import gleam/string
import gleam/list
import gleam/set.{type Set}
import gleam/dict.{type Dict}
import gleam/result
import gleam/regexp
import gleam/option.{Some} // Import Option module and Some constructor
import simplifile

// Path to the Cangjie YAML file
const conwayofficial_file_path = "./src/resources/other/codepoint-character-sequence.txt"
//C:\Users\CMLyk\WebstormProjects\yuema\src\resources\other\codepoint-character-sequence.txt

const conwaymanual_file_path = "./src/resources/other/manualIdsConwayCodes.txt"
//C:\Users\CMLyk\WebstormProjects\yuema\src\resources\other\manualIdsConwayCodes.txt

// Reads the YAML file and creates a dictionary mapping Chinese characters to sets of ASCII strings
pub fn parse_conway_files() -> Result(Dict(String, Set(String)), String) {
  // Use provided file_path or default to cangjie_file_path
  //let path = case file_path {
  //  "" -> cangjie_file_path
  //  _ -> file_path
  //}

  // Read the file using simplifile
  case simplifile.read(from: path) {
    Ok(content) -> {
      // Compile regex for valid lines: Chinese character followed by tab and ASCII strings
      let assert Ok(re) = regexp.from_string("^([^\\-\\u007F])\\s+([a-zA-Z']+(\\s+[a-zA-Z']+)*)$")

      // Process lines
      content
      |> string.split("\n")
      |> list.filter(fn(line) { string.trim(line) != "" })
      |> list.fold(
      dict.new(),
      fn(acc, line) {
        // Use regexp.scan to get matches
        let matches = regexp.scan(with: re, content: line)
        case matches {
          [regexp.Match(content: _, submatches: [Some(char), Some(ascii_part), ..])] -> {
            // Split the ASCII part into individual strings
            let ascii_strings = string.split(ascii_part, on: "\\s+")
            // Get existing set or create new one
            let current_set = dict.get(acc, char)
            |> result.unwrap(set.new())

            // Add all ASCII strings to the set
            let updated_set = list.fold(
            ascii_strings,
            current_set,
            fn(set_acc, ascii) { set.insert(set_acc, ascii) }
            )

            // Update dict with new set
            dict.insert(acc, char, updated_set)
          }
          _ -> acc // Skip lines that don't match or have incorrect submatches
        }
      }
      )
      |> Ok
    }
    Error(error) -> Error("Failed to read file: " <> simplifile.describe_error(error))
  }
}