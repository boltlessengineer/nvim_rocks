; extends

((comment) @comment
  . (_ (raw_string_literal) @injection.content)
  (#match? comment "/\/\* sql \*\//")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "sql"))
(call_expression
  function: (_) @_function
  (#any-of? @_function
    "db.Exec" "db.Query")
  arguments: (argument_list
    .
    [
      (raw_string_literal)
      (interpreted_string_literal)
    ] @injection.content
    (#offset! @injection.content 0 1 0 -1)
    (#set! injection.language "sql")))
