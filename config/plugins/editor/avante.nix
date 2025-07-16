{
  plugins.avante = {
    enable = true;
    settings = {
      providers = {
        claude = {
          endpoint = "https://api.anthropic.com";
          model = "claude-sonnet-4-20250514";
          timeout = 30000;
          extra_request_body = {
            temperature = 0.75;
            max_tokens = 20480;
          };
        };
        gemini = {
          # endpoint = "https://generativelanguage.googleapis.com";
          model = "gemini-2.5-pro";
        };
        openai = {
          # endpoint = "https://api.openai.com";
          model = "o4-mini-2025-04-16";
        };
      };
    };
  };

  plugins.lualine = {
    settings = {
      options = {
        disabled_filetypes = [
					"Avante"
					"AvanteInput"
					"AvanteSelectedFiles"
        ];
      };
    };
  };
}
