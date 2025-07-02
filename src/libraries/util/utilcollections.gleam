import gleam/dict.{type Dict}
import gleam/list

pub type CharacterCollection {
  Collections(
  simp_list_stroke: List(String),
  simp_list: List(String),
  simp_set: Dict(String, Bool),
  simp_dict: Dict(String, Int),
  trad_list: List(String),
  trad_set: Dict(String, Bool),
  trad_dict: Dict(String, Int),
  total_set: Dict(String, Bool),
  )
}



