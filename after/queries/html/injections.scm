; inherits html

; <div hx-on:click="foo()">
(attribute
  (attribute_name) @_name
  (#lua-match? @_name "^hx%-on:")
  (quoted_attribute_value
    (attribute_value) @injection.content)
  (#set! injection.language "javascript"))

; <div hx-vals='js:{...}'>
(attribute
  (attribute_name) @_name
  (#lua-match? @_name "^hx%-vals")
  (quoted_attribute_value
    (attribute_value) @injection.content)
  (#lua-match? @injection.content "^js:")
  (#offset! @injection.content 0 2 0 0)
  (#set! injection.language "javascript"))

; <div hx-vals='javascript:{...}'>
(attribute
  (attribute_name) @_name
  (#lua-match? @_name "^hx%-vals")
  (quoted_attribute_value
    (attribute_value) @injection.content)
  (#lua-match? @injection.content "^javascript:")
  (#offset! @injection.content 0 11 0 0)
  (#set! injection.language "javascript"))

; <meta name="htmx-config" content='{...}'>
(start_tag
  (tag_name) @_meta
  (#eq? @_meta "meta")
  (attribute
    (attribute_name) @_attr
    (#eq? @_attr "name")
    (quoted_attribute_value
      (attribute_value) @_name
      (#eq? @_name "htmx-config")))
  (attribute
    (attribute_name) @_content
    (#eq? @_content "content")
    (quoted_attribute_value
      (attribute_value) @injection.content))
  (#set! injection.language "json"))
