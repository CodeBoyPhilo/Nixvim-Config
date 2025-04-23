{
  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        section_separators = {
          left = "";
          right = "";
        };
        component_separators = {
          left = "";
          right = "";
        };
      };
      sections = {
        lualine_c = [
          {
            __unkeyed-1 = "filename";
            color = {
              bg = "#1a1b26";
            };
          }
        ];
        lualine_x = [
          {
            __unkeyed-1 = "encoding";
            color = {
              bg = "#1a1b26";
            };
          }
          {
            __unkeyed-1 = "fileformat";
            color = {
              bg = "#1a1b26";
            };
          }
          {
            __unkeyed-1 = "filetype";
            color = {
              bg = "#1a1b26";
            };
            icons_enabled = true;
          }
        ];
      };
    };
  };
}
