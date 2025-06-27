import gleam/string
import gleam/list
import gleam/set.{type Set}
import gleam/dict.{type Dict}
import gleam/result
import gleam/regexp
import simplifile

// Path to the Cangjie YAML file
const cangjie_file_path = "./src/resources/inputsystemcodes/cangjie5.dict.yaml"

// Reads the YAML file and creates a dictionary mapping Chinese characters to sets of ASCII strings
pub fn parse_cangjie_file(file_path: String) -> Result(Dict(String, Set(String)), String) {
  // Use provided file_path or default to cangjie_file_path
  let path = case file_path {
    "" -> cangjie_file_path
    _ -> file_path
  }

  // Read the file using simplifile
  case simplifile.read(from: path) {
    Ok(content) -> {
      // Compile regex for valid lines: Chinese character followed by space/tab and ASCII strings
      let assert Ok(re) = regexp.from_string("^\\p{Han}\\s+([a-zA-Z']+(\\s+[a-zA-Z']+)*)$")

      // Process lines
      content
      |> string.split("\n")
      |> list.filter(fn(line) { string.trim(line) != "" })
      |> list.fold(
      dict.new(),
      fn(acc, line) {
        case regexp.check(re, line) {
          True -> {
            let parts = string.split(string.trim(line), on: "\\s+")
            case parts {
              [char, ..ascii_strings] -> {
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
              _ -> acc
            }
          }
          False -> acc
        }
      }
      )
      |> Ok
    }
    Error(error) -> Error("Failed to read file: " <> simplifile.describe_error(error))
  }
}