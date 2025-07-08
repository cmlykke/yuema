import gleam/string
import gleam/list
import gleam/set.{type Set}
import gleam/dict.{type Dict}
import gleam/result
import gleam/regexp
import gleam/option.{Some} // Import Option module and Some constructor
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

pub fn parse_code_to_characters(file_path: String) -> Result(Dict(String, Set(String)), String) {
  // Call parse_cangjie_file to get character to code mapping
  let character_to_code = parse_cangjie_file(file_path)

  case character_to_code {
    Ok(char_dict) -> {
      // Create new dictionary by folding over character_to_code
      let code_to_char_dict = dict.fold(
      char_dict,
      dict.new(),
      fn(acc, char, codes) {
        // For each character and its code set, add the character to each code's set
        set.fold(
        codes,
        acc,
        fn(inner_acc, code) {
          let current_chars = dict.get(inner_acc, code)
          |> result.unwrap(set.new())
          let updated_chars = set.insert(current_chars, char)
          dict.insert(inner_acc, code, updated_chars)
        }
        )
      }
      )
      Ok(code_to_char_dict)
    }
    Error(err) -> Error(err)
  }
}

pub fn parse_codes_with_multiple_characters(file_path: String) -> Result(Dict(String, Set(String)), String) {
  // Call parse_code_to_characters to get code to character mapping
  let code_to_character = parse_code_to_characters(file_path)

  case code_to_character {
    Ok(code_dict) -> {
      // Create new dictionary by filtering entries with set size >= 2
      let filtered_dict = dict.fold(
      code_dict,
      dict.new(),
      fn(acc, code, chars) {
        case set.size(chars) >= 2 {
          True -> dict.insert(acc, code, chars)
          False -> acc
        }
      }
      )
      Ok(filtered_dict)
    }
    Error(err) -> Error(err)
  }
}

