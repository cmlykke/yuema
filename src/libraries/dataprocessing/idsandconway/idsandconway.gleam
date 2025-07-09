import gleam/result
import gleam/dict.{type Dict}
import gleam/list
import gleam/regexp
import simplifile
import gleam/string
import libraries/util/utilcollections.{type CharacterCollection, Collections}
import gleam/io
import gleam/set.{type Set}
import gleam/int
import gleam/option.{type Option, None, Some}
import libraries/util/idsrecur.{type Idsrecur, type HanChar, type ShapeChar}

//C:\Users\CMLyk\WebstormProjects\yuema\src\libraries\util\idsrecur.gleam

pub fn idsrecursion(char: String, ids: Dict(String, String)) -> Idsrecur {
  case dict.get(ids, char) {
    Ok(val) if val != char -> {
      let graphemes = string.to_graphemes(val)
      case list.first(graphemes) {
        Ok(shape_str) -> {
          let shape = idsrecur.shapechar_new(shape_str)
          let components = list.drop(graphemes, 1)
          let filtered_components = list.filter(components, fn(c) {
            string.to_graphemes(c)
            |> list.all(fn(g) { string.byte_size(g) > 1 })
          })
          let children = list.map(filtered_components, fn(c) { Some(idsrecursion(c, ids)) })
          idsrecur.idsrecur_new(Some(shape), None, children)
        }
        Error(_) -> {
          let han = idsrecur.hanchar_new(char)
          idsrecur.idsrecur_new(None, Some(han), [])
        }
      }
    }
    _ -> {
      let han = idsrecur.hanchar_new(char)
      idsrecur.idsrecur_new(None, Some(han), [])
    }
  }
}


