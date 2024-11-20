local collection = require("luasnip.session.snippet_collection")
collection.clear_snippets "all"
collection.clear_snippets "typescript"
collection.clear_snippets "scss"
collection.clear_snippets "htmlangular"

local ls = require("luasnip");

local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local t = ls.text_node
local extras = require("luasnip.extras")
local rep = extras.rep

local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta

ls.add_snippets("all", {
  s("selected_text", f(function(_, snip)
    local res, env = {}, snip.env
    table.insert(res, "Selected Text (current line is " .. env.TM_LINE_NUMBER .. "):")
    for _, ele in ipairs(env.LS_SELECT_RAW) do table.insert(res, ele) end
    return res
  end, {}))
})

-- TYPESCRIPT

ls.add_snippets("typescript", {
  s(
    { trig="it", name="Jest it test" },
    fmta(
      [[
      it('<text>',<async> () =>> {
        <content>
      });<finish>
      ]],
      {
        text = i(1),
        async = c(
          2,
          { t(" async"), t("") }
        ),
        content = i(3),
        finish = i(0)
      }
    )
  ),
  s(
    { trig="desc", name="Jest spec describe" },
    fmta(
      [[
      describe('<text>', () =>> {
        <content><finish>
      });
      ]],
      {
        text = i(1),
        content = f(function(_, snip)
          local res, env = {}, snip.env
          for _, ele in ipairs(env.LS_SELECT_DEDENT) do table.insert(res, ele) end
          return res
        end, {}),
        finish = i(0)
      }
    )
  ),
  s(
    { trig="bef", name="Before or After spec" },
    fmta(
      [[
      <bef>Each(<async>() =>> {
        <async>
      });<finish>
      ]],
      {
        bef = c(1, { t("before"), t("after") }),
        async = c(2, { t(""), t("async ") }),
        finish = i(3)
      }
    )
  ),
  s(
    { trig="im", name="Import statement paf" },
    fmt(
      [[
      import {{ {} }} from '{}';
      ]],
      {
        i(2),
        i(1)
      }
    )
  ),
  s(
    { trig="if", name="If statement" },
    fmta(
      [[
      if (<condition>) {
        <visual><finish>
      }
      ]],
      {
        condition = i(1),
        visual = f(function(_, snip)
          local res, env = {}, snip.env
          for _, ele in ipairs(env.LS_SELECT_DEDENT) do table.insert(res, ele) end
          return res
        end, {}),
        finish = i(0)
      }
    )
  ),
  s(
    { trig="clo", name="Console Log" },
    fmta(
      [[
      console.<fn>('<legend>', <what>)<finish>
      ]],
      {
        fn = c(1, { t("log"), t("debug"), t("info"), t("error"), t("table") }),
        legend = i(2),
        what = i(3),
        finish = c(4, { t(";"), t("") })
      }
    )
  ),
  s(
    { trig="doc", desc="JS Doc" },
    fmt(
      [[
      /**
       * {}
       *
       */
      ]],
      {
        i(1, "@ignore")
      }
    )
  ),
})

-- LUA

ls.add_snippets("lua", {
  s(
    { trig="snipfmt", name="FMT Snippet" },
    fmta(
      [[
      s(
        { trig="<trigger>", name="<name>" },
        <type>(
          <template>,
          {
            <variables>
          }
        )
      ),
      ]],
      {
        trigger = i(1),
        name = i(2),
        type = c(3, { t("fmta", "fmt") }),
        template = i(4),
        variables = i(5)
      }
    )
  )
})

-- SCSS

ls.add_snippets("scss", {
  s(
    { trig="len", name="Blueweb length mixin"},
    fmt(
      [[
      bwc.bwc-layout--bs-grd({}){}
      ]],
      {
        i(1, "2"),
        i(0)
      }
    )
  ),
  s(
    { trig="med", name="Media query mixin" },
    fmt(
      [[
      @include bwc.bwc-media--gt-{}() {{
        {}
      }}
      ]],
      {
        c(1, { t("xs"), t("md") }),
        i(0)
      }
    )
  ),
  s(
    { trig="imp", name="Import Aviato Components" },
    t("@use 'libs/aviato-components' as bwc;")
  )
})

-- HTML ANGULAR

ls.add_snippets("htmlangular", {
  s(
    { trig="tag", name="Wrap in tag" },
    fmt(
      [[
      <{}>
        {}
      </{}>
      ]],
      {
        i(1, "div"),
        f(function(_, snip)
          local res, env = {}, snip.env
          for _, ele in ipairs(env.LS_SELECT_DEDENT) do table.insert(res, ele) end
          return res
        end, {}),
        rep(1)
      }
    )
  ),
  s(
    { trig="hbc", name="HTML big comment" },
    fmt(
      [[
      <!-- -*-*-*-*-*-*-*-*-*-*- {} -*-*-*-*-*-*-*-*-*-*- -->{}
      ]],
      {
        i(1),
        i(0)
      }
    )
  ),
})

-- GIT

ls.add_snippets("gitcommit", {
  s(
    { trig="com", name="Blueweb Commit" },
    fmt(
      [[
      {}({}): {}-{} {}
      ]],
      {
        i(1, "feat"),
        i(2),
        i(3, "BWDISCUSS"),
        i(4),
        i(5),
      }
    )
  ),
})
