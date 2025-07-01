import gleam/dict.{type Dict}
import gleam/list

pub type CharacterCollection {
  StringListTrad(List(String))
  StringListSimp(List(String))
  StringDictTrad(Dict(String, Int))
  StringDictSimp(Dict(String, Int))
  StringSetTrad(Dict(String, Bool))
  StringSetSimp(Dict(String, Bool))
  StringSetTotal(Dict(String, Bool))
}



pub fn get_size(collection: Result(CharacterCollection, Nil)) -> Int {
  case collection {
    Ok(StringListSimp(list)) -> list.length(list)
    Ok(StringListTrad(list)) -> list.length(list)
    Ok(StringDictSimp(dict)) -> dict.size(dict)
    Ok(StringDictTrad(dict)) -> dict.size(dict)
    Ok(StringSetSimp(dict)) -> dict.size(dict)
    Ok(StringSetTrad(dict)) -> dict.size(dict)
    Ok(StringSetTotal(dict)) -> dict.size(dict)
    Error(Nil) -> 0 // Default size for missing collection
  }
}

