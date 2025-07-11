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


pub fn main() {
  gleeunit.main()
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

pub fn nestedids_test() {
  let combinedids: Dict(String, String) = idslibrary.combined_ids_map()
  //let big5andgs: CharacterCollection = big5andgeneralstandard.characters_to_support()
  let generalstandardstroke: List(String) = big5andgeneralstandard.generalstandardlist()

  // 𠯀	⿰口川
  let test1a: Idsrecur = createidsrecur.idsrecursion("𠯀", combinedids)
  let test1b: String = idsrecur.idsrecur_to_string(test1a)

  io.println("done: " <> test1b)
  should.equal(test1b, "({𠯀}⿰[({}口[])({}川[])])")

  //枭	⿹④木
  let test2a: Idsrecur = createidsrecur.idsrecursion("枭", combinedids)
  let test2b: String = idsrecur.idsrecur_to_string(test2a)
  io.println("done: " <> test2b)
  should.equal(test2b, "({枭}⿹[({}④[])({}木[])])")

  //帅	⿰⿰丨丿巾
  let test3a: Idsrecur = createidsrecur.idsrecursion("帅", combinedids)
  let test3b: String = idsrecur.idsrecur_to_string(test3a)
  io.println("done: " <> test3b)
  should.equal(test3b, "({帅}⿰[({}⿰[({}丨[])({}丿[])])({}巾[])])")

  // 𠮸	⿹⺄⿱亠口
  let test4a: Idsrecur = createidsrecur.idsrecursion("𠮸", combinedids)
  let test4b: String = idsrecur.idsrecur_to_string(test4a)
  io.println("done: " <> test4b)
  should.equal(test4b, "({𠮸}⿹[({}⺄[])({}⿱[({}亠[])({}口[])])])")

  // 𠮺	⿰口⿰丨⿱丿乀
  let test5a: Idsrecur = createidsrecur.idsrecursion("𠮺", combinedids)
  let test5b: String = idsrecur.idsrecur_to_string(test5a)
  io.println("done: " <> test5b)
  should.equal(test5b, "({𠮺}⿰[({}口[])({}⿰[({}丨[])({}⿱[({}丿[])({}乀[])])])])")

}


pub fn characters_to_support() {
  let officialcollection: Dict(String, String) = idslibrary.cjkvi_ids_map()
  let manualcollection: Dict(String, String) = idslibrary.personal_ids_map()
  let combined: Dict(String, String) = dict.merge(manualcollection, officialcollection)

  //io.println("official ids cound: " <> int.to_string(dict.size(officialcollection)))
  should.equal(dict.size(officialcollection), 88937)

  //io.println("manual ids count: " <> int.to_string(dict.size(manualcollection)))
  should.equal(dict.size(manualcollection), 133)

  //io.println("combined ids count: " <> int.to_string(dict.size(combined)))
  should.equal(dict.size(combined), 89070)

}


pub fn recur_short_str() {
  let combinedids: Dict(String, String) = idslibrary.cjkvi_ids_map()
  let generalstandardstroke: List(String) = big5andgeneralstandard.generalstandardlist()

  let eachids: Idsrecur = createidsrecur.idsrecursion("帅", combinedids)
  io.println("帅")                        //  ({帅}⿰[({}⿰[])({}丨[])({}丿[])({}巾[])])

  let eachidlongstr: String = idsrecur.idsrecur_to_string(eachids)
  io.println(eachidlongstr)
  let testttt: String = idsandconway.idsrecur_to_string(eachids)
  io.println("帅" <> " short: " <> testttt)

  idsrecur_short("𠯀", combinedids)
  idsrecur_short("帅", combinedids) // 帅	⿰⿰丨丿巾


  // jeg maa finde en loesning paa 帅 problemet
  // 帅

  let allres: List(String) = process_strokes_recurshortstring(generalstandardstroke, combinedids)

  let outputresult: Result(Nil, String)  = fileoutput.write_to_file(allres, "idsbreakup_short")
  case outputresult {
    Ok(_) -> io.println("Success: print_recur_test")
    Error(err) -> io.println("Error: print_recur_test: " <> err)
  }

}

fn idsrecur_short(str: String, combinedids: Dict(String, String)) {
  let test1a: Idsrecur = createidsrecur.idsrecursion(str, combinedids)
  let test1b: String = idsrecur.idsrecur_to_string(test1a)
  let shortstr: String = idsandconway.idsrecur_to_string(test1a)

  io.println(str <> " long: " <> test1b)
  io.println(str <> " short: " <> shortstr)
}

fn process_strokes_recurshortstring(generalstandardstroke: List(String), combinedids: Dict(String, String)) -> List(String) {

  list.map(generalstandardstroke, fn(stroke) {
    let eachids: Idsrecur = createidsrecur.idsrecursion(stroke, combinedids)
    idsandconway.idsrecur_to_string(eachids)
  })
}

fn process_strokes_recurfillstring(generalstandardstroke: List(String)) -> List(String) {
  let combinedids: Dict(String, String) = idslibrary.cjkvi_ids_map()

  list.map(generalstandardstroke, fn(stroke) {
    let eachids: Idsrecur = createidsrecur.idsrecursion(stroke, combinedids)
    idsrecur.idsrecur_to_string(eachids)
  })
}


