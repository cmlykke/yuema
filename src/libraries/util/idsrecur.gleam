
import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import gleam/io
import gleam/regexp
import gleam/result


// Define regex patterns for valid characters
const regex_pattern_shapechar: String = "[\\x{2FF0}-\\x{2FFF}\\x{303E}\\x{31EF}]"

const regex_pattern_hanchar: String = "[\\x{80}-\\x{D7FF}\\x{E000}-\\x{10FFFF}]"

// Define opaque types
pub opaque type HanChar {
  HanChar(value: String)
}

pub opaque type ShapeChar {
  ShapeChar(value: String)
}

// Generic validation and construction function
fn create_restricted_char(
input: String,
regex_pattern: String,
error_prefix: String,
constructor: fn(String) -> restricted,
) -> restricted {
  let assert Ok(regex) = regexp.compile(regex_pattern, regexp.Options(case_insensitive: False, multi_line: False))
  let is_valid = string.to_graphemes(input)
  |> list.all(fn(char) { regexp.check(regex, char) })
  let is_exactly_one_char = string.length(input) == 1

  case is_valid && is_exactly_one_char {
    True -> constructor(input)
    False -> {
      let msg = error_prefix <> " Got: '" <> input <> "'"
      panic as msg
    }
  }
}

// HanChar constructor
pub fn hanchar_new(input: String) -> HanChar {
  create_restricted_char(
  input,
  regex_pattern_hanchar,
  "Invalid HanChar: input must contain exactly one character in Unicode range [x{80}-x{D7FF} x{E000}-x{10FFFF}].",
  HanChar,
  )
}

// HanChar accessor
pub fn hanchar_to_string(restricted: HanChar) -> String {
  restricted.value
}

// ShapeChar constructor
pub fn shapechar_new(input: String) -> ShapeChar {
  create_restricted_char(
  input,
  regex_pattern_shapechar,
  "Invalid ShapeChar: input must contain exactly one character in Unicode range U+2FF0-U+2FFF or code points U+303E or U+31EF.",
  ShapeChar,
  )
}

// ShapeChar accessor
pub fn shapechar_to_string(restricted: ShapeChar) -> String {
  restricted.value
}
