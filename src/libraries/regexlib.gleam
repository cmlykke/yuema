// Centralized regex patterns library

// Character classification patterns
pub const regex_pattern_shapechar: String = "[\\x{2FF0}-\\x{2FFF}\\x{303E}\\x{31EF}]"
pub const regex_pattern_hanchar: String = "[\\x{80}-\\x{D7FF}\\x{E000}-\\x{10FFFF}]"

pub const regex_printtest_one: String = "[\\x{2460}-\\x{24FF}]"

//pub const regex_parse_conway: String = "^U\\+[0-9A-F]{4,6}\\s+\\S+\\s+([0-9|()]+)(?:\\s*.*)?$"

// Multiline mode (?m) so ^ and $ anchor to line boundaries.
// Allow digits 1-5, pipes, parentheses, and backslashes in the sequence.
// Permit trailing whitespace at line end (handles CRLF).
// Match one TSV record line (no ^/$, apply to each line):
// U+XXXX<TAB><char>(optional ^ or *)<TAB><stroke-seq>
// stroke-seq allows [1-5|()\\]+ (backslash escaped)
//pub const regex_parse_conway: String = "U\\+[0-9A-F]{4,6}\\t\\S+(?:[\\^\\*])?\\t([1-5|()\\\\]+)"

pub const regex_parse_conway: String = "U\\+[0-9A-F]{4,6}\\t(\\S+(?:[\\^\\*])?)\\t([1-5|()\\\\]+)"

pub const regex_big5 = "[\\x{80}-\\x{D7FF}\\x{E000}-\\x{10FFFF}]"
