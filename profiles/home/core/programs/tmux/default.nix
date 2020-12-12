{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    escapeTime = 0;
    newSession = false;
    shortcut = "a";
    terminal = "screen-256color";
    extraConfig = ''
      set -g mouse on
      set -g status-position top
      set -g set-titles on
      set -g set-titles-string '[#S:#I] #W'
      set -gw automatic-rename on
      set -g status-bg "#1c1c1c"
      set -g status-fg "#c6c6c6"
      set -g status-justify centre
      set -g status-left ""
      set -g status-right ""
      set -ga terminal-overrides ",screen-256color:Tc:sitm=\E[3m"
      unbind c
      bind c new-window
      unbind &
      bind k confirm-before kill-window
      unbind l
      bind C-a last-window
      unbind C-b
      bind a send-prefix
      unbind n
      bind n next-window
      unbind p
      bind p previous-window
      unbind d
      bind d detach
      unbind [
      bind Escape copy-mode
      unbind %
      bind h split-window -h
      unbind "'"
      bind v split-window -v
      bind / command-prompt "split-window 'exec man %%'"
    '';
  };
}
