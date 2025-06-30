import gleam/list
import gleam/set.{type Set}
import gleam/regexp
import simplifile
import gleam/string
import gleam/io // Added for io.println
import gleam/int // Added for int.to_string

// Paths to the text files
const big5_file_path = "./src/resources/other/Big5_wikilink.txt"
const generalstandard_file_path = "./src/resources/other/github_jaywcjlove_generalstandard2013_8105.txt"
const tzai2006_file_path = "./src/resources/other/Tzai2006.txt"
const sinica_20769 = "./src/resources/other/Taiwan_CKIP98-01_20769.csv"

pub fn parse_taiwan_20769() -> Result(List(String), String) {
  case regexp.from_string("[\\u{2E80}-\\u{10FFFF}]") {
    Error(_) -> Error("Failed to compile regex for CJK characters")
    Ok(han_regex) -> {
      case simplifile.read(sinica_20769) {
        Error(error) -> Error("Failed to read sinica_20769 file: " <> simplifile.describe_error(error))
        Ok(content) -> {
          let lines = string.split(content, "\n")
          let result = process_lines(lines, [], set.new(), 1, han_regex)
          Ok(result)
        }
      }
    }
  }
}

fn process_lines(
lines: List(String),
current_list: List(String),
bigset: Set(String),
linenum: Int,
re: regexp.Regexp,
) -> List(String) {
  case lines {
    [] -> {
      io.println("Size of BIGSET: " <> int.to_string(set.size(bigset)))
      io.println("LINENUM: " <> int.to_string(linenum - 1))
      current_list
    }
    [line, ..rest_lines] -> {
      let matches = regexp.scan(with: re, content: line)
      let acc = list.fold(
      matches,
      #(current_list, bigset),
      fn(acc, match: regexp.Match) {
        let #(clist, cset) = acc
        let char = match.content
        case set.contains(cset, char) {
          True -> acc
          False -> #([char, ..clist], set.insert(cset, char))
        }
      },
      )
      let #(new_list, new_set) = acc
      case set.size(new_set) >= 8000 {
        True -> {
          io.println("Size of BIGSET: " <> int.to_string(set.size(new_set)))
          io.println("LINENUM: " <> int.to_string(linenum))
          new_list
        }
        False -> process_lines(rest_lines, new_list, new_set, linenum + 1, re)
      }
    }
  }
}

pub fn parse_tzai7984andgeneralstandard_11825() -> Result(Set(String), String) {
  // Call both parsing functions
  let tzai2006_result = parse_tzai2006_7984()
  let generalstandard_result = parse_generalstandard_8105()

  // Handle the results
  case tzai2006_result, generalstandard_result {
    Ok(tzai2006_set), Ok(generalstandard_set) -> {
      // Merge the two sets using set.union
      let merged_set = set.union(tzai2006_set, generalstandard_set)
      Ok(merged_set)
    }
    Error(tzai2006_error), _ -> Error(tzai2006_error)
    _, Error(generalstandard_error) -> Error(generalstandard_error)
  }
}

fn parse_tzai2006_7984() -> Result(Set(String), String) {
  // Compile regex for characters in the Unicode range [\u2E7F-\u{10FFFF}]
  case regexp.from_string("[\\u2E7F-\\u{10FFFF}]") {
    Ok(re) ->
    case simplifile.read(from: tzai2006_file_path) {
      Ok(tzai2006_content) -> {
        let limited_content =
        tzai2006_content
        |> string.split("\n")
        |> list.take(7984)
        |> string.join("\n")

        // Find all matching characters in the content
        let characters =
        regexp.scan(with: re, content: limited_content)
        |> list.fold(set.new(), fn(set_acc, match) {
          set.insert(set_acc, match.content)
        })

        Ok(characters)
      }
      Error(error) ->
      Error("Failed to read tzai2006 file: " <> simplifile.describe_error(error))
    }
    Error(_) -> Error("Failed to compile regex")
  }
}

fn parse_generalstandard_8105() -> Result(Set(String), String) {
  // Compile regex for characters in the Unicode range [\u2E7F-\u{10FFFF}]
  case regexp.from_string("[\\u2E7F-\\u{10FFFF}]") {
    Ok(re) ->
    case simplifile.read(from: generalstandard_file_path) {
      Ok(generalstandard) -> {
        // Find all matching characters in the content
        let characters =
        regexp.scan(with: re, content: generalstandard)
        |> list.fold(set.new(), fn(set_acc, match) {
          set.insert(set_acc, match.content)
        })

        Ok(characters)
      }
      Error(error) ->
      Error("Failed to read generalstandard file: " <> simplifile.describe_error(error))
    }
    Error(_) -> Error("Failed to compile regex")
  }
}