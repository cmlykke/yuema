import gleam/list
import gleam/set.{type Set}
import gleam/regexp
import simplifile

// Paths to the text files
const big5_file_path = "./src/resources/other/Big5_wikilink.txt"
const generalstandard_file_path = "./src/resources/other/github_jaywcjlove_generalstandard2013_8105.txt"

pub fn parse_big5andgeneralstand_16496() -> Result(Set(String), String) {
  // Compile regex for characters in the Unicode range [\u2E7F-\u{10FFFF}]
  let assert Ok(re) = regexp.from_string("[\\u2E7F-\\u{10FFFF}]")

  // Read both files and combine results
  case simplifile.read(from: big5_file_path), simplifile.read(from: generalstandard_file_path) {
    Ok(big5_content), Ok(generalstandard_content) -> {
      // Process both files' content
      let characters = [big5_content, generalstandard_content]
      |> list.fold(
      set.new(),
      fn(acc, content) {
        // Find all matching characters in the content
        let matches = regexp.scan(with: re, content: content)
        // Add each matched character to the set
        list.fold(
        matches,
        acc,
        fn(set_acc, match) {
          set.insert(set_acc, match.content)
        },
        )
      },
      )
      Ok(characters)
    }
    Error(error), _ -> Error("Failed to read Big5 file: " <> simplifile.describe_error(error))
    _, Error(error) -> Error("Failed to read GeneralStandard file: " <> simplifile.describe_error(error))
  }
}