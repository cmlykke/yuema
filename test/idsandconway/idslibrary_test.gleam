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


pub fn nestedids_test() {
  let combinedids: Dict(String, String) = idslibrary.combined_ids_map()
  //let big5andgs: CharacterCollection = big5andgeneralstandard.characters_to_support()
  let generalstandardstroke: List(String) = big5andgeneralstandard.generalstandardlist()

  // 𠯀	⿰口川
  let test1a: Idsrecur = createidsrecur.idsrecursion("𠯀", combinedids)
  let test1b: String = idsrecur.idsrecur_to_string(test1a)
  //io.println("done: " <> test1b)
  should.equal(test1b, "({𠯀}⿰[({}口[])({}川[])])")

  //枭	⿹④木
  let test2a: Idsrecur = createidsrecur.idsrecursion("枭", combinedids)
  let test2b: String = idsrecur.idsrecur_to_string(test2a)
  //io.println("done: " <> test2b)
  should.equal(test2b, "({枭}⿹[({}④[])({}木[])])")

  //帅	⿰⿰丨丿巾
  let test3a: Idsrecur = createidsrecur.idsrecursion("帅", combinedids)
  let test3b: String = idsrecur.idsrecur_to_string(test3a)
  //io.println("done: " <> test3b)
  should.equal(test3b, "({帅}⿰[({}⿰[({}丨[])({}丿[])])({}巾[])])")

  // 𠮸	⿹⺄⿱亠口
  let test4a: Idsrecur = createidsrecur.idsrecursion("𠮸", combinedids)
  let test4b: String = idsrecur.idsrecur_to_string(test4a)
  //io.println("done: " <> test4b)
  should.equal(test4b, "({𠮸}⿹[({}⺄[])({}⿱[({亠}⿱[({}丶[])({}一[])])({}口[])])])")

  // 𠮺	⿰口⿰丨⿱丿乀
  let test5a: Idsrecur = createidsrecur.idsrecursion("𠮺", combinedids)
  let test5b: String = idsrecur.idsrecur_to_string(test5a)
  //io.println("done: " <> test5b)
  should.equal(test5b, "({𠮺}⿰[({}口[])({}⿰[({}丨[])({}⿱[({}丿[])({}乀[])])])])")

  //亴	⿳⿳亠口冖土九[GK]
  let test6a: Idsrecur = createidsrecur.idsrecursion("亴", combinedids)
  let test6b: String = idsrecur.idsrecur_to_string(test6a)
  //io.println("done: " <> test6b)
  should.equal(test6b, "({亴}⿳[({}⿳[({亠}⿱[({}丶[])({}一[])])({}口[])({}冖[])])({土}⿱[({}十[])({}一[])])({}九[])])")

}


pub fn characters_to_support_test() {
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




