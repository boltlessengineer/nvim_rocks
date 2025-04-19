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
((null_list_prefix) @conceal
  (#set! conceal ""))

(bold) @markup.strong
(italic) @markup.italic
(underline) @markup.underline
(strikethrough) @markup.strikethrough
(verbatim) @markup.raw.verbatim @nospell
(inline_macro) @function.macro

( [
    (bold [(bold_open) (bold_close)] @conceal)
    (italic [(italic_open) (italic_close)] @conceal)
    (underline [(underline_open) (underline_close)] @conceal)
    (strikethrough [(strikethrough_open) (strikethrough_close)] @conceal)
    (verbatim [(verbatim_open) (verbatim_close)] @conceal)
  ]
  (#set! conceal ""))

(link
  [
    "["
    "]"
    "{"
    "}"
  ] @conceal
  (#set! conceal ""))
;; only conceal target when markup exists for that link
(link
  target: (_) @conceal
  markup: (_) @markup.link
  (#set! conceal ""))
(link
  target: (_) @markup.link
  !markup)
(anchor
  [
    "["
    "]"
    "{"
    target: (_)
    "}"
  ] @conceal
  (#set! conceal ""))
(anchor
  markup: (_) @markup.link)

(escape_sequence) @string.escape
(hard_break) @string.escape

((escape_sequence) @conceal
  (#offset! @conceal 0 0 0 -1)
  (#set! conceal ""))

((hard_break) @conceal
  (#set! conceal ""))

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
