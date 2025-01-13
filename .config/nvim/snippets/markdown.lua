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


local rec_uls
rec_uls = function()
  return sn(nil, {
    c(1, {
      t({ "" }),
      sn(nil, { t({ "", "- " }), i(1), d(2, rec_uls, {}) }),
    }),
  });
end


return {
  s({ trig = "#(%d)", regTrig = true },
    f(function(args, snip)
      return string.rep("#", snip.captures[1], "") .. " "
    end, {})
  ),
  s("i", { t("*"), i(1), t("*"), }),
  s("b", { t("**"), i(1), t("**"), }),
  s("c", { t("`"), i(1), t("`"), }),
  s("bi", { t("***"), i(1), t("***"), }),
  s("url", { t("["), i(1), t("]("), i(2), t(")") }),
  s("urlt", { t("["), i(1), t("]("), i(2), t('"'), i(3), t('")') }),
  s("img", { t("!["), i(1), t("]("), i(2), t(")") }),
  -- math
  s({ trig = "\\eq", snippetType = "autosnippet" }, t("\\equiv")),
  s({ trig = "\\sp", snippetType = "autosnippet" }, t("\\space")),
  s({ trig = "\\qm", snippetType = "autosnippet" }, t("\\qmod")),
  s({ trig = "\\Ra", snippetType = "autosnippet" }, t("\\Rightarrow")),
  s(
    { trig = "\\bi", snippetType = "autosnippet" },
    fmta(
      [[\binom{<>}{<>}]],
      { i(1), i(2) },
      {}
    )
  ),
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
      { i(1), i(2), i(3), i(4, "x") },
      {}
    )
  ),
  s(
    { trig = "\\sum", snippetType = "autosnippet" },
    fmta(
      [[\sum\limits_{<>}^{<>}]],
      { i(1), i(2) },
      {}
    )
  ),

  s({ trig = "fml", snippetType = "autosnippet" }, c(1, {
    sn(nil, { t("$"), i(1), t("$") }),
    sn(nil, { t("$$"), i(1), t("$$") }),
  })),

  s({ trig = "\\te", snippetType = "autosnippet" },
    { t("\\text{"), i(1), t("}") }
  ),

  s("uls", {
    t("- "), i(1), d(2, rec_uls, {}),
  }),
}
