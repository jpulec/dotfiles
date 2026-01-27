; ============================================================
; Jest/Mocha-style folds for TypeScript
; ============================================================

; ---------- helper: foldable function body ----------
[
  ; Arrow fn with () params (with/without async/type bits)
  (arrow_function (formal_parameters) (statement_block))
  (arrow_function "async" (formal_parameters) (statement_block))
  (arrow_function (formal_parameters) (type_annotation) (statement_block))
  (arrow_function "async" (formal_parameters) (type_annotation) (statement_block))

  ; Arrow fn with type params + ()
  (arrow_function (type_parameters) (formal_parameters) (statement_block))
  (arrow_function "async" (type_parameters) (formal_parameters) (statement_block))
  (arrow_function (type_parameters) (formal_parameters) (type_annotation) (statement_block))
  (arrow_function "async" (type_parameters) (formal_parameters) (type_annotation) (statement_block))

  ; Arrow fn with single identifier param
  (arrow_function (identifier) (statement_block))
  (arrow_function "async" (identifier) (statement_block))
  (arrow_function (identifier) (type_annotation) (statement_block))
  (arrow_function "async" (identifier) (type_annotation) (statement_block))

  ; Classic function expression
  (function_expression (statement_block))
] @__call_body


; ============================================================
; describe / context
; ============================================================

; describe('name', fn)
(call_expression
  function: (identifier) @fn (#match? @fn "^(describe|context)$")
  arguments: (arguments
    [(string) (template_string)]
    @__call_body
    (_)?))
@fold

; describe.only/skip/todo('name', fn)
(call_expression
  function: (member_expression
    object: (identifier) @fn (#match? @fn "^(describe|context)$")
    property: (property_identifier) @mod (#match? @mod "^(only|skip|todo)$"))
  arguments: (arguments
    [(string) (template_string)]
    @__call_body
    (_)?))
@fold

; describe.each(...)(name, fn)
(call_expression
  function: (call_expression
    function: (member_expression
      object: (identifier) @fn (#match? @fn "^(describe|context)$")
      property: (property_identifier) @each (#eq? @each "each"))
    arguments: (arguments))
  arguments: (arguments
    [(string) (template_string)]
    @__call_body
    (_)?))
@fold


; ============================================================
; it / test / specify
; ============================================================

; it('name', fn) / test('name', fn) / specify('name', fn)
(call_expression
  function: (identifier) @fn (#match? @fn "^(it|test|specify)$")
  arguments: (arguments
    [(string) (template_string)]
    @__call_body
    (_)?))
@fold

; it|test|specify.only/skip/todo('name', fn)
(call_expression
  function: (member_expression
    object: (identifier) @fn (#match? @fn "^(it|test|specify)$")
    property: (property_identifier) @mod (#match? @mod "^(only|skip|todo)$"))
  arguments: (arguments
    [(string) (template_string)]
    @__call_body
    (_)?))
@fold

; it|test|specify.each(...)(name, fn)
(call_expression
  function: (call_expression
    function: (member_expression
      object: (identifier) @fn (#match? @fn "^(it|test|specify)$")
      property: (property_identifier) @each (#eq? @each "each"))
    arguments: (arguments))
  arguments: (arguments
    [(string) (template_string)]
    @__call_body
    (_)?))
@fold
