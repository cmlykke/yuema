import gleam/string
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
import libraries/basiclibraries/conwaylibrary/conwaylibrary



pub fn main() {
  gleeunit.main()
}

//tests that verify that the short codes for the most common
//simplified and traditional characters can be found in the conway dictionary

pub fn compare_simplified_shortcode_and_conway_test() {

  let conwaydict: Dict(String, List(String)) = conwaylibrary.rolled_out_conway()
  io.println("works conwaydict")
  let combinedids: Dict(String, String) = idslibrary.cjkvi_ids_map()
  io.println("works combinedids")
  let generalstandardstroke: List(String) = big5andgeneralstandard.generalstandardlist()

  io.println("works so far")

  let elemset: Dict(String, Nil) = create_elemset(combinedids, generalstandardstroke)

  let missing_keys = elemset
    |> dict.keys
    |> list.filter(fn(key) { !dict.has_key(conwaydict, key) })

  // Check if missing_keys is empty; fail with custom message if not
  case list.is_empty(missing_keys) {
    True -> Nil // Test passes
    False -> {
      let error_message = "Found "
      <> string.inspect(list.length(missing_keys))
      <> " elements not in conwaydict: "
      <> string.inspect(missing_keys)
      panic as error_message
    }
  }
}

pub fn create_elemset(
      combinedids: Dict(String, String),
      generalstandardstroke: List(String)) -> Dict(String, Nil) {
  let elemset: Dict(String, Nil) = generalstandardstroke
  |> list.flat_map(fn(stroke) {
    let eachids: Idsrecur = createidsrecur.idsrecursion(stroke, combinedids)
    let idslist: List(String) = idsandconway.idsrecur_to_list_short_v1(eachids)
    idslist
  })
  |> list.map(fn(s) { #(s, Nil) })
  |> dict.from_list

  elemset
}