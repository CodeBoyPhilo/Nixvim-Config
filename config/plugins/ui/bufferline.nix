{
  plugins.bufferline = {
    enable = true;
    settings = {
      highlights = {
        fill = {
          # bg = "#1e1e2e"; # uncomment for catppuccin
          bg = "#1a1b26"; # uncomment for tokyonight
        };
      };
      options = {
        themable = false;
        mode = "tabs";
        indicator = {
          style = "icon";
          icon = "▎";
        };
        separator_style = [
          ""
          ""
        ];
        buffer_close_icon = "";
        modified_icon = "●";
        close_icon = "";
        left_trunc_marker = "";
        right_trunc_marker = "";
        max_name_length = 20;
        max_prefix_length = 15;
        tab_size = 22;
        show_buffer_close_icons = true;
        show_close_icon = true;
        always_show_bufferline = true;
      };
    };
  };
}
