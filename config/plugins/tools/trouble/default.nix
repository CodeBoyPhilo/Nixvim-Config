{
  plugins = {
    trouble = {
      enable = true;
      settings = {
        auto_close = true;
        modes = {
          preview_split = {
            # NOTE: can automatically open when diagnostics exist
            # auto_open = true;
            mode = "diagnostics";
            preview = {
              type = "split";
              relative = "win";
              position = "right";
              size = 0.5;
            };
          };

          symbols = {
            mode = "lsp_document_symbols";
            focus = false;
            win = {
              position = "right";
            };
            filter.__raw = ''
              function(items)
                if not items then
                  return {}
                end

                local allowed_kinds = {
                  Class = true,
                  Constructor = true,
                  Enum = true,
                  Field = true,
                  Function = true,
                  Interface = true,
                  Method = true,
                  Module = true,
                  Namespace = true,
                  Package = true,
                  Property = true,
                  Struct = true,
                  Trait = true,
                }

                local filtered = {}
                local seen = {}

                for _, item in ipairs(items) do
                  local keep = true
                  local kind = item.kind or (item.item and item.item.kind)
                  local ft = nil

                  if item.buf and vim.api.nvim_buf_is_valid(item.buf) and vim.api.nvim_buf_is_loaded(item.buf) then
                    ft = vim.bo[item.buf].filetype
                  end

                  if not ft and item.filename then
                    ft = vim.filetype.match({ filename = item.filename }) or ft
                  end

                  if ft == "lua" and kind == "Package" then
                    keep = false
                  elseif ft ~= "help" and ft ~= "markdown" then
                    if kind then
                      keep = allowed_kinds[kind] or false
                    end
                  end

                  if keep then
                    local id = item.id
                    if not id then
                      local pos = item.pos or {}
                      local end_pos = item.end_pos or {}
                      local parts = {
                        item.source or "",
                        item.filename or "",
                        tostring(pos[1] or ""),
                        tostring(pos[2] or ""),
                        tostring(end_pos[1] or ""),
                        tostring(end_pos[2] or ""),
                        kind or "",
                      }
                      local name = (item.item and item.item.symbol and item.item.symbol.name)
                        or (item.item and item.item.text)
                        or ""
                      parts[#parts + 1] = name
                      for i, part in ipairs(parts) do
                        parts[i] = tostring(part)
                      end
                      id = table.concat(parts, "|")
                      item.id = id
                    end

                    if not seen[id] then
                      seen[id] = true
                      filtered[#filtered + 1] = item
                    end
                  end
                end

                return filtered
              end
            '';
          };
        };
      };
    };

    which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>x";
        mode = "n";
        icon = "";
        group = "Trouble";
      }
    ];
  };

  plugins.lualine = {
    settings = {
      options = {
        disabled_filetypes = [
          "trouble"
        ];
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>xx";
      action = "<cmd>Trouble preview_split toggle<cr>";
      options = {
        desc = "Diagnostics toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>xX";
      action = "<cmd>Trouble preview_split toggle filter.buf=0<cr>";
      options = {
        desc = "Buffer Diagnostics toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>us";
      action = "<cmd>Trouble symbols toggle focus=false<cr>";
      options = {
        desc = "Symbols toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>xl";
      action = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>";
      options = {
        desc = "LSP Definitions / references / ... toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>xL";
      action = "<cmd>Trouble loclist toggle<cr>";
      options = {
        desc = "Location List toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>xQ";
      action = "<cmd>Trouble qflist toggle<cr>";
      options = {
        desc = "Quickfix List toggle";
      };
    }
  ];
}
