{
  extraConfigLuaPre = ''
    vim.fn.mkdir(vim.fn.stdpath("data") .. "/project_nvim", "p")
  '';

  plugins.project-nvim = {
    enable = true;
    enableTelescope = true;
  };
}
