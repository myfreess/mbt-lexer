///|
fn test_bytes(s : String) -> String {
  guard s is [.. "b\"", ..]
  let s = s.substring(start=2)
  let lexbuf = CharsLexbuf::from_string(s)
  let env = LexEnv::new()
  let tok = string(
    lexbuf,
    env~,
    end_with_newline=false,
    allow_interp=false,
    startpos=0,
  )
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
      #|[InterpLit(repr="\\x61\\x62\\x63\\x64", loc={start: {fname: "", lnum: 1, bol: 0, cnum: 0}, end: {fname: "", lnum: 1, bol: 0, cnum: 17}})]
    ,
  )
  inspect!(
    test_bytes(
      #|b"ABC"
      ,
    ),
    content=
      #|[InterpLit(repr="ABC", loc={start: {fname: "", lnum: 1, bol: 0, cnum: 0}, end: {fname: "", lnum: 1, bol: 0, cnum: 4}})]
    ,
  )
  inspect!(
    test_bytes(
      #|b"\o377"
      ,
    ),
    content=
      #|[InterpLit(repr="\\o377", loc={start: {fname: "", lnum: 1, bol: 0, cnum: 0}, end: {fname: "", lnum: 1, bol: 0, cnum: 6}})]
    ,
  )
  inspect!(
    test_bytes(
      #|b"\o999"
      ,
    ),
    content=
      #|({fname: "", lnum: 1, bol: 0, cnum: 0}, {fname: "", lnum: 1, bol: 0, cnum: 5}, "invalid escape sequence: \\o999")
    ,
  )
  inspect!(
    test_bytes(
      #|b"\n\t"
      ,
    ),
    content=
      #|[InterpLit(repr="\\n\\t", loc={start: {fname: "", lnum: 1, bol: 0, cnum: 0}, end: {fname: "", lnum: 1, bol: 0, cnum: 5}})]
    ,
  )
  inspect!(
    test_bytes(
      #|b"ABC
      #|DEF"
      ,
    ),
    content=
      #|[InterpLit(repr="ABC\nDEF", loc={start: {fname: "", lnum: 1, bol: 0, cnum: 0}, end: {fname: "", lnum: 1, bol: 0, cnum: 8}})]
    ,
  )
  inspect!(
    test_bytes(
      #|b"中"
      ,
    ),
    content=
      #|[InterpLit(repr="中", loc={start: {fname: "", lnum: 1, bol: 0, cnum: 0}, end: {fname: "", lnum: 1, bol: 0, cnum: 2}})]
    ,
  )
}

///|
fn test_string(s : String) -> String {
  guard s is [.. "\"", ..]
  let s = s.substring(start=1)
  let lexbuf = CharsLexbuf::from_string(s)
  let env = LexEnv::new()
  let interps = string(
    lexbuf,
    env~,
    end_with_newline=false,
    allow_interp=true,
    startpos=0,
  )
  interps.to_string()
}

///|
test "string literal" {
  inspect!(
    test_string(
      #|"ABCDE"
      ,
    ),
    content=
      #|[InterpLit(repr="ABCDE", loc={start: {fname: "", lnum: 1, bol: 0, cnum: 0}, end: {fname: "", lnum: 1, bol: 0, cnum: 6}})]
    ,
  )
  inspect!(
    test_string(
      #|"ABCD\nEFG"
      ,
    ),
    content=
      #|[InterpLit(repr="ABCD\\nEFG", loc={start: {fname: "", lnum: 1, bol: 0, cnum: 0}, end: {fname: "", lnum: 1, bol: 0, cnum: 10}})]
    ,
  )
  inspect!(
    test_string(
      #|"😭"
      ,
    ),
    content=
      #|[InterpLit(repr="😭", loc={start: {fname: "", lnum: 1, bol: 0, cnum: 0}, end: {fname: "", lnum: 1, bol: 0, cnum: 2}})]
    ,
  )
  inspect!(
    test_string(
      #|"\u{1F62D}"
      ,
    ),
    content=
      #|[InterpLit(repr="\\u{1F62D}", loc={start: {fname: "", lnum: 1, bol: 0, cnum: 0}, end: {fname: "", lnum: 1, bol: 0, cnum: 10}})]
    ,
  )
}

///|
fn test_unicode_id(s : String) -> String {
  let lexbuf = CharsLexbuf::from_string(s)
  let buf = StringBuilder::new()
  unicode_ident(lexbuf, buf)
  buf.to_string()
}

///|
test "unicode identifier" {
  inspect!(test_unicode_id("fn"), content="fn")
  inspect!(test_unicode_id("fn init"), content="fn")
}

///|
fn test_tokens(t : @test.T, label : String) -> Unit!Error {
  let source = @fs.read_file_to_string!("src/lex/sources/\{label}")
  let triples = tokens_from_string(comment=true, source)
  for triple in triples {
    t.writeln(triple.to_string())
  }
  t.snapshot!(filename="\{label}.tokens")
}

///|
test "tokens 001" (t : @test.T) {
  test_tokens!(t, "001")
}

///|
test "tokens trait_labeled" (t : @test.T) {
  test_tokens!(t, "trait_labeled")
}

///|
test "tokens super_traits" (t : @test.T) {
  test_tokens!(t, "super_traits")
}

///|
test "token utf16_escape" (t : @test.T) {
  test_tokens!(t, "utf16_escape")
}

///|
test "tokens unicode_test" (t : @test.T) {
  test_tokens!(t, "unicode_test")
}

///|
test "tokens string_literal" (t : @test.T) {
  test_tokens!(t, "string_literal")
}

///|
test "tokens string_escapes" (t : @test.T) {
  test_tokens!(t, "string_escapes")
}

///|
test "tokens double_to_string" (t : @test.T) {
  test_tokens!(t, "double_to_string")
}
