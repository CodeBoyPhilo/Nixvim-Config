{
  plugins.opencode = {
    enable = false;
    settings = { };
  };

  # keymaps = [
  #   {
  #     mode = [
  #       "n"
  #       "x"
  #     ];
  #     key = "<leader>oo";
  #     action.__raw = ''function() require("opencode").ask("@this: ", { submit = true }) end'';
  #     options = {
  #       desc = "Ask opencode";
  #     };
  #   }
  #   {
  #     mode = [
  #       "n"
  #       "x"
  #     ];
  #     key = "<leader>ox";
  #     action.__raw = ''function() require("opencode").select() end'';
  #     options = {
  #       desc = "Execute opencode action…";
  #     };
  #   }
  #   {
  #     mode = [
  #       "n"
  #       "x"
  #     ];
  #     key = "<leader>oa";
  #     action.__raw = ''function() require("opencode").prompt("@this") end'';
  #     options = {
  #       desc = "Add to opencode";
  #     };
  #   }
  # ];
}
