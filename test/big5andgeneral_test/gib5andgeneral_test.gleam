import gleam/int
import gleam/io
import gleeunit
import gleeunit/should
import libraries/big5andgeneralstadardlibrary/big5andgeneralstandard
import libraries/util/utilcollections.{Collections}
import gleam/dict
import gleam/list
import gleam/set

pub fn main() {
  gleeunit.main()
}

pub fn characters_to_support_test() {
  let collection = big5andgeneralstandard.characters_to_support()

  io.println("test first: " <> int.to_string(list.length(collection.trad_list)))
  //list.length(collections.trad_list)
  should.equal(list.length(collection.trad_list), 8000)

}