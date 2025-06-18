return {
  "L3MON4D3/LuaSnip",
  config = function()
    local ls = require("luasnip")
    local snip = ls.snippet
    local text = ls.text_node
    local insert = ls.insert_node
    local fn = ls.function_node

    local filename = function(_, snippet) return snippet.env.TM_FILENAME_BASE end

    local js_types =
    { "javascript", "typescript", "javascriptreact", "typescriptreact" }

    local js_snippets = {
      snip("c", { text('className="'), insert(1), text('"') }),
      snip("cn", { text("className={cn('"), insert(1), text("')}") }),
      snip("cs", { text("console.log("), insert(1), text(")") }),
      snip("rc", {
        text({
          "import { ReactElement, ReactNode } from 'react'",
          "",
          "type Props = {",
          "  children?: ReactNode",
          "}",
          "export default function ",
        }),
        fn(filename),
        text({
          "(props: Props): ReactElement {",
          "  const { children } = props",
          "",
          "  return <div>{children}</div>",
          "}",
        }),
      }),
      snip("fa", {
        text({
          "const fakeAwait = async (): Promise<boolean> => {",
          "  const res: boolean = await new Promise((resolve) => {",
          "    setTimeout(() => resolve(true), 1000)",
          "  })",
          "  return res",
          "}",
        }),
      }),
      snip(
        "fl",
        { text("for (let i = 0; i < "), insert(1), text("; i++) { "), insert(2), text(" }") }
      ),
    }

    for _, value in pairs(js_types) do
      ls.add_snippets(value, js_snippets)
    end
  end,
}
