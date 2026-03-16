{
  plugins.render-markdown = {
    enable = true;
    settings = {
      file_types = [
        "markdown"
        "quarto"
        "Avante"
      ];
      completions = {
        blink = {
          enabled = true;
        };
      };
      html = {
        tag = {
          s = {
            scope_highlight = "@markup.strikethrough";
          };
          del = {
            scope_highlight = "@markup.strikethrough";
          };
          strike = {
            scope_highlight = "@markup.strikethrough";
          };
        };
      };
    };
  };
}
