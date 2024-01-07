return {
  "L3MON4D3/LuaSnip",
  build = "make install_jsregexp",
  opts = {
    history = true,
  },
  config = function()
    -- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    local f = ls.function_node

    local filename = function(_, snip)
      return snip.env.TM_FILENAME_BASE
    end

    ls.add_snippets("all", {
      s("v", { t("const ") }),
      s("cs", { t("console.log("), i(1), t(")") }),
      s("rc", {
        t({
          "import { ReactElement, ReactNode } from 'react'",
          "import styled from 'styled-components'",
          "",
          "const Styles = styled.div`",
          "  position: relative;",
          "`",
          "interface Props {",
          "  children?: ReactNode",
          "}",
          "export default function ",
        }),
        f(filename),
        t({
          "(props: Props): ReactElement {",
          "  const { children } = props",
          "",
          "  return <Styles>{children}</Styles>",
          "}",
        }),
      }),
      s("pr", {
        t({
          "const fakeAwait = async (): Promise<boolean> => {",
          "  const res: boolean = await new Promise((resolve) => {",
          "    setTimeout(() => resolve(true), 1000)",
          "  })",
          "  return res",
          "}",
        }),
      }),
    })
  end,
}
