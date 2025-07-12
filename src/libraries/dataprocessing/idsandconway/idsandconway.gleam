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
//C:\Users\CMLyk\WebstormProjects\yuema\src\libraries\dataprocessing\idsandconway\idsandconway_ids_v2.gleam
import libraries/dataprocessing/idsandconway/idsandconway_ids_v2



pub fn idsrecur_to_string_short_v1(ids: Idsrecur) -> String {
  let first: Option(HanChar) = idsandconway_ids_v2.first_of_three_v2(ids)
  let second: Option(HanChar) = idsandconway_ids_v2.second_of_three_v2(ids)
  let third: Option(HanChar) = idsandconway_ids_v2.third_of_three_v2(ids)

  case first {
    None -> panic as idsrecur.idsrecur_to_string(ids)
    Some(_) -> {
      let first_str = case first {
        Some(han) -> idsrecur.hanchar_to_string(han)
        None -> ""
      }
      let second_str = case second {
        Some(han) -> idsrecur.hanchar_to_string(han)
        None -> ""
      }
      let third_str = case third {
        Some(han) -> idsrecur.hanchar_to_string(han)
        None -> ""
      }
      first_str <> second_str <> third_str
    }
  }
}

//pub fn idsrecur_to_string_short_v1(ids: Idsrecur) -> String {
//  let first: Option(HanChar) = idsandconway_idshelper.first_of_three_v1(ids)
//  let second: Option(HanChar) = idsandconway_idshelper.second_of_three_v1(ids)
//  let third: Option(HanChar) = idsandconway_idshelper.third_of_three_v1(ids)

//  case first {
//    None -> panic as idsrecur.idsrecur_to_string(ids)
//    Some(_) -> {
//      let first_str = idsrecur.hanchar_to_string_option(first)
//      let second_str = idsrecur.hanchar_to_string_option(second)
//      let third_str = idsrecur.hanchar_to_string_option(third)
//      first_str <> second_str <> third_str
//    }
//  }
//}


