import gleam/dict.{type Dict}
import gleam/set.{type Set}

pub type CharacterCollection {
  StringListTrad(List(String))
  StringListSimp(List(String))
  StringDictTrad(Dict(String, String))
  StringDictSimp(Dict(String, String))
  StringSetTrad(Set(String))
  StringSetSimp(Set(String))
  StringSetTotal(Set(String))
}



//pub fn create_collection() -> Dict(String, TargetCharacterCollection) {
//  let string_list = ["apple", "banana", "cherry"]
//  let string_dict = dict.from_list([#("name", "Alice"), #("city", "Wonderland")])
//  let string_set = dict.from_list([#("item1", True), #("item2", True)])

//  dict.from_list([
//  #("list", StringList(string_list)),
//  #("dict", StringDict(string_dict)),
//  #("set", StringSet(string_set)),
//  ])
//}