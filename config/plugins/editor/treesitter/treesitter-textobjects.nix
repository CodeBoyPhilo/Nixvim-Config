{
  plugins.treesitter-textobjects = {
    enable = true;
    settings = {
      select = {
        enable = true;
        lookahead = true;
        keymaps = [
          { mode = "n"; key = "aa"; query = "@parameter.outer"; }
          { mode = "n"; key = "ia"; query = "@parameter.inner"; }
          { mode = "n"; key = "af"; query = "@function.outer"; }
          { mode = "n"; key = "if"; query = "@function.inner"; }
          { mode = "n"; key = "ac"; query = "@class.outer"; }
          { mode = "n"; key = "ic"; query = "@class.inner"; }
          { mode = "n"; key = "ii"; query = "@conditional.inner"; }
          { mode = "n"; key = "ai"; query = "@conditional.outer"; }
          { mode = "n"; key = "il"; query = "@loop.inner"; }
          { mode = "n"; key = "al"; query = "@loop.outer"; }
          { mode = "n"; key = "at"; query = "@comment.outer"; }
        ];
      };
      move = {
        enable = true;
        goto_next_start = [
          { key = "]m"; query = "@function.outer"; }
          { key = "]]"; query = "@class.outer"; }
        ];
        goto_next_end = [
          { key = "]M"; query = "@function.outer"; }
          { key = "]["; query = "@class.outer"; }
        ];
        goto_previous_start = [
          { key = "[m"; query = "@function.outer"; }
          { key = "[["; query = "@class.outer"; }
        ];
        goto_previous_end = [
          { key = "[M"; query = "@function.outer"; }
          { key = "[]"; query = "@class.outer"; }
        ];
      };
    };
  };
}
