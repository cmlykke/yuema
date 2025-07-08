import gleam/io
import gleam/list
import gleam/int
import gleam/result
import libraries/basiclibraries/conwaylibrary/conwaylibrary
import libraries/basiclibraries/big5andgeneralstadardlibrary/big5andgeneralstandard
import simplifile
import gleam/string
import libraries/util/utilcollections.{type CharacterCollection}
import gleam/dict.{type Dict}
import gleam/set.{type Set}

pub fn main() -> Nil {
  // Execute parse_conway_files and save the result to a variable


  // Original print statement
  io.println("Hello from yuema! lykke 222333 xxxx")

}

pub fn write_list_to_file(path: String, list: List(String)) -> Result(Nil, String) {
  let content = string.join(list, "\n")
  simplifile.write(to: path, contents: content)
  |> result.map_error(fn(error) { simplifile.describe_error(error) })
}

pub fn difference_set(a: List(String), b: Dict(String, Bool)) -> List(String) {
  let set_a: Set(String) = set.from_list(a)
  let list_b: List(String) = dict.keys(b)
  list_b
  |> list.filter(fn(item) { !set.contains(set_a, item) })
}

pub fn print_first_five(items: List(String)) -> Nil {
  items
  |> list.take(10)
  |> list.each(fn(item) { io.println(item) })
}

pub fn print_first_five_dict(dict: Dict(String, Bool)) -> Nil {
  dict
  |> dict.keys
  |> list.take(10)
  |> list.each(fn(item) { io.println(item) })
}