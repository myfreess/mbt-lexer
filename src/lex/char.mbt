///|
fn charcode_for_backslash(c : Char) -> UInt {
  match c {
    'n' => 10
    'r' => 13
    'b' => 8
    't' => 9
    _ => c.to_uint()
  }
}

///|
fn digit_value(c : Char) -> UInt {
  match c {
    'a'..='f' => c.to_uint() + 10 - 'a'.to_uint()
    'A'..='F' => c.to_uint() + 10 - 'A'.to_uint()
    '0'..='9' => c.to_uint() - '0'.to_uint()
    _ => panic()
  }
}

///|
fn char_for_hex_escape(hex : String) -> UInt? {
  let mut codep = 0U
  for c in hex {
    let digit = digit_value(c)
    codep = codep * 16 + digit
    if codep > 0x10ffff {
      return None
    }
  } else {
    return Some(codep)
  }
}

///|
fn char_for_oct_escape(oct : String) -> UInt? {
  let mut codep = 0U
  for c in oct {
    let digit = digit_value(c)
    codep = codep * 8 + digit
    if codep > 0x10ffff {
      return None
    }
  } else {
    return Some(codep)
  }
}

///|
fn is_common_ascii(c : Char) -> Bool {
  c is ('0'..='9') || c is ('A'..='Z') || c is ('a'..='z') || c == '_'
}
