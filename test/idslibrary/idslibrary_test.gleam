import gleam/int
import gleam/io
import gleeunit
import gleeunit/should
import libraries/idslibrary/idslibrary
import libraries/util/utilcollections.{Collections}
import gleam/list
import gleam/set
import gleam/dict.{type Dict}

pub fn main() {
  gleeunit.main()
}

pub fn characters_to_support_test() {
  let collection: Dict(String, String) = idslibrary.cjkvi_ids_map()

  io.println("test first: " <> int.to_string(dict.size(collection)))
  //list.length(collections.trad_list)
  should.equal(dict.size(collection), 88937)

}