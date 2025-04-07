return {
  "frankroeder/parrot.nvim",
  dependencies = { "ibhagwan/fzf-lua", "nvim-lua/plenary.nvim" },
  config = function()
    require("parrot").setup({
      providers = { anthropic = { api_key = os.getenv("ANTHROPIC_API_KEY") } },
      hooks = {
        File = function(parrot, params)
          local prompt = [[
        I have the following code from {{filename}}:

        ```{{filetype}}
        {{filecontent}}
        ```

        Please look at the following section specifically:
        ```{{filetype}}
        {{selection}}
        ```

        Please finish the code above carefully and logically.
        Respond just with the snippet of code that should be inserted.
        Do not reply with any explanation. 
        Just the code snippet.
        ]]

          local model_obj = parrot.get_model("command")
          parrot.Prompt(params, parrot.ui.Target.append, model_obj, nil, prompt)
        end,
      },
    })

    vim.keymap.set(
      { "n", "v" },
      "<leader>k",
      ":PrtFile<CR>",
      { desc = "Parrot cursor" }
    )
  end,
}
