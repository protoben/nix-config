{ pkgs }:

let
  cfgConcat = builtins.concatStringsSep "\n\"\"\" Section\n\n";

  baseCfg = ''
    colo elflord
    syn on

    set bs=2 nocompatible laststatus=2 t_Co=256
    set tabstop=8 shiftwidth=4 expandtab
    set wildmode=longest,full wildmenu
    set number
    set mouse=a
    
    filetype plugin indent on
  '';

  airlineCfg = ''
    let g:airline_theme = 'kolor'
    let g:airline_right_sep = ""
    let g:airline_left_sep = ""
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#fnamemod = ':t'
  '';

  w3mCfg = ''
    let g:w3m#hover_delay_time = 10
    let g:w3m#homepage = "https://duckduckgo.com/"
    let g:w3m#search_engine = 'https://duckduckgo.com/?q=%s'
  '';

  rainbowCfg = ''
    let g:rbpt_max = 32
    let g:rbpt_colorpairs = [
      \ ['brown',   'RoyalBlue3'],
      \ ['blue',    'SeaGreen3'],
      \ ['gray',    'DarkOrchid3'],
      \ ['green',   'firebrick3'],
      \ ['cyan',    'RoyalBlue3'],
      \ ['red',     'SeaGreen3'],
      \ ['magenta', 'DarkOrchid3'],
      \ ['brown',   'firebrick3'],
      \ ['gray',    'RoyalBlue3'],
      \ ['red',     'DarkOrchid3'],
      \ ['green',   'RoyalBlue3'],
      \ ['brown',   'SeaGreen3'],
      \ ['magenta', 'DarkOrchid3'],
      \ ['blue',    'firebrick3'],
      \ ['cyan',    'SeaGreen3'],
      \ ['red',     'firebrick3'],
      \ ]
    au VimEnter * RainbowParenthesesToggle
    au VimEnter * RainbowParenthesesLoadRound
    au VimEnter * RainbowParenthesesLoadSquare
    au VimEnter * RainbowParenthesesLoadBraces
  '';

  vimAddonNixCfg = ''
    let g:nix_maintainer="Ben Hamlin"
  '';

  signifyCfg = ''
    highlight SignColumn cterm=none ctermbg=0
    highlight LineNR     cterm=none ctermbg=0 ctermfg=56
  '';

  nerdtreeCfg = ''
    let g:NERDTreeDirArrowExpandable = '+'
    let g:NERDTreeDirArrowCollapsible = '-'
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
    let g:NERDTreeIndicatorMapCustom = {
      \ 'Modified'  : 'modified',
      \ 'Staged'    : 'staged',
      \ 'Untracked' : 'untracked',
      \ 'Renamed'   : 'renamed',
      \ 'Unmerged'  : 'unmerged',
      \ 'Deleted'   : 'deleted',
      \ 'Dirty'     : 'dirty',
      \ 'Clean'     : 'clean',
      \ 'Ignored'   : 'ignored',
      \ 'Unknown'   : 'unknown'
      \ }
  '';

  tagbarCfg = ''
    let g:tagbar_type_haskell = {
      \ 'ctagsbin'  : 'hasktags',
      \ 'ctagsargs' : '-x -c -o-',
      \ 'kinds'     : [
        \  'm:modules:0:1',
        \  'd:data: 0:1',
        \  'd_gadt: data gadt:0:1',
        \  't:type names:0:1',
        \  'nt:new types:0:1',
        \  'c:classes:0:1',
        \  'cons:constructors:1:1',
        \  'c_gadt:constructor gadt:1:1',
        \  'c_a:constructor accessors:1:1',
        \  'ft:function types:0:1',
        \  'fi:function implementations:1:1',
        \  'o:others:0:1'
      \ ],
      \ 'sro'        : '.',
      \ 'kind2scope' : {
        \ 'm' : 'module',
        \ 'c' : 'class',
        \ 'd' : 'data',
        \ 't' : 'type'
      \ },
      \ 'scope2kind' : {
        \ 'module' : 'm',
        \ 'class'  : 'c',
        \ 'data'   : 'd',
        \ 'type'   : 't'
      \ }
    \ }
    let g:tagbar_type_markdown = {
      \ 'ctagstype' : 'markdown',
      \ 'kinds' : [
        \ 'h:Heading_L1',
        \ 'i:Heading_L2',
        \ 'k:Heading_L3'
      \ ]
    \ }
    let g:tagbar_type_make = {
      \ 'kinds':[
        \ 'm:macros',
        \ 't:targets'
      \ ]
    \}
    let g:tagbar_map_showproto = '<Tab>'
    let g:tagbar_compact = 1
    let g:tagbar_autofocus = 1
  '';

  ctags_config = pkgs.runCommand "ctags_config" {} ''
    mkdir -p $out/etc/ctags.d
    cat > $out/etc/ctags.d/markdown.ctags << EOF
    --langdef=markdown
    --langmap=markdown:.md
    --regex-markdown=/^#[ \t]+(.*)/\1/h,Heading_L1/
    --regex-markdown=/^##[ \t]+(.*)/\1/i,Heading_L2/
    --regex-markdown=/^###[ \t]+(.*)/\1/k,Heading_L3/
    EOF
    cat > $out/etc/ctags.d/make.ctags << EOF
    --regex-make=/^([^# \t]*):/\1/t,target/
    EOF
  '';

  # Unused for the moment
  syntasticCfg = ''
    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*

    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
  '';

  keymapCfg = ''
    let mapleader=' '

    noremap <silent> <Leader>h <C-W>h
    noremap <silent> <Leader>j <C-W>j
    noremap <silent> <Leader>k <C-W>k
    noremap <silent> <Leader>l <C-W>l
    noremap <silent> <Leader>H <C-W>H
    noremap <silent> <Leader>J <C-W>J
    noremap <silent> <Leader>K <C-W>K
    noremap <silent> <Leader>L <C-W>L
    
    noremap <silent> <Leader>y gT
    noremap <silent> <Leader>u gt
    
    noremap <silent> <Leader>by :bprev<CR>
    noremap <silent> <Leader>bu :bnext<CR>
    noremap <silent> <Leader>bl :ls<CR>
    noremap <silent> <leader>bq :bw<CR>
    
    noremap <silent> <Leader>r :source $VIMRUNTIME/defaults.vim<CR>
    
    " Plugin key mappings
    noremap  <silent> <Leader>t  :NERDTreeTabsToggle<CR>
    noremap  <silent> <Leader>gs :Gstatus<CR>
    noremap  <silent> <Leader>gd :Gdiff<CR>
    noremap  <silent> <Leader>gb :Gblame<CR>
    vnoremap <silent> <Leader>gg :exe 'Ggrep ' . expand('<cword>')<CR>
    noremap  <silent> <Leader>w  :ShowWhiteToggle<CR>
    noremap  <silent> <Leader>m  :exe 'Man ' . expand('<cword>')<CR>
    noremap  <silent> K          :exe 'Man ' . expand('<cword>')<CR>
    noremap  <silent> <Leader>M  :exe 'Vman ' . expand('<cword>')<CR>
    noremap  <silent> <Leader>o  :W3mSplit <C-R><C-F><CR>
    noremap  <silent> <Leader>O  :W3mVSplit <C-R><C-F><CR>
    nnoremap <silent> <Leader>.  :call unicoder#start(0)<CR>
    inoremap <silent> <C-l>      <Esc>:call unicoder#start(1)<CR>
    vnoremap <silent> <Leader>.  :<C-u>call unicoder#selection()<CR>
    noremap  <silent> <Leader>b  :TagbarOpen fjc<CR>
    noremap  <silent> <Leader>B  :TagbarToggle<CR>
  '';

  extraPlugins = {
    w3m = pkgs.vimUtils.buildVimPlugin {
      name = "w3m";
      src = pkgs.fetchFromGitHub {
        owner = "yuratomo";
        repo = "w3m.vim";
        rev = "228a852b188f1a62ecea55fa48b0ec892fa6bad7";
        sha256 = "0c06yipsm0a1sxdlhnf41lifhzgimybra95v8638ngmr8iv5dznf";
      };
    };
    vim-man = pkgs.vimUtils.buildVimPlugin {
      name = "vim-man";
      src = pkgs.fetchFromGitHub {
        owner = "vim-utils";
        repo = "vim-man";
        rev = "cfdc78f52707b4df76cbe57552a7c8c28a390da4";
        sha256 = "1c5g8m77nhxwzdq2fq23s9zy3yyg9mka9056nkqwxna8gl90y3mx";
      };
    };
    vim-haskellFold = pkgs.vimUtils.buildVimPlugin {
      name = "vim-haskellFold";
      src = pkgs.fetchFromGitHub {
        owner = "Twinside";
        repo = "vim-haskellFold";
        rev = "6f32264b572821846141c020f28076d745872433";
        sha256 = "19nnk0g5v99sljrkzqd60d1di9ls0fyfw3db1djwaqlprl7zig1q";
      };
    };
    vim-show-char = pkgs.vimUtils.buildVimPlugin {
      # Doesn't build because `vim` isn't in scope at build step...
      name = "vim-show-char";
      src = pkgs.fetchFromGitHub {
        owner = "chrisbra";
        repo = "vim-show-char";
        rev = "2de14a4af06e371efe5b419f5df1c2b22b437b91";
        sha256 = "09z7sdab83akrj13az5nsq3vvr47lww6wh7vzz0n8xn8f55hfpxb";
      };
    };
    latex-unicoder = pkgs.vimUtils.buildVimPlugin {
      name = "latex-unicoder";
      src = pkgs.fetchFromGitHub {
        owner = "joom";
        repo = "latex-unicoder.vim";
        rev = "46c1ccaec312e4d556c45c71b4de8025ff288f48";
        sha256 = "03a16ysy7fy8if6kwkgf2w4ja97bqmg3yk7h1jlssz37b385hl2d";
      };
    };
  };

  vim_configured = pkgs.vim_configurable.customize {
    name = "vim";
    vimrcConfig = {
      customRC = cfgConcat [
        baseCfg
        airlineCfg rainbowCfg vimAddonNixCfg w3mCfg signifyCfg tagbarCfg nerdtreeCfg
        keymapCfg
      ];
      vam = {
        knownPlugins = pkgs.vimPlugins // extraPlugins;
        pluginDictionaries = [
          { names = [ "rainbow_parentheses" ]; }
          { names = [ "w3m" ]; }
          { names = [ "vim-man" ]; }
          { names = [ "latex-unicoder" ]; }
          { names = [ "airline" "vim-airline-themes" ]; }
          { names = [ "nerdtree" "vim-nerdtree-tabs" "nerdtree-git-plugin" ]; }
          { names = [ "vim-signify" "fugitive" ]; }
          { names = [ "vim-addon-nix" "vim-nix"]; ft_regex = "^nix\$"; }
          { names = [ "vim-haskellFold" /*"haskell-vim"*/ ]; ft_regex = "^haskell\$"; }
          { names = [ "Tagbar" ]; ft_regex = "^\\(haskell\\|c\\|c++\\|markdown\\|make\\)\$"; }
        ];
      };
    };
  };

in pkgs.buildEnv {
  name = "protovim";
  paths = [
    pkgs.w3m
    pkgs.git
    pkgs.haskellPackages.hasktags
    pkgs.universal-ctags
    pkgs.man-pages

    ctags_config
    vim_configured
  ];
}
