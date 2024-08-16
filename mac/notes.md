### MacBook Setup
2024-06-14, minimal, essentials and lf/vim/zsh rcs

- General: Wifi, Apple id, fastest trackpad, display more space, wallpaper, dock, menu, trackpad drag, system upgrade, reduce transparency, require password immediately, no adjust brightness auto, hot corners shortcuts, use icloud to sync files so ~/Documents is icloud drive, github repos in a separate folder under home
- Finder: side bar (airdrop, desktop, down, icloud doc, icloud drive), documents when open, toolbar (search view bf), global text size, 12pt, input source
- citrix, zoom, wechat, chrome, vscode (github sync)
- Karabiner:
    - global left: option, command, control
    - capslock enhancements (gral, karabiner/karabiner.json)
    - settings > keyboard > app shortcuts
        - chrome: find, new tab, enter/exit full screen, open file, reload, new window, close tab, open location
        - finder: new window, close window, full screen
        - vscode all synced via github, terminal left, 1/3 screen

- Terminal tuning in vscode, dotfiles from gral
    - homebrew (xcode, run two lines after install to add homebrew PATH)
    - brew install htop, fzf, lf, nvim, node, watch, cliclick; oh-my-zsh install
    - code: install code command to PATH, update lfrc to use code to open files
    - apply rcs: `sudo ./install` in this folder
    - zsh plugins: oh-my-zsh themes, manual run:
    ```
    wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
    git clone https://github.com/zsh-users/zsh-completions $ZSH_CUSTOM/plugins/zsh-completions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
    ```
    - install `https://github.com/junegunn/vim-plug` and `:PlugInstall`, for both vim and nvim
    - setup `git config user.name; git config user.email` to match github profile
    - Rust/UTRP: `https://www.rust-lang.org/tools/install`, git clone repo and `cargo build`