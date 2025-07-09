import gleam.{type Result}
import gleam/dict.{type Dict}
import gleam/set.{type Set}
import gleam/list
import gleam/string
import simplifile

pub fn format_code_to_characters_set(result: Result(Dict(String, Set(String)), String)) -> List(String) {
  case result {
    Ok(code_dict) -> {
      // Convert dictionary to list of formatted strings
      let formatted_list = dict.to_list(code_dict)
      |> list.map(fn(pair) {
        let #(code, chars) = pair
        // Convert set to list and join with spaces
        let chars_string = set.to_list(chars)
        |> string.join(with: " ")
        // Format as "key value1 value2 ..."
        code <> " " <> chars_string
      })
      // Sort alphabetically by key (since key is first in each string, simple sort works)
      |> list.sort(string.compare)

      formatted_list
    }
    Error(_) -> []
  }
}

pub fn format_code_to_characters_list(result: Result(List(String), String)) -> List(String) {
  case result {
    Ok(code_list) -> code_list
    Error(error) -> ["Failed to get list: " <> error]
  }
}

// Helper function to handle file writing logic
pub fn write_to_file(formatted_lines: List(String), outputfilename: String) -> Result(Nil, String) {
  let output_dir = "C:\\Users\\CMLyk\\WebstormProjects\\yuema\\src\\outputfiles"

  // Ensure filename has .txt extension
  let filename = case string.ends_with(outputfilename, ".txt") {
    True -> outputfilename
    False -> outputfilename <> ".txt"
  }

  // Construct the full file path
  let full_path = output_dir <> "\\" <> filename

  // Create output directory if it doesn't exist
  case simplifile.create_directory_all(output_dir) {
    Ok(_) -> {
      // Join lines with newline
      let content = string.join(formatted_lines, with: "\n")

      // Write to file
      case simplifile.write(content, to: full_path) {
        Ok(_) -> Ok(Nil)
        Error(error) -> Error("Failed to write to file: " <> simplifile.describe_error(error))
      }
    }
    Error(error) if error != simplifile.Eexist -> Error("Failed to create directory: " <> simplifile.describe_error(error))
    Error(_) -> {
      // Directory already exists, proceed with writing
      let content = string.join(formatted_lines, with: "\n")

      // Write to file
      case simplifile.write(content, to: full_path) {
        Ok(_) -> Ok(Nil)
        Error(error) -> Error("Failed to write to file: " <> simplifile.describe_error(error))
      }
    }
  }
}

pub fn write_set_to_characters(result: Result(Set(String), String), outputfilename: String) -> Result(Nil, String) {
  // Get formatted strings
  let formatted_lines: List(String) = case result {
    Error(err) -> ["set failed: " <> err]
    Ok(content) -> set.to_list(content)
  }

  // Use helper function to write to file
  write_to_file(formatted_lines, outputfilename)
}

pub fn write_code_to_characters_set(result: Result(Dict(String, Set(String)), String), outputfilename: String) -> Result(Nil, String) {
  // Get formatted strings
  let formatted_lines = format_code_to_characters_set(result)

  // Use helper function to write to file
  write_to_file(formatted_lines, outputfilename)
}

pub fn write_code_to_characters_list(result: Result(List(String), String), outputfilename: String) -> Result(Nil, String) {
  // Get formatted strings
  let formatted_lines = format_code_to_characters_list(result)

  // Use helper function to write to file
  write_to_file(formatted_lines, outputfilename)
}

pub fn write_filtered_code_to_characters(
result: Result(Dict(String, Set(String)), String),
char_set: Result(Set(String), String),
outputfilename: String
) -> Result(Nil, String) {
  // Handle the set result
  case char_set {
    Error(err) -> Error("Invalid character set: " <> err)
    Ok(valid_chars) -> {
      // Filter the dictionary based on the set
      let filtered_lines = case result {
        Error(err) -> Error("Invalid dictionary: " <> err)
        Ok(dict) -> {
          dict
          |> dict.map_values(fn(_key, chars) {
            // Keep only characters present in valid_chars
            set.filter(chars, fn(char) { set.contains(valid_chars, char) })
          })
          |> dict.filter(fn(_key, chars) {
            // Keep only entries with non-empty character sets
            set.size(chars) > 0
          })
          |> dict.to_list
          |> list.map(fn(pair) {
            let code = pair.0
            let chars = pair.1
            code <> " " <> string.join(set.to_list(chars), with: " ")
          })
          |> Ok
        }
      }

      // Write filtered lines using helper function
      case filtered_lines {
        Ok(lines) -> write_to_file(lines, outputfilename)
        Error(err) -> Error(err)
      }
    }
  }
}