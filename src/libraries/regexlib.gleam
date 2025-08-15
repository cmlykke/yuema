// Centralized regex patterns library

// Character classification patterns
pub const regex_pattern_shapechar: String = "[\\x{2FF0}-\\x{2FFF}\\x{303E}\\x{31EF}]"
pub const regex_pattern_hanchar: String = "[\\x{80}-\\x{D7FF}\\x{E000}-\\x{10FFFF}]"

pub const regex_printtest_one: String = "[\\x{2460}-\\x{24FF}]"

pub const regex_parse_conway: String = "^U\\+[0-9A-F]{4,6}\\s+([\\x{2E7F}-\\x{10FFFF}][*^]?)\\s+([0-9|()]+)(?:\\s*.*)?$"

pub const regex_big5 = "[\\x{80}-\\x{D7FF}\\x{E000}-\\x{10FFFF}]"
