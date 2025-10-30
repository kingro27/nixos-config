{ pkgs, lib, ... }:
{
  vim = {
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    options = {
      number = true;
      mouse = "a";
      relativenumber = true;
      tabstop = 2;
      softtabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      smartindent = true;
      wrap = false;
      linebreak = true;
      hlsearch = false;
      incsearch = true;
      scrolloff = 8;
      breakindent = true;
      ignorecase = true;
      smartcase = true;
      splitright = true;
      splitbelow = true;
      cursorline = true;
      confirm = true;
    };

    clipboard = {
      enable = true;
      providers.wl-copy.enable = true;
      registers = "unnamedplus";
    };

    keymaps = [
      { key = "<leader>pv";                     mode = [ "n" ];                     action = "vim.cmd.Ex";                          lua = true; }
      { key = "<leader>q";                      mode = [ "n" ];                     action = "vim.diagnostic.setloclist";           lua = true; }
      { key = "<Esc>";                          mode = [ "n" ];                     action = "<cmd>nohlsearch<CR>"; }
      { key = "<Esc><Esc>";                     mode = [ "t" ];                     action = "<C-\\><C-n>"; }

      { key = "<C-h>";                          mode = [ "n" ];                     action = "<C-w><C-h>";                          desc = "Move focus to the left window"; }
      { key = "<C-l>";                          mode = [ "n" ];                     action = "<C-w><C-l>";                          desc = "Move focus to the right window"; }
      { key = "<C-j>";                          mode = [ "n" ];                     action = "<C-w><C-j>";                          desc = "Move focus to lower right window"; }
      { key = "<C-k>";                          mode = [ "n" ];                     action = "<C-w><C-k>";                          desc = "Move focus to lower upper window"; }

      { key = "J";                              mode = [ "v" ];                     action = ":m '>+1<CR>gv=gv"; }
      { key = "K";                              mode = [ "v" ];                     action = ":m '<-2<CR>gv=gv"; }

      { key = "J";                              mode = [ "n" ];                     action = "mzJ`z"; }
      { key = "<C-d>";                          mode = [ "n" ];                     action = "<C-d>zz"; }
      { key = "<C-u>";                          mode = [ "n" ];                     action = "<C-u>zz"; }
      { key = "n";                              mode = [ "n" ];                     action = "nzzzv"; }
      { key = "N";                              mode = [ "n" ];                     action = "Nzzzv"; }

      { key = "<leader>p";                      mode = [ "x" ];                     action = "[[\"_dP]]"; }
      { key = "<leader>y";                      mode = [ "n" "v" ];                 action = "[[\"+y]]"; }
      { key = "<leader>Y";                      mode = [ "n" ];                     action = "[[\"+Y]]"; }
      
      { key = "<leader>d";                      mode = [ "n" "v" ];                 action = "[[\"_d]]"; }

      { key = "<C-c>";                          mode = [ "i" ];                     action = "<Esc>"; }
      { key = "Q";                              mode = [ "n" ];                     action = "<nop>"; }

      { key = "<leader>f";                      mode = [ "n" ];                     action = "vim.lsp.buf.format";                  lua = true; }

      { key = "<C-k>";                          mode = [ "n" ];                     action = "<cmd>cnext<CR>zz"; }
      { key = "<C-j>";                          mode = [ "n" ];                     action = "<cmd>cprev<CR>zz"; }
      { key = "<leader>k";                      mode = [ "n" ];                     action = "<cmd>lnext<CR>zz"; }
      { key = "<leader>j";                      mode = [ "n" ];                     action = "<cmd>lprev<CR>zz"; }
    ];

    theme = {
      enable = true;
      name = "gruvbox";
      style = "dark";
    };

    autocomplete.blink-cmp = {
      enable = true;
      friendly-snippets.enable = true;
    };

    statusline.lualine.enable = true;
    telescope.enable = true;

    languages = {
      enableFormat = true;
      enableTreesitter = true;
      
      nix = {
        enable = true;
        lsp.enable = true;
      };
    };
  };
}
