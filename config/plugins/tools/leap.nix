{
  plugins.leap = {
    enable = true;
    addDefaultMappings = false;
    maxHighlightedTraversalTargets = 30;
  };
  keymaps = [
    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "<leader><leader>";
      action = "<Plug>(leap-forward-to)";
      options = {
        desc = "Leap forward";
      };
    }
    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "<leader><CR>";
      action = "<Plug>(leap-backward-to)";
      options = {
        desc = "Leap backward";
      };
    }
  ];
}
