local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")

return {
  s({ trig = "\\ap", snippetType = "autosnippet" }, t("\\alpha")),
  s({ trig = "\\bt", snippetType = "autosnippet" }, t("\\beta")),
  s({ trig = "\\omg", snippetType = "autosnippet" }, t("\\omega")),
  s(
    { trig = "\\fr", snippetType = "autosnippet" },
    fmta(
      [[\frac{<>}{<>}]],
      { i(1), i(2) },
      {}
    )
  ),
  s(
    { trig = "\\int", snippetType = "autosnippet" },
    fmta(
      [[\int_{<>}^{<>}<>{\rm d}<>]],
      { i(1), i(2), i(3), i(4, "x")},
      {}
    )
  ),
  s(
    { trig = "\\sum", snippetType = "autosnippet" },
    fmta(
      [[\sum{<>}^{<>}]],
      { i(1), i(2)},
      {}
    )
  ),
}
