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


pub fn main() {
  gleeunit.main()
}

pub fn print_recur_test() {
  //let combinedids: Dict(String, String) = idslibrary.combined_ids_map()
  let generalstandardstroke: List(String) = big5andgeneralstandard.generalstandardlist()

  let allres: List(String) = process_strokes(generalstandardstroke)

  let outputresult: Result(Nil, String)  = fileoutput.write_to_file(allres, "idsbreakup")
  case outputresult {
    Ok(_) -> io.println("Success: print_recur_test")
    Error(err) -> io.println("Error: print_recur_test: " <> err)
  }

  //息 (⿱[(自[])(心[])])
  //倔 (⿰[(亻[])(⿸[(尸[])(⿱[(⿻[(凵[])(丨[])])(凵[])])])])
  //徒 (⿰[(彳[])(⿱[(⿱[(十[])(一[])])(龰[])])])





}

fn process_strokes(generalstandardstroke: List(String)) -> List(String) {
  let combinedids: Dict(String, String) = idslibrary.cjkvi_ids_map()

  list.map(generalstandardstroke, fn(stroke) {
    let eachids: Idsrecur = idsandconway.idsrecursion(stroke, combinedids)
    stroke <> " " <> idsrecur.idsrecur_to_string(eachids)
  })
}

pub fn nestedids() {
  let combinedids: Dict(String, String) = idslibrary.combined_ids_map()
  //let big5andgs: CharacterCollection = big5andgeneralstandard.characters_to_support()
  let generalstandardstroke: List(String) = big5andgeneralstandard.generalstandardlist()


  let test1a: Idsrecur = idsandconway.idsrecursion("𠯀", combinedids)
  let test1b: String = idsrecur.idsrecur_to_string(test1a)

  io.println("done: " <> test1b)
  should.equal(test1b, "(⿰[(口[])(川[])])")

  //枭	⿹④木
  let test2a: Idsrecur = idsandconway.idsrecursion("枭", combinedids)
  let test2b: String = idsrecur.idsrecur_to_string(test2a)

  io.println("done: " <> test2b)
  should.equal(test2b, "(⿹[(④[])(木[])])")
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


