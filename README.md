# p-vim

Syntax highlighting, indent, and [ALE](https://github.com/dense-analysis/ale)
linting support for [P](https://github.com/p-org/P).

## Install

[vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'kiosion/p-vim'
```

[Vundle](https://github.com/VundleVim/Vundle.vim):

```vim
Plugin 'kiosion/p-vim'
```

[lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{ 'kiosion/p-vim' },
```

Or, clone into `~/.vim/pack/local/start/p-vim`.

## Checking

P's compiler is required:

```sh
dotnet tool install --global P
```

ALE is required for linting and inline errors. Both are off by default and
are enabled by adding `let g:p_lint = 1` in vimrc.

Both `~/.dotnet/tools` and `PATH` are checked for P and DotNet. A different
location may be specified with `let g:ale_p_pc_executable = ''`, and args
with `let g:ale_p_pc_options = ''` in vimrc.

## Folding

Off by default; `foldmethod=syntax` folds every `Machine` on open. Can be
enabled with `let g:p_syntax_folding = 1` in vimrc.
