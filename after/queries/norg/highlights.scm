(empty_heading) @markup.heading.marker
(document
  (section
    (heading
      (heading_prefix) @markup.heading.1.marker
      title: (_) @markup.heading.1)))
(document
  (section
    (section
      (heading
        (heading_prefix) @markup.heading.2.marker
        title: (_) @markup.heading.2))))
(document
  (section
    (section
      (section
        (heading
          (heading_prefix) @markup.heading.3.marker
          title: (_) @markup.heading.3)))))
(document
  (section
    (section
      (section
        (section
          (heading
            (heading_prefix) @markup.heading.4.marker
            title: (_) @markup.heading.4))))))
(document
  (section
    (section
      (section
        (section
          (section
            (heading
              (heading_prefix) @markup.heading.5.marker
              title: (_) @markup.heading.5)))))))
(section
  (section
    (section
      (section
        (section
          (section
            (heading
              (heading_prefix) @markup.heading.6.marker
              title: (_) @markup.heading.6)))))))

(unordered_list_prefix) @markup.list
(ordered_list_prefix) @markup.list
(quote) @markup.quote
((null_list_prefix) @conceal)

(bold) @markup.strong
(italic) @markup.italic
(underline) @markup.underline
(strikethrough) @markup.strikethrough
(verbatim) @markup.raw.verbatim @nospell
(inline_macro
  "\\" @function.macro
  name: (_) @function.macro) @nospell

(paragraph) @spell
(_
  target: (_) @nospell)
(verbatim) @nospell

( [
    (bold [(bold_open) (bold_close)] @conceal)
    (italic [(italic_open) (italic_close)] @conceal)
    (underline [(underline_open) (underline_close)] @conceal)
    (strikethrough [(strikethrough_open) (strikethrough_close)] @conceal)
    (verbatim [(verbatim_open) (verbatim_close)] @_markup)
    (link ["[" "]" "{" "}"] @conceal)
    (anchor ["[" "]" "{" "}"] @conceal)
  ]
  (#set! conceal ""))

(_
  target: (scoped_target
            . ":" @conceal)
  (#set! conceal ""))
(_
  markup: (_) @spell)

;; only conceal target when markup exists for that link
(link
  target: (_) @conceal
  markup: (_)
  (#set! conceal ""))
(anchor
  target: (_) @conceal
  (#set! conceal ""))
(link
  markup: (_) @markup.link)
(link
  target: (_) @markup.link
  !markup)
(anchor
  markup: (_) @markup.link)

(escape_sequence) @string.escape
(hard_break) @string.escape

((escape_sequence) @_conceal
  (#offset! @_conceal 0 0 0 -1)
  (#set! conceal ""))

((hard_break) @conceal
  (#set! conceal ""))

((attributes) @conceal
  (#has-ancestor? @conceal paragraph)
  (#set! conceal ""))

(attribute
  key: (_) @variable.member)
(attribute
  value: (_) @string)

(ranged_tag
  [
    (ranged_open)
    name: (_)
    (ranged_close)
  ] @function.macro)
(ranged_tag
  line: (_) @markup.raw.block @nospell
  (#set! "priority" 90))
(infirm_tag
  [
    (infirm_tag_prefix)
    name: (_)
  ] @function.macro)

(ERROR) @error

; vim:ts=2:sw=2:
