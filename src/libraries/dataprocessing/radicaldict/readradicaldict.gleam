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
import libraries/dataprocessing/idsandconway/createidsrecur
import libraries/dataprocessing/idsandconway/idsandconway_ids_v1
import libraries/dataprocessing/idsandconway/idsandconway_ids_v2


pub fn get_fixed_stroke_dict() -> dict.Dict(String, String) {
  readcodefiles("./src/resources/manuallycreatedfiles/codedict_fixedstroke.txt")
}

pub fn get_fixed_radical_dict() -> dict.Dict(String, String) {
  readcodefiles("./src/resources/manuallycreatedfiles/codedict_fixedradical.txt")
}

fn readcodefiles(path: String) -> dict.Dict(String, String) {
  let assert Ok(content) = simplifile.read(from: path)

  let lines = string.split(content, on: "\n")

  let lines = list.filter(lines, fn(line) {
    let trimmed = string.trim(line)
    !string.is_empty(trimmed)
  })

  list.fold(lines, dict.new(), fn(acc, line) {
    let trimmed = string.trim(line)
    let words = string.split(trimmed, on: " ")
    let words = list.filter(words, fn(w) { !string.is_empty(w) })
    case words {
      [key, value] -> dict.insert(acc, key, value)
      _ -> acc
    }
  })
}



