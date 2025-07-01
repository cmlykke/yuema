import gleam/io
import gleam/dict
import gleam/list
import gleam/int
import gleam/result
import libraries/conwaylibrary/conwaylibrary
import libraries/big5andgeneralstadardlibrary/big5andgeneralstandard
import libraries/util/utilcollections
import simplifile
import gleam/string

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

  let collections = big5andgeneralstandard.characters_to_support()

  // Print size for simp_list using get_size
  io.println("StringListTrad has size: " <> int.to_string(utilcollections.get_size(dict.get(collections, "trad_list")),),)
  io.println("StringListSimp has size: " <> int.to_string(utilcollections.get_size(dict.get(collections, "simp_list")),),)
  io.println("StringDictTrad has size: " <> int.to_string(utilcollections.get_size(dict.get(collections, "trad_dict")),),)
  io.println("StringDictSimp has size: " <> int.to_string(utilcollections.get_size(dict.get(collections, "simp_dict")),),)
  io.println("StringSetTrad has size: " <> int.to_string(utilcollections.get_size(dict.get(collections, "trad_set")),),)
  io.println("StringSetSimp has size: " <> int.to_string(utilcollections.get_size(dict.get(collections, "simp_set")),),)
  io.println("StringSetTotal has size: " <> int.to_string(utilcollections.get_size(dict.get(collections, "total_set")),),)


  let trad8000: List(String) = case result.unwrap(dict.get(collections, "trad_list"), utilcollections.StringListTrad([])) {
    utilcollections.StringListTrad(list) -> list
    _ -> []
  }

  let path = "C:/Users/CMLyk/WebstormProjects/yuema/src/outputfiles/trad8000.txt"
  case write_list_to_file(path, trad8000) {
    Ok(_) -> io.println("File written successfully")
    Error(msg) -> io.println("Error writing file: " <> msg)
  }

  // Original print statement
  io.println("Hello from yuema! lykke 222333 xxxx")
}

pub fn write_list_to_file(path: String, list: List(String)) -> Result(Nil, String) {
  let content = string.join(list, "\n")
  simplifile.write(to: path, contents: content)
  |> result.map_error(fn(error) { simplifile.describe_error(error) })
}