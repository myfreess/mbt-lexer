type TokenTriple (Token, Position, Position)

impl Show for TokenTriple with output(self, logger) {
  logger.write_char('(')
  logger.write_object(self._.0)
  logger.write_char(' ')
  let l1 = self._.1.lnum
  let c1 = self._.1.cnum - self._.1.bol + 1
  let l2 = self._.2.lnum
  let c2 = self._.2.cnum - self._.2.bol + 2
  logger.write_string("\{l1}:\{c1}-\{l2}:\{c2}")
  logger.write_char(')')
}