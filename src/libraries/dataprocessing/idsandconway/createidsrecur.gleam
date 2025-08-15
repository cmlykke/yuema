
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
import libraries/regexlib

// C:\Users\CMLyk\WebstormProjects\yuema\src\libraries\dataprocessing\idsandconway\createidsrecur.gleam

// import libraries/dataprocessing/idsandconway/createidsrecur

//********************************************** create recursion object **********************************
pub fn is_shape_char(input: String) -> Bool {
  case string.length(input) == 1 {
    True -> {
      let assert Ok(regex) = regexp.compile(regexlib.regex_pattern_shapechar, regexp.Options(case_insensitive: False, multi_line: False))
      regexp.check(regex, input)
    }
    False -> False
  }
}

pub fn idsrecursion(char: String, ids: Dict(String, String)) -> Idsrecur {
  case dict.get(ids, char) {
    Ok(val) if val != char -> {
      let graphemes_raw = string.to_graphemes(val)
      let graphemes = list.filter(graphemes_raw, fn(g) { string.byte_size(g) > 1 })
      let #(inner, remaining) = parse_component(graphemes, ids)
      case remaining {
        [] -> idsrecur.idsrecur_new( idsrecur.idsrecur_get_shape_char(inner),
        idsrecur.idsrecur_get_han_char(inner),
        Some(idsrecur.hanchar_new(char)),
        idsrecur.idsrecur_get_children(inner))
        _ -> {
          let message ="Extra characters after parsing IDS sequence: " <> char
          panic as message
        }
      }
    }
    _ -> {
      idsrecur.idsrecur_new(None, Some(idsrecur.hanchar_new(char)), None, [])
    }
  }
}

fn parse_component(graphemes: List(String), ids: Dict(String, String)) -> #(Idsrecur, List(String)) {
  case graphemes {
    [head, ..rest] -> {
      case is_shape_char(head) {
        True -> {
          let arity = case head {
            "⿲" | "⿳" -> 3
            _ -> 2
          }
          let shape = idsrecur.shapechar_new(head)
          let #(children_rev, final_rem) = list.fold(list.range(0, arity - 1), #([], rest), fn(state, _) {
            let #(ch_rev, rem) = state
            let #(sub, new_rem) = parse_component(rem, ids)
            #([Some(sub), ..ch_rev], new_rem)
          })
          let children = list.reverse(children_rev)
          let node = idsrecur.idsrecur_new(Some(shape), None, None, children)
          #(node, final_rem)
        }
        False -> {
          let node = idsrecursion(head, ids)
          #(node, rest)
        }
      }
    }
    [] -> {
      let message = "Empty graphemes in parse_component: " <> string.concat(graphemes)
      panic as message
    }
  }
}
