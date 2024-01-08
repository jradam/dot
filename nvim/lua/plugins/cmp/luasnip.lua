return {
  "L3MON4D3/LuaSnip",
  build = "make install_jsregexp",
  config = function()
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    local f = ls.function_node

    local filename = function(_, snip)
      return snip.env.TM_FILENAME_BASE
    end

    ls.add_snippets("all", {
      s("cs", { t("console.log("), i(1), t(")") }),
      s("rc", {
        t({
          "import { ReactElement, ReactNode } from 'react'",
          "",
          "type Props = {",
          "  children?: ReactNode",
          "}",
          "export default function ",
        }),
        f(filename),
        t({
          "(props: Props): ReactElement {",
          "  const { children } = props",
          "",
          "  return <div>{children}</div>",
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
