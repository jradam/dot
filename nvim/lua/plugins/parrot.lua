return {
  "frankroeder/parrot.nvim",
  dependencies = { "ibhagwan/fzf-lua", "nvim-lua/plenary.nvim" },
  config = function()
    local chat_active = false

    local function activate_chat()
      vim.schedule(function()
        vim.cmd("startinsert")
        vim.cmd("normal G$")
        vim.api.nvim_feedkeys(" ", "i", false) -- Add space after prompt

        vim.keymap.set("i", "<CR>", function()
          vim.cmd("PrtChatRespond")
          vim.schedule(activate_chat) -- Re-activate chat after response
        end, { buffer = 0 })

        vim.keymap.set("i", "<ESC>", function() -- Esc close chat buffer
          local buf = vim.api.nvim_get_current_buf()
          vim.cmd("wq")
          vim.cmd("stopinsert")
          vim.schedule(
            function() vim.api.nvim_buf_delete(buf, { force = true }) end
          )
        end, { buffer = 0 })
      end)
    end

    require("parrot").setup({
      providers = { anthropic = { api_key = os.getenv("ANTHROPIC_API_KEY") } },
      toggle_target = "popup",
      style_popup_max_width = 100,
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
        FilePopup = function(parrot, params)
          local prompt = [[
        Be concise! Don't copy out my code, just provide the code of the solution. Let's talk about this file: {{filename}}
        ```{{filetype}}
        {{filecontent}}
        ```
        ]]

          if chat_active then
            vim.cmd("PrtChatToggle")
            activate_chat()
          else
            parrot.ChatNew(params, prompt)
            chat_active = true
            activate_chat()
          end
        end,
      },
    })

    local k = vim.keymap.set
    -- k( "n", "<leader>k", ":PrtFilePopup<CR>", { desc = "Parrot popup" })
    k({ "n", "v" }, "<leader>k", ":PrtFile<CR>", { desc = "Parrot cursor" })
    -- TODO: for some reason this .parrot.md context is not available to ChatNew?
    -- k(
    --   "n",
    --   "<leader>p",
    --   ":!npx ai-digest --output .parrot.md<CR>",
    --   { desc = "Add context" }
    -- )
    k("v", "<leader>i", ":PrtImplement<CR>", { desc = "Parrot implement" })
    k("v", "<leader>j", ":PrtRewrite<CR>", { desc = "Parrot rewrite" })
  end,
}
