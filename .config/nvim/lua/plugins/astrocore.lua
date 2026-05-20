-- ~/.config/nvim/lua/user/plugins/astrocore.lua
-- Or wherever your astrocore customization is located

return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      features = {
        large_buf = { size = 1024 * 256, lines = 10000 }, -- Handle large files better
        autopairs = true, -- Auto-close pairs like (), [], {}
        cmp = true, -- Enable completion engine
        diagnostics_mode = 3, -- Show diagnostics aggressively (vim.diagnostic.config({ virtual_text = true }))
        highlighturl = true, -- Highlight URLs
        notifications = true, -- Enable notifications
      },
      diagnostics = {
        virtual_text = true, -- Show diagnostics inline
        underline = true,
      },
      options = {
        opt = {
          relativenumber = true, -- Show relative line numbers
          number = true, -- Show the absolute line number for the current line
          spell = false, -- Disable spell checking
          signcolumn = "yes", -- Always show the sign column
          wrap = false, -- Disable line wrapping
          mouse = "a", -- Enable mouse support in all modes
        },
        g = {
          -- Optional: You can add global variables here if needed
        },
      },
      mappings = {
        -- Normal Mode Mappings
        n = {

          -- GAMIFIED PLUGIN MAPPINGS

          -- Show Game Stats

          ["<Leader>ts"] = {
            function() require("triforce").show_profile() end,
            desc = "Show triforce profile",
          },

          ["<Leader>trs"] = {
            function() require("triforce").reset_stats() end,
            desc = "Reset triforce stats",
          },

          ["<Leader>tS"] = {
            function() require("triforce").save_stats() end,
            desc = "Save triforce stats",
          },

          -- Save file with Cmd+S (useful on macOS)
          ["<D-s>"] = {
            function()
              vim.cmd "silent write"
              vim.notify("💾 Saved", vim.log.levels.INFO, { title = "AstroNvim" })
            end,
            desc = "Save file",
          },

          -- Copy entire buffer to system clipboard
          ["cp"] = {
            function()
              local curpos = vim.api.nvim_win_get_cursor(0) -- Save cursor position
              local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false) -- Get all lines
              vim.fn.setreg("+", table.concat(lines, "\n")) -- Set system clipboard
              vim.api.nvim_win_set_cursor(0, curpos) -- Restore cursor position
              vim.notify("📋 Buffer copied to system clipboard", vim.log.levels.INFO, { title = "AstroNvim" })
            end,
            desc = "Copy entire buffer to clipboard",
          },

          -- Paste system clipboard content, replacing buffer, trying to preserve cursor line
          ["pst"] = {
            function()
              local curpos = vim.api.nvim_win_get_cursor(0) -- Save cursor position
              local clip = vim.fn.getreg "+" -- Get system clipboard content
              local lines = vim.split(clip, "\n") -- Split into lines
              vim.api.nvim_buf_set_lines(0, 0, -1, false, lines) -- Replace buffer content
              -- Try to restore cursor to the same line number, capped by new buffer size
              vim.api.nvim_win_set_cursor(0, { math.min(curpos[1], #lines), 0 })
              vim.notify("📥 Clipboard pasted into buffer", vim.log.levels.INFO, { title = "AstroNvim" })
            end,
            desc = "Paste clipboard contents into buffer",
          },

          -- Buffer navigation
          ["<Tab>"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
          ["<S-Tab>"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
          ["<Leader>x"] = {
            function() require("astrocore.buffer").close(vim.fn.bufnr()) end,
            desc = "Close current buffer",
          },

          -- C++ Compile & Run with input/output files
          ["<F5>"] = {
            function()
              vim.cmd "silent write"
              local src = vim.fn.expand "%:p"
              local dir = vim.fn.expand "%:p:h"
              local is_windows = vim.fn.has "win32" == 1
              local exe = vim.fn.expand "%:p:r" .. (is_windows and ".exe" or "")
              local input = dir .. "/input.txt"
              local output = dir .. "/output.txt"
              local err = dir .. "/compile_errors.txt"

              -- Create input.txt if it doesn't exist
              if vim.fn.filereadable(input) == 0 then
                vim.fn.writefile({ "# Add input values below", "# Example:", "# 5", "# 10" }, input)
                vim.notify("Created input.txt with example", vim.log.levels.INFO, { title = "C++ Run" })
              end

              -- Define compile and run commands
              local compile_cmd = string.format(
                "g++ -std=c++17 -O2 -Wall -Wextra %s -o %s",
                vim.fn.shellescape(src),
                vim.fn.shellescape(exe)
              )
              local run_cmd = string.format(
                "%s < %s > %s 2>&1",
                vim.fn.shellescape(exe),
                vim.fn.shellescape(input),
                vim.fn.shellescape(output)
              )
              local error_redir_compile = "2> " .. vim.fn.shellescape(err)

              -- Construct the full shell command sequence
              local full_cmd
              if is_windows then
                full_cmd = string.format(
                  "cd /d %s && %s %s && %s",
                  vim.fn.shellescape(dir),
                  compile_cmd,
                  error_redir_compile,
                  run_cmd
                )
              else
                full_cmd = string.format(
                  "cd %s && %s %s && %s",
                  vim.fn.shellescape(dir),
                  compile_cmd,
                  error_redir_compile,
                  run_cmd
                )
              end

              vim.notify("🚀 Compiling & Running C++...", vim.log.levels.INFO, { title = "C++ Run" })

              -- Run using plenary.job
              require("plenary.job")
                :new({
                  command = is_windows and "cmd.exe" or "bash",
                  args = is_windows and { "/c", full_cmd } or { "-c", full_cmd },
                  on_exit = function(_, code)
                    if code == 0 then
                      vim.notify(
                        "✅ C++ Executed successfully. Output in output.txt",
                        vim.log.levels.INFO,
                        { title = "C++ Run" }
                      )
                      -- Optional: open output.txt automatically
                      -- local output_file = vim.fn.expand("%:p:h") .. "/output.txt"
                      -- if vim.fn.filereadable(output_file) == 1 then vim.cmd("vsplit " .. vim.fn.fnameescape(output_file)) end
                    else
                      vim.notify(
                        "❌ C++ Compilation/Runtime Error. See compile_errors.txt",
                        vim.log.levels.ERROR,
                        { title = "C++ Run" }
                      )
                      -- Optional: open compile_errors.txt automatically on failure
                      local error_file = vim.fn.expand "%:p:h" .. "/compile_errors.txt"
                      if vim.fn.filereadable(error_file) == 1 then
                        vim.cmd("vsplit " .. vim.fn.fnameescape(error_file))
                      end
                    end
                  end,
                })
                :start()
            end,
            desc = "Compile & Run C++ (using input.txt/output.txt)",
          },

          -- Run Python file with Ctrl+Enter using input.txt and outputting to output.txt
          -- *** MODIFIED to use plenary.job's stream options to avoid shell redirection issues ***
          ["<C-CR>"] = {
            function()
              vim.cmd "silent write" -- Save the file first
              local current_file = vim.fn.expand "%:p"
              local dir = vim.fn.expand "%:p:h" -- Get the directory of the current file
              local input_file = dir .. "/input.txt" -- Define the input file path
              local output_file = dir .. "/output.txt" -- Define the output file path

              if vim.fn.filereadable(current_file) == 0 then
                vim.notify("Cannot run unsaved or non-existent file", vim.log.levels.WARN, { title = "Python Run" })
                return
              end
              if vim.bo.filetype ~= "python" then
                vim.notify(
                  "Not a Python file (" .. vim.bo.filetype .. ")",
                  vim.log.levels.WARN,
                  { title = "Python Run" }
                )
                return
              end

              -- Create input.txt if it doesn't exist
              if vim.fn.filereadable(input_file) == 0 then
                vim.fn.writefile({ "# Add input values below", "# Example:", "# 5", "# 10" }, input_file)
                vim.notify("Created input.txt with example", vim.log.levels.INFO, { title = "Python Run" })
              end

              local file_path_escaped = vim.fn.fnameescape(current_file) -- Use fnameescape for file arguments
              local input_file_escaped = vim.fn.fnameescape(input_file)
              local output_file_escaped = vim.fn.fnameescape(output_file)
              -- Note: Using fnameescape for paths passed as arguments or stream connections

              local python_executable = "python3" -- Use "python" if python3 is not your command

              vim.notify(
                "🐍 Running " .. vim.fn.pathshorten(current_file) .. " using input.txt. Output will be in output.txt",
                vim.log.levels.INFO,
                { title = "Python Run" }
              )

              -- *** NEW APPROACH using plenary.job stream options ***
              -- We launch the python interpreter directly with the script file as an argument.
              -- We explicitly tell plenary.job to connect stdin, stdout, stderr to files.
              require("plenary.job")
                :new({
                  command = python_executable, -- The executable itself
                  args = { file_path_escaped }, -- Pass the script file path as an argument
                  cwd = dir, -- Set working directory to the script's directory
                  stdin = input_file_escaped, -- Connect stdin to input.txt
                  stdout = output_file_escaped, -- Connect stdout to output.txt
                  stderr = output_file_escaped, -- Connect stderr to output.txt (append errors to output file)
                  on_exit = function(job, code)
                    if code == 0 then
                      vim.notify(
                        "✅ Python script finished successfully. Output in output.txt",
                        vim.log.levels.INFO,
                        { title = "Python Run" }
                      )
                      -- Optional: Uncomment the line below to automatically open output.txt on success
                      -- if vim.fn.filereadable(output_file) == 1 then vim.cmd("split " .. vim.fn.fnameescape(output_file)) end
                    else
                      vim.notify(
                        "❌ Python script failed with code: " .. code .. ". Check output.txt for errors.",
                        vim.log.levels.ERROR,
                        { title = "Python Run" }
                      )
                      -- Optional: Uncomment the line below to automatically open output.txt on failure to see errors
                      -- if vim.fn.filereadable(output_file) == 1 then vim.cmd("split " .. vim.fn.fnameescape(output_file)) end
                    end
                  end,
                })
                :start()
              -- *** END NEW APPROACH ***
            end,
            desc = "Run current Python file (Ctrl+Enter), input from input.txt, output to output.txt",
          },

          -- View C++ output/error files
          ["<Leader>vo"] = {
            function()
              local file = vim.fn.expand "%:p:h" .. "/output.txt"
              if vim.fn.filereadable(file) == 1 then
                vim.cmd("vsplit " .. vim.fn.fnameescape(file))
              else
                vim.notify("output.txt not found", vim.log.levels.WARN, { title = "C++ View" })
              end
            end,
            desc = "View C++ output.txt",
          },
          ["<Leader>ve"] = {
            function()
              local file = vim.fn.expand "%:p:h" .. "/compile_errors.txt"
              if vim.fn.filereadable(file) == 1 then
                vim.cmd("vsplit " .. vim.fn.fnameescape(file))
              else
                vim.notify("compile_errors.txt not found", vim.log.levels.WARN, { title = "C++ View" })
              end
            end,
            desc = "View C++ compile_errors.txt",
          },
          -- View Python output file
          ["<Leader>vp"] = {
            function()
              local file = vim.fn.expand "%:p:h" .. "/output.txt"
              if vim.fn.filereadable(file) == 1 then
                vim.cmd("vsplit " .. vim.fn.fnameescape(file))
              else
                vim.notify("output.txt not found for Python", vim.log.levels.WARN, { title = "Python View" })
              end
            end,
            desc = "View Python output.txt",
          },
          -- View Python input file
          ["<Leader>vi"] = {
            function()
              local file = vim.fn.expand "%:p:h" .. "/input.txt"
              if vim.fn.filereadable(file) == 1 then
                vim.cmd("split " .. vim.fn.fnameescape(file)) -- Use split to open in a horizontal window
              else
                vim.notify("input.txt not found for Python", vim.log.levels.WARN, { title = "Python View" })
              end
            end,
            desc = "View Python input.txt",
          },

          -- Add other normal mode mappings here
        },

        -- Insert Mode Mappings
        i = {
          -- Save file without exiting insert mode
          ["<C-s>"] = {
            function()
              vim.cmd "silent write"
              vim.notify("💾 Saved", vim.log.levels.INFO, { title = "AstroNvim" })
            end,
            desc = "Save file (Insert Mode)",
          },

          -- macOS style word skipping (Option/Alt + Arrow)
          ["<A-Left>"] = { "<C-o>b", desc = "Move word left" }, -- Use C-o to execute one normal command (b)
          ["<A-Right>"] = { "<C-o>w", desc = "Move word right" }, -- Use C-o to execute one normal command (w)

          -- Move line up/down (Option/Alt + Up/Down)
          ["<A-Up>"] = { "<Esc>:m .-2<CR>==gi", desc = "Move line up" }, -- More robust way to move line up
          ["<A-Down>"] = { "<Esc>:m .+1<CR>==gi", desc = "Move line down" }, -- More robust way to move line down

          -- Standard Emacs-like bindings for start/end of line
          ["<C-e>"] = { "<End>", desc = "Move to end of line" },
          ["<C-a>"] = { "<Home>", desc = "Move to start of line" },

          -- Add other insert mode mappings here
          vim.keymap.set("t", "jk", [[<C-\><C-n>]], { noremap = true, silent = true }),
        },

        -- Visual Mode Mappings
        -- v = {
        -- Add visual mode mappings here
        -- },

        -- Terminal Mode Mappings
        -- t = {
        -- Add terminal mode mappings here
        -- },
      },
    },
  },
}
