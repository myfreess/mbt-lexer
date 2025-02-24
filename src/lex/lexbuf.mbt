///|
struct CharsLexbuf {
  content : Array[Char] // read only
  mut pos : Int
  end : Int
}

///|
fn CharsLexbuf::from_string(
  str : String
) -> @lexbuf.Lexbuf[CharsLexbuf, String, Int] {
  let content = str.to_array()
  let buf = CharsLexbuf::{ content, pos: 0, end: content.length() }
  let bufclass = @lexbuf.LexbufClass::{
    next: CharsLexbuf::next,
    curr_pos: CharsLexbuf::curr_pos,
    reset: CharsLexbuf::reset,
    sub_lexeme: CharsLexbuf::sub_lexeme,
  }
  (bufclass, buf)
}

///|
fn CharsLexbuf::next(self : CharsLexbuf) -> Char? {
  if self.pos < self.end {
    let i = self.pos
    self.pos += 1
    return Some(self.content[i])
  } else {
    return None
  }
}

///|
fn CharsLexbuf::curr_pos(self : CharsLexbuf) -> Int {
  return self.pos
}

///|
fn CharsLexbuf::reset(self : CharsLexbuf, pos : Int) -> Unit {
  self.pos = pos
}

///|
fn CharsLexbuf::sub_lexeme(
  self : CharsLexbuf,
  start : Int,
  end : Int
) -> String {
  let buf = StringBuilder::new(size_hint=end - start)
  for ch in self.content[start:end] {
    buf.write_char(ch)
  }
  buf.to_string()
}
