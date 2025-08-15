
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
import libraries/regexlib
// Assuming necessary imports and types are already present

pub fn is_enclosed_alphanumeric(h: HanChar) -> Bool {
  let s = idsrecur.hanchar_to_string(h)
  let assert Ok(regex) = regexp.compile(regexlib.regex_printtest_one, regexp.Options(case_insensitive: False, multi_line: False))
  regexp.check(regex, s)
}

pub fn adjusted_han_char_leafs(ids: Idsrecur, current_previus: Option(HanChar)) -> List(HanChar) {
  case idsrecur.idsrecur_get_han_char(ids) {
    Some(h) -> {
      case is_enclosed_alphanumeric(h) {
        True -> {
          case current_previus {
            Some(p) -> [p]
            None -> []
          }
        }
        False -> [h]
      }
    }
    None -> {
      let this_previus = case idsrecur.idsrecur_get_previus_han_char(ids) {
        Some(p) -> Some(p)
        None -> current_previus
      }
      idsrecur.idsrecur_get_children(ids)
      |> list.flat_map(fn(opt) {
        case opt {
          Some(child) -> adjusted_han_char_leafs(child, this_previus)
          None -> []
        }
      })
    }
  }
}

pub fn adjusted_previus_han_char_leafs(ids: Idsrecur, current_previus: Option(HanChar)) -> List(HanChar) {
  let from_self = case idsrecur.idsrecur_get_previus_han_char(ids) {
    Some(p) -> {
      let has_child_with_prev = idsrecur.idsrecur_get_children(ids)
      |> list.any(fn(opt) {
        case opt {
          Some(child) -> option.is_some(idsrecur.idsrecur_get_previus_han_char(child))
          None -> False
        }
      })
      case has_child_with_prev {
        False -> {
          case is_enclosed_alphanumeric(p) {
            True -> {
              case current_previus {
                Some(cp) -> [cp]
                None -> []
              }
            }
            False -> [p]
          }
        }
        True -> []
      }
    }
    None -> []
  }
  let this_previus = case idsrecur.idsrecur_get_previus_han_char(ids) {
    Some(p) -> Some(p)
    None -> current_previus
  }
  let from_children = idsrecur.idsrecur_get_children(ids)
  |> list.flat_map(fn(opt) {
    case opt {
      Some(child) -> adjusted_previus_han_char_leafs(child, this_previus)
      None -> []
    }
  })
  list.append(from_self, from_children)
}

pub fn first_of_three_v2(ids: Idsrecur) -> Option(HanChar) {
  let has_shape = option.is_some(idsrecur.idsrecur_get_shape_char(ids))
  case has_shape {
    True -> {
      let children = idsrecur.idsrecur_get_children(ids)
      case get_at(children, 0) {
        Ok(first_opt) -> {
          let assert Some(first_child) = first_opt
          let prevs = adjusted_previus_han_char_leafs(first_child, idsrecur.idsrecur_get_previus_han_char(ids))
          case prevs {
            [] -> {
              let hans = adjusted_han_char_leafs(first_child, idsrecur.idsrecur_get_previus_han_char(ids))
              case hans {
                [] -> None // panic as "nothing was found for first_of_three_v2"
                [first, ..] -> Some(first)
              }
            }
            [first, ..] -> Some(first)
          }
        }
        Error(_) -> None // panic as "children list does not have a first element"
      }
    }
    False -> {
      let hans = adjusted_han_char_leafs(ids, None)
      case list.length(hans) > 0 {
        True -> {
          case get_at(hans, 0) {
            Ok(first) -> Some(first)
            Error(_) -> None // panic as "hans list does not have a first element"
          }
        }
        False -> None // panic as "nothing was found for first_of_three_v2"
      }
    }
  }
}

pub fn second_of_three_v2(ids: Idsrecur) -> Option(HanChar) {
  let has_shape = option.is_some(idsrecur.idsrecur_get_shape_char(ids))
  case has_shape {
    True -> {
      let children = idsrecur.idsrecur_get_children(ids)
      case get_at(children, 1) {
        Ok(second_opt) -> {
          let assert Some(second_child) = second_opt
          let prevs = adjusted_previus_han_char_leafs(second_child, idsrecur.idsrecur_get_previus_han_char(ids))
          case prevs {
            [] -> {
              let hans = adjusted_han_char_leafs(second_child, idsrecur.idsrecur_get_previus_han_char(ids))
              case hans {
                [] -> None // panic as "nothing was found for second_of_three_v2"
                [first, ..] -> Some(first)
              }
            }
            [first, ..] -> Some(first)
          }
        }
        Error(_) -> None // panic as "children list does not have a second element"
      }
    }
    False -> {
      let hans = adjusted_han_char_leafs(ids, None)
      case list.length(hans) > 1 {
        True -> {
          case get_at(hans, 1) {
            Ok(second) -> Some(second)
            Error(_) -> None // panic as "hans list does not have a second element"
          }
        }
        False -> None // panic as "nothing was found for second_of_three_v2"
      }
    }
  }
}

pub fn third_of_three_v2(ids: Idsrecur) -> Option(HanChar) {
  let has_shape = option.is_some(idsrecur.idsrecur_get_shape_char(ids))
  case has_shape {
    True -> {
      let children = idsrecur.idsrecur_get_children(ids)
      case get_at(children, 1) {
        Ok(second_opt) -> {
          let assert Some(second_child) = second_opt
          let prevs = adjusted_previus_han_char_leafs(second_child, idsrecur.idsrecur_get_previus_han_char(ids))
          case list.length(prevs) > 1 {
            True -> {
              let assert Ok(last) = list.last(prevs)
              Some(last)
            }
            False -> {
              let hans = adjusted_han_char_leafs(second_child, idsrecur.idsrecur_get_previus_han_char(ids))
              case list.length(hans) > 1 {
                True -> {
                  let assert Ok(last) = list.last(hans)
                  Some(last)
                }
                False -> None //panic as "nothing was found for third_of_three_v2"
              }
            }
          }
        }
        Error(_) -> None // panic as "children list does not have a second element"
      }
    }
    False -> {
      let hans = adjusted_han_char_leafs(ids, None)
      case list.length(hans) > 2 {
        True -> {
          let assert Ok(last) = list.last(hans)
          Some(last)
        }
        False -> None // panic as "nothing was found for third_of_three_v2"
      }
    }
  }
}


// Helper function to get an element at a specific index
fn get_at(list: List(a), index: Int) -> Result(a, Nil) {
  case list, index {
    [x, ..], 0 -> Ok(x)
    [_, ..rest], n if n > 0 -> get_at(rest, n - 1)
    _, _ -> Error(Nil)
  }
}