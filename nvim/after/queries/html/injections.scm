; extends

; Inject the `tsx` parser into <script type="text/babel"> blocks so that
; JSX syntax (e.g. <Component />) is highlighted. The built-in html injection
; only injects plain `javascript`, which does not understand JSX.
((script_element
  (start_tag
    (attribute
      (attribute_name) @_name
      (quoted_attribute_value (attribute_value) @_value)))
  (raw_text) @injection.content)
 (#eq? @_name "type")
 (#eq? @_value "text/babel")
 (#set! injection.language "tsx"))
