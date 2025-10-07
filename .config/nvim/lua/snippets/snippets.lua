local collection = require 'luasnip.session.snippet_collection'
collection.clear_snippets 'all'
collection.clear_snippets 'typescript'
collection.clear_snippets 'scss'
collection.clear_snippets 'htmlangular'
collection.clear_snippets 'lua'

local ls = require 'luasnip'

local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local t = ls.text_node
local extras = require 'luasnip.extras'
local rep = extras.rep

local fmt = require('luasnip.extras.fmt').fmt
local fmta = require('luasnip.extras.fmt').fmta

ls.add_snippets('all', {
  s(
    'selected_text',
    f(function(_, snip)
      local res, env = {}, snip.env
      table.insert(res, 'Selected Text (current line is ' .. env.TM_LINE_NUMBER .. '):')
      for _, ele in ipairs(env.LS_SELECT_RAW) do
        table.insert(res, ele)
      end
      return res
    end, {})
  ),
})

-- TYPESCRIPT

ls.add_snippets('typescript', {
  s(
    { trig = 'itshould', name = 'Jest it test', desc = 'Can be async or not' },
    fmta(
      [[
      it('<should><text>',<async> () =>> {
        <content>
      });<finish>
      ]],
      {
        should = c(1, { t('should ', t '') }),
        text = i(2),
        async = c(3, { t '', t ' async' }),
        content = i(4),
        finish = i(0),
      }
    )
  ),
  s(
    { trig = 'describe', name = 'Jest spec describe' },
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
          for _, ele in ipairs(env.LS_SELECT_DEDENT) do
            table.insert(res, ele)
          end
          return res
        end, {}),
        finish = i(0),
      }
    )
  ),
  s(
    { trig = 'beforeafter', name = 'Before or After spec' },
    fmta(
      [[
      <bef>Each(<async>() =>> {
        <finish>
      });
      ]],
      {
        bef = c(1, { t 'before', t 'after' }),
        async = c(2, { t '', t 'async ' }),
        finish = i(0),
      }
    )
  ),
  s(
    { trig = 'expect', name = 'Jest Expectation' },
    fmta(
      [[
      expect(<await><actual>)<negation>.to<expectation>(<expected>);<finish>
      ]],
      {
        await = c(1, { t '', t 'await ' }),
        actual = i(2),
        negation = c(3, { t '', t '.not' }),
        expectation = i(4),
        expected = i(5),
        finish = i(0),
      }
    )
  ),
  s(
    { trig = 'mockapollo', name = 'Mocked Query response' },
    fmta(
      [[
      const <name>: ApolloQueryResult<<<type>>> = {
        data: {
          <query>: {
            <content>
          }
        }
      } as ApolloQueryResult<<<typerepeat>>>;<finish>
      ]],
      {
        name = i(1),
        type = i(2),
        query = i(3),
        content = i(4),
        typerepeat = rep(2),
        finish = i(0),
      }
    )
  ),
  s(
    { trig = 'imp', name = 'Import statement' },
    fmt(
      [[
      import {{ {} }} from '{}';
      ]],
      {
        i(2),
        i(1),
      }
    )
  ),
  s(
    { trig = 'if', name = 'If statement' },
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
          for _, ele in ipairs(env.LS_SELECT_DEDENT) do
            table.insert(res, ele)
          end
          return res
        end, {}),
        finish = i(0),
      }
    )
  ),
  s(
    { trig = 'consolelog', name = 'Console Log' },
    fmta(
      [[
      console.log('<legend>', <what>)<finish>
      ]],
      {
        legend = i(1),
        what = i(2),
        finish = c(3, { t ';', t '' }),
      }
    )
  ),
  s(
    { trig = 'doc', desc = 'JS Doc' },
    fmt(
      [[
      /**
       * {}
       *
       */
      ]],
      {
        i(1, '@ignore'),
      }
    )
  ),
  s(
    { trig = 'gqltype', name = 'GraphQL Type or Input' },
    fmta(
      [[
      <inputOrType> <name> {
        <finish>
      }
      ]],
      {
        inputOrType = c(1, { t 'type', t 'input' }),
        name = i(2),
        finish = i(0),
      }
    )
  ),
  s(
    { trig = 'gqltsfile', name = 'Typescript GQL file boilerplate' },
    fmta(
      [[
      import { gql } from 'graphql-modules';

      export default gql`
        <finish>
      `;
      ]],
      {
        finish = i(0),
      }
    )
  ),
  -- s(
  --   { trig="componenttest", name="Component test boilerplate" },
  --   fmta(
  --     [[
  --     import { createComponentFactory, Spectator } from '@ngneat/spectator/jest';

  --     describe('<component>', () => {
  --       let spectator: Spectator<<<spectator>>>;

  --       const createComponent = createComponentFactory({
  --         component: <factory>,
  --       });

  --       beforeEach(() => {
  --         spectator = createComponent();
  --       });

  --       it('should create', () => {
  --         expect(spectator).toBeTruthy();
  --       })
  --     });
  --     ]],
  --     {
  --       component = i(1),
  --       spectator = rep(1),
  --       factory = rep(1),
  --     }
  --   )
  -- ),
})

-- LUA

ls.add_snippets('lua', {
  s(
    { trig = 'snipfmt', name = 'FMT Snippet' },
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
        type = c(3, { t 'fmta', t 'fmt' }),
        template = i(4),
        variables = i(5),
      }
    )
  ),
})

-- SCSS

ls.add_snippets('scss', {
  s(
    { trig = 'len', name = 'Blueweb length mixin' },
    fmt(
      [[
      bwc.bwc-layout--bs-grd({}){}
      ]],
      {
        i(1, '2'),
        i(0),
      }
    )
  ),
  s(
    { trig = 'med', name = 'Media query mixin' },
    fmt(
      [[
      @include bwc.bwc-media--gt-{}() {{
        {}
      }}
      ]],
      {
        c(1, { t 'xs', t 'md' }),
        i(0),
      }
    )
  ),
  s(
    { trig = 'brand', name = 'Brand exception' },
    fmt(
      [[
      @include bwc.bwc-brand-exception-{}() {{
        {}
      }}
      ]],
      {
        c(1, { t 'af', t 'kl' }),
        i(0),
      }
    )
  ),
  s(
    { trig = 'color', name = 'Color from palette' },
    fmt(
      [[
      var(--bwc-palette-{}-{}){}
      ]],
      {
        i(1, ''),
        i(2),
        i(0),
      }
    )
  ),
  s({ trig = 'imp', name = 'Import Aviato Components' }, t "@use 'libs/aviato-components' as bwc;"),
})

-- HTML ANGULAR

ls.add_snippets('htmlangular', {
  s(
    { trig = 'tag', name = 'Wrap in tag' },
    fmt(
      [[
      <{}>
        {}
      </{}>
      ]],
      {
        i(1, 'div'),
        f(function(_, snip)
          local res, env = {}, snip.env
          for _, ele in ipairs(env.LS_SELECT_DEDENT) do
            table.insert(res, ele)
          end
          return res
        end, {}),
        rep(1),
      }
    )
  ),
  s(
    { trig = 'hbc', name = 'HTML big comment' },
    fmt(
      [[
      <!-- -*-*-*-*-*-*-*-*-*-*- {} -*-*-*-*-*-*-*-*-*-*- -->{}
      ]],
      {
        i(1),
        i(0),
      }
    )
  ),
  s(
    { trig = 'if', name = 'Angular If control flow' },
    fmta(
      [[
      @if (<condition>) {
        <content><finish>
      }
      ]],
      {
        condition = i(1),
        content = f(function(_, snip)
          local res, env = {}, snip.env
          for _, ele in ipairs(env.LS_SELECT_DEDENT) do
            table.insert(res, ele)
          end
          return res
        end, {}),
        finish = i(3),
      }
    )
  ),
  s(
    { trig = 'ifelse', name = 'Angular If Else control flow' },
    fmta(
      [[
      @if (<condition>) {
        <content>
      } @else {
        <finish>
      }
      ]],
      {
        condition = i(1),
        content = f(function(_, snip)
          local res, env = {}, snip.env
          for _, ele in ipairs(env.LS_SELECT_DEDENT) do
            table.insert(res, ele)
          end
          return res
        end, {}),
        finish = i(3),
      }
    )
  ),
  s(
    { trig = 'forminput', name = 'Blueweb Angular form input' },
    fmt(
      [[
      <bwc-form-input-container [isOutlined]="true">
        <mat-form-field outline-content>
          <input
            matInput
            formControlName="{1}"
            [placeholder]="'{2}' | transloco"
          />
          <mat-error>
            <bwc-form-errors [control]="{3}.get('{1}')">
              <bwc-form-error for="required">
                {{{{ '{4}' | transloco }}}}
              </bwc-form-error>
            </bwc-form-errors>
          </mat-error>
        </mat-form-field>
      </bwc-form-input-container>
      ]],
      {
        i(1),
        i(2),
        i(3),
        i(4),
      },
      { repeat_duplicates = true }
    )
  ),
  s(
    { trig = 'formselect', name = 'Blueweb Angular form select' },
    fmt(
      [[
      <bwc-form-input-container [isOutlined]="true">
        <bwc-form-select outline-content [control]="{1}.get('{2}')">
          <mat-form-field>
            <mat-select
              formControlName="{2}"
              [placeholder]="'{3}' | transloco"
            >
              @for ({4} of {5}; track {6}) {{
                <mat-option [value]="{7}">
                  <span>{8}</span>
                </mat-option>
              }}
            </mat-select>

            <mat-error>
              <bwc-form-errors [control]="{1}.get('{2}')">
                <bwc-form-error for="required">
                  {{{{ '{9}' | transloco }}}}
                </bwc-form-error>
              </bwc-form-errors>
            </mat-error>
          </mat-form-field>
        </bwc-form-select>
      </bwc-form-input-container>
      ]],
      {
        i(1),
        i(2),
        i(3),
        i(4),
        i(5),
        i(6),
        i(7),
        i(8),
        i(9),
      },
      { repeat_duplicates = true }
    )
  ),
  s(
    { trig = 'gridcol', name = 'Grid column class with screen size' },
    fmt(
      [[
      bwc-grid__col--{}--span-{}
      ]],
      {
        c(1, { t 'sm', t 'md', t 'lg' }),
        i(2),
      }
    )
  ),
})

-- GIT

ls.add_snippets('gitcommit', {
  s(
    { trig = 'com', name = 'Blueweb Commit' },
    fmt(
      [[
      {}({}): {}-{} {}
      ]],
      {
        i(1, 'feat'),
        i(2),
        i(3, 'BWDISCUSS'),
        i(4),
        i(5),
      }
    )
  ),
})
