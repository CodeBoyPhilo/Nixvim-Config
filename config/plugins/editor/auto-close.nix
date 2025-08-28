{
  plugins.autoclose = {
    enable = true;
    settings = {
      keys = {
        "$" = {
          escape = true;
          close = true;
          pair = "$$";
          disabled_filetypes = [ ];
        };
        "'" = {
          escape = false;
          close = true;
          pair = "''";
          disabled_filetypes = [ ];
        };
        "\"" = {
          escape = false;
          close = true;
          pair = ''""'';
          disabled_filetypes = [ ];
        };
        "`" = {
          escape = false;
          close = true;
          pair = "``";
          disabled_filetypes = [ ];
        };
        "<" = {
          escape = true;
          close = true;
          pair = "<>";
          disabled_filetypes = [ ];
        };
      };
    };
  };
}
