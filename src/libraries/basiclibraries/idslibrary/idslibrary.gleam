import gleam/result
import gleam/dict.{type Dict}
import gleam/list
import gleam/regexp
import simplifile
import gleam/string
import libraries/util/utilcollections.{type CharacterCollection, Collections}
import gleam/io
import gleam/set.{type Set}
import gleam/int


// Paths to the text files
const cjkvi_ids = "./src/resources/other/ids.txt"
const manual_ids = "./src/resources/manuallycreatedfiles/orderedMissingIds.txt"

pub fn combined_ids_map() -> Dict(String, String) {
  let officialcollection: Dict(String, String) = cjkvi_ids_map()
  let manualcollection: Dict(String, String) = personal_ids_map()
  dict.merge(manualcollection, officialcollection)
}

pub fn cjkvi_ids_map() -> Dict(String, String) {
  parse_file_to_list(cjkvi_ids)
}

pub fn personal_ids_map() -> Dict(String, String) {
  parse_file_to_list(manual_ids)
}


fn parse_file_to_list(file_path: String) -> Dict(String, String) {
  let assert Ok(whitespace_regex) = regexp.compile("\\s+", regexp.Options(case_insensitive: False, multi_line: False))
  case simplifile.read(file_path) {
    Ok(content) -> {
      content
      |> string.split("\n")
      |> list.index_fold(
      from: dict.new(),
      with: fn(acc, line, _index) {
        let trimmed = string.trim(line)
        case string.starts_with(trimmed, "U+") {
          True -> {
            let parts = regexp.split(whitespace_regex, trimmed)
            case parts {
              [_first, key, value, ..] -> {
                case key == "" || value == "" {
                  True -> acc
                  False -> dict.insert(acc, key, value)
                }
              }
              _ -> acc
            }
          }
          False -> acc
        }
      }
      )
    }
    Error(_) -> dict.new()
  }
}
