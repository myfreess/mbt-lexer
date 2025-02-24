///|
fn test_bytes(s : String) -> String {
  guard s is [.. "b\"", ..]
  let s = s.substring(start=2)
  let lexbuf = @lexbuf.from_string(s)
  let env = LexEnv::new()
  let tok = bytes(lexbuf, env~)
  if env.errors.length() != 0 {
    env.errors.unsafe_pop().to_string()
  } else {
    tok.to_string()
  }
}

///|
test "bytes literal" {
  inspect!(
    test_bytes(
      #|b"\x61\x62\x63\x64"
      ,
    ),
    content=
      #|BYTES({val: b"\x61\x62\x63\x64", repr: "\\x61\\x62\\x63\\x64"})
    ,
  )
  inspect!(
    test_bytes(
      #|b"ABC"
      ,
    ),
    content=
      #|BYTES({val: b"\x41\x42\x43", repr: "ABC"})
    ,
  )
  inspect!(
    test_bytes(
      #|b"\o377"
    )
  , content=#|BYTES({val: b"\xff", repr: "\\o377"})
  )
  inspect!(
    test_bytes(
      #|b"\o999"
    )
  , content=#|({fname: "", lnum: 1, bol: 0, cnum: 0}, {fname: "", lnum: 1, bol: 0, cnum: 5}, "invalid escape sequence: \\o999")
  )
  inspect!(
    test_bytes(
      #|b"\n\t"
    )
  , content=#|BYTES({val: b"\x0a\x09", repr: "\\n\\t"})
  )
  inspect!(
    test_bytes(
      #|b"ABC
      #|DEF"
    )
  , content=#|({fname: "", lnum: 1, bol: 0, cnum: 3}, {fname: "", lnum: 1, bol: 0, cnum: 4}, "(unterminated bytes literal)")
  )
}
