import gleam/int
import gleam/io
import gleeunit
import gleeunit/should
import libraries/basiclibraries/big5andgeneralstadardlibrary/big5andgeneralstandard
import libraries/util/utilcollections.{Collections}
import gleam/dict
import gleam/list
import gleam/set

pub fn main() {
  gleeunit.main()
}

pub fn characters_to_support() {
  let collection = big5andgeneralstandard.characters_to_support()

  //io.println("traditional characters list length: " <> int.to_string(list.length(collection.trad_list)))
  should.equal(list.length(collection.trad_list), 8000)

  //io.println("general standard list length: " <> int.to_string(list.length(collection.simp_list)))
  should.equal(list.length(collection.simp_list), 8114)

}