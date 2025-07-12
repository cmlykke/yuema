import gleam/dict.{type Dict}
import gleam/list
import gleam/regexp
import gleam/result
import gleam/string
import gleam/option.{Some}
import simplifile

// Path to the Conway official file
const conwayofficial_file_path = "./src/resources/other/codepoint-character-sequence.txt"


type Part {
  Fixed(String)
  Choice(List(String))
}

pub fn rolled_out_conway() -> Dict(String, List(String)) {
  let rawdict: Dict(String, String) = get_conway_dict()
  process_dict(rawdict)
}

fn process_dict(input: Dict(String, String)) -> Dict(String, List(String)) {
  dict.map_values(input, fn(_, value) {
    expand(value)
  })
}

fn expand(value: String) -> List(String) {
  let parts = parse(value)
  list.fold(parts, [""] , fn(acc, part) {
    case part {
      Fixed(s) -> list.map(acc, fn(x) { x <> s })
      Choice(cs) -> list.flat_map(acc, fn(x) {
        list.map(cs, fn(c) { x <> c })
      })
    }
  })
}

fn parse(value: String) -> List(Part) {
  parse_helper(string.to_graphemes(value), [], "")
}

fn parse_helper(chars: List(String), acc: List(Part), current: String) -> List(Part) {
  case chars {
    [] -> {
      case current == "" {
        True -> list.reverse(acc)
        False -> list.reverse([Fixed(current), ..acc])
      }
    }
    ["(", ..rest] -> {
      let acc = case current == "" {
        True -> acc
        False -> [Fixed(current), ..acc]
      }
      let #(inside, rest2) = collect_choice(rest, "")
      let choices = string.split(inside, on: "|")
      let acc = [Choice(choices), ..acc]
      parse_helper(rest2, acc, "")
    }
    [ch, ..rest] -> parse_helper(rest, acc, current <> ch)
  }
}

fn collect_choice(chars: List(String), inside: String) -> #(String, List(String)) {
  case chars {
    [] -> panic as "Unclosed ("
    [")", ..rest] -> #(inside, rest)
    [ch, ..rest] -> collect_choice(rest, inside <> ch)
  }
}

// **************************** raw conway code *************************************


fn get_conway_dict() -> Dict(String, String) {
  case parse_conway_files() {
    Ok(dict) -> dict
    _ -> {
      panic as "Failed to parse Conway files: get_conway_dict()"
    }
  }
}

fn parse_conway_files() -> Result(Dict(String, String), String) {
  // Read the file using simplifile
  case simplifile.read(from: conwayofficial_file_path) {
    Ok(content) -> {
      // Compile regex for valid lines: Unicode code point, character, stroke sequence
      let assert Ok(re) = regexp.from_string(
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