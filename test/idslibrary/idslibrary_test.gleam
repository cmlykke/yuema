import gleam/int
import gleam/io
import gleeunit
import gleeunit/should
import libraries/basiclibraries/idslibrary/idslibrary
import libraries/basiclibraries/idslibrary/idsrecursion
import libraries/basiclibraries/big5andgeneralstadardlibrary/big5andgeneralstandard
import libraries/util/utilcollections.{type CharacterCollection, Collections}
import gleam/list
import gleam/set
import gleam/dict.{type Dict}
import libraries/util/idsrecur.{type Idsrecur, type HanChar, type ShapeChar}



pub fn main() {
  gleeunit.main()
}

pub fn nestedids_test() {
  let combinedids: Dict(String, String) = idslibrary.combined_ids_map()
  //let big5andgs: CharacterCollection = big5andgeneralstandard.characters_to_support()
  let generalstandardstroke: List(String) = big5andgeneralstandard.generalstandardlist()


  let res: Idsrecur = idsrecursion.idsrecursion("𠯀", combinedids)
  let res2: String = idsrecur.idsrecur_to_string(res)

  io.println("done: " <> res2)
  should.equal(res2, "(⿰[(口[])(川[])])")

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


