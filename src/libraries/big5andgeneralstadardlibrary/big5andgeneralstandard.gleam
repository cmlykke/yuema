import gleam/dict.{type Dict}
import gleam/list
import gleam/regexp
import simplifile
import gleam/string
import libraries/util/utilcollections.{type CharacterCollection}
import gleam/io

const generalstandard_file_path = "./src/resources/other/github_jaywcjlove_generalstandard2013_8105.txt"
const tzai2006_file_path = "./src/resources/other/Tzai2006.txt"

fn parse_file_to_list(file_path: String, regex_pattern: String) -> List(String) {
  let assert Ok(regex) = regexp.compile(regex_pattern, regexp.Options(case_insensitive: False, multi_line: False))
  case simplifile.read(file_path) {
    Ok(content) -> {
      content
      |> string.split("\n")
      |> list.filter_map(fn(line) {
        let trimmed = string.trim(line)
        case regexp.check(regex, trimmed) {
          True if trimmed != "" -> Ok(trimmed)
          _ -> Error(Nil)
        }
      })
    }
    Error(_) -> []
  }
}

fn list_to_set(strings: List(String)) -> Dict(String, Bool) {
  strings
  |> list.map(fn(s) { #(s, True) })
  |> dict.from_list
}

fn list_to_indexed_dict(strings: List(String)) -> Dict(String, Int) {
  strings
  |> list.index_map(fn(item, index) { #(item, index + 1) })
  |> dict.from_list
}

pub fn characters_to_support() -> Dict(String, CharacterCollection) {
  let general_list: List(String) = parse_file_to_list(generalstandard_file_path, "[\\u{2E80}-\\u{10FFFF}]")
  let general_set: Dict(String, Bool) = list_to_set(general_list)
  let general_dict: Dict(String, Int) = list_to_indexed_dict(general_list)
  let tzai_list_raw: List(String) = parse_file_to_list(tzai2006_file_path, "[\\u{2E80}-\\u{10FFFF}]")
  let tzai_list: List(String) = list.take(tzai_list_raw, 8000)
  let tzai_set: Dict(String, Bool) = list_to_set(tzai_list)
  let tzai_dict: Dict(String, Int) = list_to_indexed_dict(tzai_list)
  let total_set: Dict(String, Bool) = dict.merge(general_set, tzai_set)

  dict.from_list([
  #("simp_list", utilcollections.StringListSimp(general_list)),
  #("simp_set", utilcollections.StringSetSimp(general_set)),
  #("simp_dict", utilcollections.StringDictSimp(general_dict)),
  #("trad_list", utilcollections.StringListTrad(tzai_list)),
  #("trad_set", utilcollections.StringSetTrad(tzai_set)),
  #("trad_dict", utilcollections.StringDictTrad(tzai_dict)),
  #("total_set", utilcollections.StringSetTotal(total_set)),
  ])
}
