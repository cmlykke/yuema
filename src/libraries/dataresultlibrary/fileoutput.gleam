import gleam.{type Result}
import gleam/dict.{type Dict}
import gleam/set.{type Set}
import gleam/list
import gleam/string
import simplifile

pub fn format_code_to_characters(result: Result(Dict(String, Set(String)), String)) -> List(String) {
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

pub fn write_code_to_characters(result: Result(Dict(String, Set(String)), String), outputfilename: String) -> Result(Nil, String) {
  // Define the output directory
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
      // Get formatted strings
      let formatted_lines = format_code_to_characters(result)

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
      let formatted_lines = format_code_to_characters(result)

      // Join lines with newline
      let content = string.join(formatted_lines, with: "\n")

      // Write to file
      case simplifile.write(content, to: full_path) {
        Ok(_) -> Ok(Nil)
        Error(error) -> Error("Failed to write to file: " <> simplifile.describe_error(error))
      }
    }
  }
}