
import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import gleam/io
import gleam/regexp
import gleam/result
import libraries/regexlib



//******************************* Idsrecur  ***********************************

// Assuming HanChar and ShapeChar are defined in the previous code
pub opaque type Idsrecur {
    Idsrecur(
  shape_char: Option(ShapeChar),
  han_char: Option(HanChar),
  previus_han_char: Option(HanChar),
  children: List(Option(Idsrecur)),
  )
}

// Constructor for Idsrecur
pub fn idsrecur_new(
shape_char: Option(ShapeChar),
han_char: Option(HanChar),
previus_han_char: Option(HanChar),
children: List(Option(Idsrecur)),
) -> Idsrecur {
Idsrecur(shape_char, han_char, previus_han_char, children)
}

// Accessor for shape_char
pub fn idsrecur_get_shape_char(ids: Idsrecur) -> Option(ShapeChar) {
  ids.shape_char
}

// Accessor for han_char
pub fn idsrecur_get_han_char(ids: Idsrecur) -> Option(HanChar) {
  ids.han_char
}

pub fn idsrecur_get_previus_han_char(ids: Idsrecur) -> Option(HanChar) {
  ids.previus_han_char
}

// Accessor for children
pub fn idsrecur_get_children(ids: Idsrecur) -> List(Option(Idsrecur)) {
  ids.children
}

// Convert Idsrecur to string representation
pub fn idsrecur_to_string(ids: Idsrecur) -> String {
  let shape_str = case idsrecur_get_shape_char(ids) {
    Some(shape) -> shapechar_to_string(shape)
    None -> ""
  }

  let han_str = case idsrecur_get_han_char(ids) {
    Some(han) -> hanchar_to_string(han)
    None -> ""
  }

  let previus_han_str = case idsrecur_get_previus_han_char(ids) {
    Some(han) -> hanchar_to_string(han)
    None -> ""
  }

  let children_str = idsrecur_get_children(ids)
  |> list.map(fn(child_opt) {
    case child_opt {
      Some(child) -> idsrecur_to_string(child)
      None -> ""
    }
  })
  |> string.join("")

  "(" <> "{" <> previus_han_str <>"}" <> shape_str <> han_str <> "[" <> children_str <> "])"
}


//******************************* ShapeChar and HanChar  ***********************************


// Define regex patterns for valid characters

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
  regexlib.regex_pattern_hanchar,
  "Invalid HanChar: input must contain exactly one character in Unicode range [x{80}-x{D7FF} x{E000}-x{10FFFF}].",
  HanChar,
  )
}

// HanChar accessor
pub fn hanchar_to_string(restricted: HanChar) -> String {
  restricted.value
}

pub fn hanchar_to_string_option(opt: Option(HanChar)) -> String {
  option.map(opt, hanchar_to_string)
  |> option.unwrap("NONE")
}

// ShapeChar constructor
pub fn shapechar_new(input: String) -> ShapeChar {
  create_restricted_char(
  input,
  regexlib.regex_pattern_shapechar,
  "Invalid ShapeChar: input must contain exactly one character in Unicode range U+2FF0-U+2FFF or code points U+303E or U+31EF.",
  ShapeChar,
  )
}

// ShapeChar accessor
pub fn shapechar_to_string(restricted: ShapeChar) -> String {
  restricted.value
}

pub fn shapechar_to_string_option(opt: Option(ShapeChar)) -> String {
  option.map(opt, shapechar_to_string)
  |> option.unwrap("NONE")
}
