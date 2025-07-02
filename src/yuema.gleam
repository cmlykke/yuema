import gleam/io
import gleam/list
import gleam/int
import gleam/result
import libraries/conwaylibrary/conwaylibrary
import libraries/big5andgeneralstadardlibrary/big5andgeneralstandard
import simplifile
import gleam/string
import libraries/util/utilcollections.{type CharacterCollection}
import gleam/dict.{type Dict}
import gleam/set.{type Set}

pub fn main() -> Nil {
  // Execute parse_conway_files and save the result to a variable
  let cangjie_dict = conwaylibrary.parse_conway_files()
  let size = case result.map(cangjie_dict, dict.size) {
    Ok(size) -> size
    Error(err) -> {
      io.println("Error parsing Conway files: " <> err)
      0 // Return 0 as a fallback for the error case
    }
  }
  io.println("Cangjie dict size: " <> int.to_string(size))

  let collections: CharacterCollection = big5andgeneralstandard.characters_to_support()

  // Print size for simp_list using get_size
  io.println("StringListTrad has size: " <> int.to_string(list.length(collections.trad_list)))
  io.println("StringListSimp has size: " <> int.to_string(list.length(collections.simp_list)))
  io.println("StringDictTrad has size: " <> int.to_string(dict.size(collections.trad_dict)))
  io.println("StringDictSimp has size: " <> int.to_string(dict.size(collections.simp_dict)))
  io.println("StringSetTrad has size: " <> int.to_string(dict.size(collections.trad_set)))
  io.println("StringSetSimp has size: " <> int.to_string(dict.size(collections.simp_set)))
  io.println("StringSetTotal has size: " <> int.to_string(dict.size(collections.total_set)))


  let trad8000: List(String) = collections.trad_list

  let path = "C:/Users/CMLyk/WebstormProjects/yuema/src/outputfiles/trad8000.txt"
  case write_list_to_file(path, trad8000) {
    Ok(_) -> io.println("File written successfully")
    Error(msg) -> io.println("Error writing file: " <> msg)
  }

  let jun: List(String) = big5andgeneralstandard.jundacomplete()
  let genset: Dict(String, Bool) = big5andgeneralstandard.general_set_raw()
  let diffset = difference_set(jun, genset)
  io.println("diffset: " <> int.to_string(list.length(diffset)))


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