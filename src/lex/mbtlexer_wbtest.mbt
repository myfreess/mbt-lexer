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
  inspect!(
    test_bytes(
      #|b"😭"
    )
  , content=#|({fname: "", lnum: 1, bol: 0, cnum: 0}, {fname: "", lnum: 1, bol: 0, cnum: 2}, "non-ASCII character is not allowed in bytes literal. If you meant to use the UTF-8 encoding of '😭', use escape sequence instead.")
  )
}

fn test_string(s : String) -> String {
  guard s is [.. "\"", ..]
  let s = s.substring(start=1)
  let lexbuf = @lexbuf.from_string(s)
  let env = LexEnv::new()
  let interps = string(lexbuf, env~, multiline_string=false, startpos=0)
  interps.to_string()
}

test "string literal" {
  inspect!(
    test_string(
      #|"ABCDE"
    )
  , content=#|[InterpLit(c="ABCDE", repr="ABCDE", loc={start: {fname: "", lnum: 1, bol: 0, cnum: 0}, end: {fname: "", lnum: 1, bol: 0, cnum: 6}})]
  )
  inspect!(
    test_string(
      #|"ABCD\nEFG"
    )
  , content=#|[InterpLit(c="ABCD\nEFG", repr="ABCD\\nEFG", loc={start: {fname: "", lnum: 1, bol: 0, cnum: 0}, end: {fname: "", lnum: 1, bol: 0, cnum: 10}})]
  )
  inspect!(
    test_string(
      #|"😭"
    )
  , content=#|[InterpLit(c="😭", repr="😭", loc={start: {fname: "", lnum: 1, bol: 0, cnum: 0}, end: {fname: "", lnum: 1, bol: 0, cnum: 3}})]
  )
  inspect!(
    test_string(
      #|"\u{1F62D}"
    )
  , content=#|[InterpLit(c="😭", repr="\\u{1F62D}", loc={start: {fname: "", lnum: 1, bol: 0, cnum: 0}, end: {fname: "", lnum: 1, bol: 0, cnum: 10}})]
  )
}

fn test_unicode_id(s : String) -> String {
  let lexbuf = @lexbuf.from_string(s)
  let buf = StringBuilder::new()
  unicode_ident(lexbuf, buf)
  buf.to_string()
}


test "unicode identifier" {
  inspect!(test_unicode_id("fn"), content="fn")
  inspect!(test_unicode_id("fn init"), content="fn")
}

fn test_tokens(t : @test.T, label : String) -> Unit!Error {
  let source = @fs.read_file_to_string!("sources/\{label}")
  let triples = tokens_from_string(comment = true, source)
  for triple in triples {
    t.writeln(triple.to_string())
  }
  t.snapshot!(filename = "\{label}.tokens")
}

test "tokens 001" (t : @test.T) {
  test_tokens!(t, "001") 
}

test "tokens trait_labeled" (t : @test.T) {
  test_tokens!(t, "trait_labeled") 
}

test "tokens super_traits" (t : @test.T) {
  test_tokens!(t, "super_traits") 
}

test "token utf16_escape" (t : @test.T) {
  test_tokens!(t, "utf16_escape")
}
