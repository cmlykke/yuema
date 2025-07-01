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
const big5_file_path = "./src/resources/other/Big5_wikilink.txt"
const sinica_20769 = "./src/resources/other/Taiwan_CKIP98-01_20769.csv"
const taiwanlesscommon_6343 = "./src/resources/other/github_ButTaiwan_cjktables_edu_standard_2.txt"
const junda9933 = "./src/resources/other/Junda2005.txt"//Junda2005.txt
const generalstandard_file_path = "./src/resources/other/github_jaywcjlove_generalstandard2013_8105.txt"
const tzai2006_file_path = "./src/resources/other/Tzai2006.txt"

pub fn jundacomplete() -> List(String) {
  parse_file_to_list(junda9933, "[\\u{2E80}-\\u{10FFFF}]")
}

pub fn general_set_raw() -> Dict(String, Bool) {
  let general_list: List(String) = parse_file_to_list(generalstandard_file_path, "[\\u{2E80}-\\u{10FFFF}]")
  list_to_set(general_list)
}

pub fn characters_to_support() -> CharacterCollection {

  //junda list
  let jundacomplete: List(String) = parse_file_to_list(junda9933, "[\\u{2E80}-\\u{10FFFF}]")
  let general_list: List(String) = parse_file_to_list(generalstandard_file_path, "[\\u{2E80}-\\u{10FFFF}]")
  let general_set_raw: Dict(String, Bool) = list_to_set(general_list)
  let jundageneraldiff: List(String) = difference_set(jundacomplete, general_set_raw)
  io.println("jundacomplete: " <> int.to_string(list.length(jundacomplete)))
  io.println("general_set_raw: " <> int.to_string(dict.size(general_set_raw)))
  io.println("jundageneraldiff: " <> int.to_string(list.length(jundageneraldiff)))



  let general_set: Dict(String, Bool) = list_to_set(general_list)
  let general_dict: Dict(String, Int) = list_to_indexed_dict(general_list)
  let trad_list_raw: List(String) = parse_file_to_list(tzai2006_file_path, "[\\u{2E80}-\\u{10FFFF}]")
  let trad_list: List(String) = list.take(trad_list_raw, 8000)
  let trad_set: Dict(String, Bool) = list_to_set(trad_list)
  let trad_dict: Dict(String, Int) = list_to_indexed_dict(trad_list)
  let total_set: Dict(String, Bool) = dict.merge(general_set, trad_set)



  Collections(
  simp_list: general_list,
  simp_set: general_set,
  simp_dict: general_dict,
  trad_list: trad_list,
  trad_set: trad_set,
  trad_dict: trad_dict,
  total_set: total_set,
  )

}



fn parse_file_to_list(file_path: String, regex_pattern: String) -> List(String) {
  let assert Ok(regex) = regexp.compile(regex_pattern, regexp.Options(case_insensitive: False, multi_line: False))
  case simplifile.read(file_path) {
    Ok(content) -> {
      content
      |> string.to_graphemes
      |> list.filter(fn(char) { regexp.check(regex, char) })
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




pub fn difference_set(a: List(String), b: Dict(String, Bool)) -> List(String) {
  let set_a: Set(String) = set.from_list(a)
  let list_b: List(String) = dict.keys(b)
  list_b
  |> list.filter(fn(item) { !set.contains(set_a, item) })
}

pub fn difference_list(a: List(String), b: List(String)) -> List(String) {
  let set_a: Set(String) = set.from_list(a)
  b
  |> list.filter(fn(item) { !set.contains(set_a, item) })
}
