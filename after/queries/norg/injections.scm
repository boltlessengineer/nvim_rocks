(ranged_tag
  name: (_) @_keyword
  (#any-of? @_keyword "code" "embed")
  ;; TODO: only accept first argument as @_lang
  param: (_) @injection.language
  line: (_) @injection.content
  (#set! injection.combined))

(ranged_tag
  name: (_) @_keyword
  (#eq? @_keyword "eval")
  line: (_) @injection.content
  (#set! injection.language "janet")
  (#set! injection.combined))
