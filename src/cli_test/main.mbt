fn main {
  let filename = @sys.get_cli_args()[1] // use native backend
  let str = 
    try {
      @fs.read_file_to_string!(filename)
    } catch {
      _ => {
        println("read file \{filename} falied")
        panic()
      }
    }
  let errors = []
  ignore(@lex.tokens_from_string(comment=true, errors~, str))
  if errors.length() == 0 {
    println("- \{filename} PASSED\n")
  } else {
    println("- \{filename} FAILED")
    println("```")
    println(errors)
    println("```")
  }
}