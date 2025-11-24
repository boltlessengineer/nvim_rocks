; inherits toml

; """#!/usr/bin/env bash
(
  (string ["\"\"\"" "'''"]) @_str @injection.content
  (#lua-match? @_str "^...#!.*bash")
  (#offset! @injection.content 0 3 0 3)
  (#set! injection.language "bash"))
