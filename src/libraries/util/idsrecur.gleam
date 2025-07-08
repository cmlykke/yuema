
import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import gleam/io
import gleam/regexp
import gleam/result

// Define the regex for valid characters (U+2FF0 to U+2FFF and U+303E to U+31EF)
const regex_pattern_shapechar: String = "[\\x{2FF0}-\\x{2FFF}\\x{303E}\\x{31EF}]"

const regex_pattern_hanchar: String = "[\\x{80}-\\x{D7FF}\\x{E000}-\\x{10FFFF}]"

// Define the opaque type for a string restricted to specific characters
pub opaque type HanChar {
  HanChar(value: String)
}

// Constructor: Creates a ShapeString or panics if invalid
pub fn hanchar_new(input: String) -> HanChar {
  let assert Ok(regex) = regexp.compile(regex_pattern_hanchar, regexp.Options(case_insensitive: False, multi_line: False))
  let is_valid = string.to_graphemes(input)
  |> list.all(fn(char) { regexp.check(regex, char) })
  let is_exactly_one_char = string.length(input) == 1

  case is_valid && is_exactly_one_char {
    True -> HanChar(input)
    False -> {
      let msg = "Invalid HanChar: input must contain exactly one character in Unicode range [x{80}-x{D7FF} x{E000}-x{10FFFF}] Got: '"
      <> input
      <> "'"
      panic as msg
    }
  }
}

// Accessor: Get the underlying string value
pub fn hanchar_to_string(restricted: HanChar) -> String {
  restricted.value
}


//********************** shape ******************************

// Define the opaque type for a string restricted to specific characters
pub opaque type ShapeChar {
  ShapeChar(value: String)
}

// Constructor: Creates a ShapeString or panics if invalid
pub fn shapechar_new(input: String) -> ShapeChar {
  let assert Ok(regex) = regexp.compile(regex_pattern_shapechar, regexp.Options(case_insensitive: False, multi_line: False))
  let is_valid = string.to_graphemes(input)
  |> list.all(fn(char) { regexp.check(regex, char) })
  let is_exactly_one_char = string.length(input) == 1

  case is_valid && is_exactly_one_char {
    True -> ShapeChar(input)
    False -> {
      let msg = "Invalid ShapeString: input must contain exactly one character in Unicode range U+2FF0-U+2FFF or code points U+303E or U+31EF. Got: '"
      <> input
      <> "'"
      panic as msg
    }
  }
}

// Accessor: Get the underlying string value
pub fn shapechar_to_string(restricted: ShapeChar) -> String {
  restricted.value
}

