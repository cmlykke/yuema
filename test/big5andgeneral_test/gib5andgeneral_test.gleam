import gleeunit
import gleeunit/should
import libraries/big5andgeneralstadardlibrary/big5andgeneralstandard
import libraries/util/utilcollections.{Collections}
import gleam/dict
import gleam/list
import gleam/set

pub fn main() {
  gleeunit.main()
}

pub fn characters_to_support_test() {
  let collection = big5andgeneralstandard.characters_to_support()

  // Test 1: Check that the collection is properly structured
  should.equal(
  collection,
  Collections(
  simp_list_stroke: collection.simp_list_stroke,
  simp_list: collection.simp_list,
  simp_set: collection.simp_set,
  simp_dict: collection.simp_dict,
  trad_list: collection.trad_list,
  trad_set: collection.trad_set,
  trad_dict: collection.trad_dict,
  total_set: collection.total_set,
  ),
  )

  // Test 2: Verify non-empty lists and dictionaries
  should.be_true(list.length(collection.simp_list_stroke) > 0)
  should.be_true(list.length(collection.simp_list) > 0)
  should.be_true(list.length(collection.trad_list) > 0)
  should.be_true(dict.size(collection.simp_set) > 0)
  should.be_true(dict.size(collection.simp_dict) > 0)
  should.be_true(dict.size(collection.trad_set) > 0)
  should.be_true(dict.size(collection.trad_dict) > 0)
  should.be_true(dict.size(collection.total_set) > 0)

  // Test 3: Check expected sizes based on file names
  should.equal(list.length(collection.simp_list_stroke), 8105) // generalstandard2013_8105.txt
  should.equal(list.length(collection.trad_list), 8000) // Tzai2006.txt, limited to 8000
  should.be_true(dict.size(collection.simp_set) <= 8105) // Set may remove duplicates
  should.be_true(dict.size(collection.trad_set) <= 8000) // Set may remove duplicates
  should.be_true(dict.size(collection.total_set) >= 8105) // Union of general and trad

  // Test 4: Verify intersection and difference logic
  let junda_list = big5andgeneralstandard.jundacomplete()
  let general_set = big5andgeneralstandard.general_set_raw()
  let intersec = set.intersection(
  set.from_list(collection.simp_list_stroke),
  set.from_list(junda_list),
  )
  let junda_no_general = list.filter(junda_list, fn(item) {
    !set.contains(intersec, item)
  })
  let general_no_junda = list.filter(collection.simp_list_stroke, fn(item) {
    !set.contains(intersec, item)
  })
  should.equal(
  list.length(collection.simp_list),
  list.length(junda_no_general) + list.length(general_no_junda),
  )

  // Test 5: Check that simp_dict and trad_dict have correct indexing
  let first_simp = list.first(collection.simp_list)
  should.be_ok(first_simp)
  case first_simp {
    Ok(char) -> should.equal(dict.get(collection.simp_dict, char), Ok(0))
    Error(_) -> should.fail()
  }
  let first_trad = list.first(collection.trad_list)
  should.be_ok(first_trad)
  case first_trad {
    Ok(char) -> should.equal(dict.get(collection.trad_dict, char), Ok(0))
    Error(_) -> should.fail()
  }

  // Test 6: Verify total_set contains all characters from simp_set and trad_set
  let all_chars = dict.keys(collection.simp_set) |> list.append(dict.keys(collection.trad_set))
  should.be_true(
  list.all(all_chars, fn(char) { dict.has_key(collection.total_set, char) }),
  )
}