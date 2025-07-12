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


//C:\Users\CMLyk\WebstormProjects\yuema\src\libraries\util\idsrecur.gleam


// Accessor for shape_char value as string

pub fn idsrecur_to_string_public(inp: String, ids: Dict(String, String)) -> String {
  let recur = createidsrecur.idsrecursion(inp, ids)
  idsrecur_to_string_short(recur)
}

pub fn idsrecur_to_string_short(ids: Idsrecur) -> String {
  let prev_opt: Option(HanChar) = idsrecur.idsrecur_get_previus_han_char(ids)
  let shape_opt: Option(ShapeChar) = idsrecur.idsrecur_get_shape_char(ids)
  let children:  List(Idsrecur) = list.map(idsrecur.idsrecur_get_children(ids), fn(opt) {
    let assert Some(child) = opt
    child
  })

  case shape_opt {
    Some(shape) -> {
      case idsrecur.shapechar_to_string(shape) == "⿰" {
        True -> {
          case children {
            [child1, child2] -> build_from_multiple([child1, child2], child2)
            _ -> {
              let message = "Expected exactly two children for shape ⿰: " <> idsrecur.hanchar_to_string_option(prev_opt)
              panic as message
            }
          }
        }
        False -> general_case(children, ids)
      }
    }
    None -> general_case(children, ids)
  }
}


// Helper to get the left-most HanChar in the subtree
fn leftmost_han(ids: Idsrecur) -> HanChar {
  case idsrecur.idsrecur_get_han_char(ids) {
    Some(h) -> h
    None -> {
      let children = list.map(idsrecur.idsrecur_get_children(ids), fn(opt) {
        let assert Some(child) = opt
        child
      })
      let assert Ok(first) = list.first(children)
      leftmost_han(first)
    }
  }
}

// Helper to get the right-most previous HanChar in the subtree
fn rightmost_previous(ids: Idsrecur) -> Option(HanChar) {
  case idsrecur.idsrecur_get_han_char(ids) {
    Some(_) -> None
    None -> {
      let children = list.map(idsrecur.idsrecur_get_children(ids), fn(opt) {
        let assert Some(child) = opt
        child
      })
      case list.is_empty(children) {
        True -> panic as "Internal node with no children"
        False -> {
          let assert Ok(last) = list.last(children)
          case rightmost_previous(last) {
            Some(p) -> Some(p)
            None -> idsrecur.idsrecur_get_previus_han_char(ids)
          }
        }
      }
    }
  }
}

// Helper to get the right-most previous HanChar if allowed by the conditions
fn get_rightmost_previous_if_allowed(ids: Idsrecur) -> Option(HanChar) {
  case idsrecur.idsrecur_get_han_char(ids) {
    Some(_) -> None
    None -> {
      let children = list.map(idsrecur.idsrecur_get_children(ids), fn(opt) {
        let assert Some(child) = opt
        child
      })
      let num = list.length(children)
      case num < 2 {
        True -> None
        False -> {
          let assert Ok(last) = list.last(children)
          rightmost_previous(last)
        }
      }
    }
  }
}

// Helper to get string from HanChar
fn han_str(han: HanChar) -> String {
  idsrecur.hanchar_to_string(han)
}

// Helper to build string when there are multiple children
fn build_from_multiple(children: List(Idsrecur), third_from: Idsrecur) -> String {
  case children {
    [child1, child2, ..] -> {
      let str1 = leftmost_han(child1) |> han_str
      let str2 = leftmost_han(child2) |> han_str
      case get_rightmost_previous_if_allowed(third_from) {
        Some(third) -> str1 <> str2 <> han_str(third)
        None -> str1 <> str2
      }
    }
    _ -> panic as "Expected at least two children"
  }
}

fn general_case(children: List(Idsrecur), ids: Idsrecur) -> String {
  case children {
    [child1, child2, ..] as multi -> build_from_multiple(multi, ids)
    [child1] -> leftmost_han(child1) |> han_str
    [] -> {
      case idsrecur.idsrecur_get_previus_han_char(ids) {
        Some(p) -> han_str(p)
        None -> {
          let assert Some(h) = idsrecur.idsrecur_get_han_char(ids)
          han_str(h)
        }
      }
    }
  }
}

