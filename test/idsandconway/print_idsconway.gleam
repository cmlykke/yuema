import gleam/regexp
import gleam/int
import gleam/io
import gleeunit
import gleeunit/should
import libraries/basiclibraries/idslibrary/idslibrary
import libraries/dataprocessing/idsandconway/idsandconway
import libraries/basiclibraries/big5andgeneralstadardlibrary/big5andgeneralstandard
import libraries/util/utilcollections.{type CharacterCollection, Collections}
import gleam/list
import gleam/set
import gleam/dict.{type Dict}
import libraries/util/idsrecur.{type Idsrecur, type HanChar, type ShapeChar}
import libraries/util/fileoutput
import libraries/dataprocessing/idsandconway/createidsrecur
import libraries/regexlib

pub fn main() {
  gleeunit.main()
}


pub fn recur_short_str_numbers_test() {
  let combinedids: Dict(String, String) = idslibrary.cjkvi_ids_map()
  let generalstandardstroke: List(String) = big5andgeneralstandard.generalstandardlist()

  let allres: List(String) = process_strokes_recurshortstring_numbersonly(generalstandardstroke, combinedids)

  let outputresult: Result(Nil, String)  = fileoutput.write_to_file(allres, "idsbreakup_shortnumbers")
  case outputresult {
    Ok(_) -> io.println("Success: print_recur_test")
    Error(err) -> io.println("Error: print_recur_test: " <> err)
  }

}

pub fn recur_short_str_test() {
  let combinedids: Dict(String, String) = idslibrary.cjkvi_ids_map()
  let generalstandardstroke: List(String) = big5andgeneralstandard.generalstandardlist()

  let allres: List(String) = process_strokes_recurshortstring(generalstandardstroke, combinedids)

  let outputresult: Result(Nil, String)  = fileoutput.write_to_file(allres, "idsbreakup_short")
  case outputresult {
    Ok(_) -> io.println("Success: print_recur_test")
    Error(err) -> io.println("Error: print_recur_test: " <> err)
  }
}

pub fn print_recur() {
  //let combinedids: Dict(String, String) = idslibrary.combined_ids_map()
  let generalstandardstroke: List(String) = big5andgeneralstandard.generalstandardlist()

  let allres: List(String) = process_strokes_recurfillstring(generalstandardstroke)

  let outputresult: Result(Nil, String)  = fileoutput.write_to_file(allres, "idsbreakup")
  case outputresult {
    Ok(_) -> io.println("Success: print_recur_test")
    Error(err) -> io.println("Error: print_recur_test: " <> err)
  }

  //息 (⿱[(自[])(心[])])
  //倔 (⿰[(亻[])(⿸[(尸[])(⿱[(⿻[(凵[])(丨[])])(凵[])])])])
  //徒 (⿰[(彳[])(⿱[(⿱[(十[])(一[])])(龰[])])])

}

pub fn filter_enclosed_alphanumerics(lines: List(String)) -> List(String) {
  // Compile a regex for the Enclosed Alphanumerics range (U+2460 to U+24FF)
  let assert Ok(regex) = regexp.compile(
  regexlib.regex_printtest_one,
  regexp.Options(case_insensitive: False, multi_line: False),
  )

  // Filter lines that contain at least one Enclosed Alphanumeric character
  list.filter(lines, fn(line) { regexp.check(regex, line) })
}

fn process_strokes_recurfillstring(generalstandardstroke: List(String)) -> List(String) {
  let combinedids: Dict(String, String) = idslibrary.cjkvi_ids_map()

  list.map(generalstandardstroke, fn(stroke) {
    let eachids: Idsrecur = createidsrecur.idsrecursion(stroke, combinedids)
    idsrecur.idsrecur_to_string(eachids)
  })
}


fn process_strokes_recurshortstring(generalstandardstroke: List(String), combinedids: Dict(String, String)) -> List(String) {
  list.map(generalstandardstroke, fn(stroke) {
    let eachids: Idsrecur = createidsrecur.idsrecursion(stroke, combinedids)
    let full_string = idsrecur.idsrecur_to_string(eachids)
    stroke <> " " <> idsandconway.idsrecur_to_string_short_v1(eachids) <> " " <> full_string
  })
}

pub fn process_strokes_recurshortstring_numbersonly(generalstandardstroke: List(String), combinedids: Dict(String, String)) -> List(String) {
  generalstandardstroke
  |> list.map(fn(stroke) {
    let eachids: Idsrecur = createidsrecur.idsrecursion(stroke, combinedids)
    let full_string = idsrecur.idsrecur_to_string(eachids)
    let shortstring = idsandconway.idsrecur_to_string_short_v1(eachids)
    #(stroke <> " " <> shortstring <> " " <> full_string, shortstring)
  })
  |> list.filter(fn(pair) { filter_enclosed_alphanumerics([pair.1]) != [] })
  |> list.map(fn(pair) { pair.0 })
}


fn idsrecur_short(str: String, combinedids: Dict(String, String)) {
  let test1a: Idsrecur = createidsrecur.idsrecursion(str, combinedids)
  let test1b: String = idsrecur.idsrecur_to_string(test1a)
  let shortstr: String = idsandconway.idsrecur_to_string_short_v1(test1a)

  io.println(str <> " long: " <> test1b)
  io.println(str <> " short: " <> shortstr)
}

