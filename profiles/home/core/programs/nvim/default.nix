{ pkgs, ... }:
let
  inherit (pkgs.vimUtils) buildVimPlugin;
in
{
  home = {
    packages = with pkgs; [
      rnix-lsp
    ];
    sessionVariables = {
      "EDITOR" = "nvim";
      "VISUAL" = "nvim";
      "PAGER" = "/bin/sh -c \"unset PAGER;col -b -x | nvim -R -c 'set ft=man nomod nolist' -c 'map q :q<CR>' -c 'map <SPACE> <C-D>' -c 'map b <C-U>' -c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\"";
    };
  };

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    withPython3 = true;
    extraConfig = builtins.readFile ./init.vim;
    plugins =
      let
        parinfer-rust = pkgs.kakounePlugins.parinfer-rust;
        janet-vim = buildVimPlugin {
          name = "janet.vim";
          src = pkgs.fetchFromGitHub {
            owner = "janet-lang";
            repo = "janet.vim";
            rev = "1d616c0169138a017f245c104565bd25b079c8f0";
            sha256 = "1MNyUIvgl3EHBXPdPvvaYS89y80g+GenQwhBYLVJBzI=";
          };
          buildInputs = [ pkgs.janet ];
        };
        vim-tidal = buildVimPlugin {
          name = "vim-tidal";
          src = pkgs.fetchFromGitHub {
            owner = "tidalcycles";
            repo = "vim-tidal";
            rev = "32614c3c5982ca00861cedbf3fa5a6515d9bb16b";
            sha256 = "+6GqLpwvuXsyuNUq/8v3WSeZAscjTjXoci0uoNCKQjw=";
          };

          # The Makefile tries to install binaries to /usr/local/bin,
          # however, since the plugin depends on them being on PATH,
          # we install them imperatively in another folder.
          # TODO: install them declaratively
          configurePhase = "rm Makefile";
        };
      in
      with pkgs.vimPlugins; [
        nvim-lspconfig
        nvim-lsputils
        popfix
        parinfer-rust
        fzf-vim
        haskell-vim
        vim-tidal
        janet-vim
        jellybeans-vim
        emmet-vim
        vim-polyglot
        vimsence
        nerdcommenter
        seoul256-vim
        lightline-vim
        vim-orgmode
      ];
  };
}
