# vim-cobol-syntax-checker

## Introduction

Vim-cobol-syntax-checker is a vim plugin for check cobol syntax.

The plugin can check syntax on demand or automatically when file is save/open.

Free and strict cobol syntax are supported.

Check is done by the compiler cobc (aka GnuCOBOL https://sourceforge.net/projects/open-cobol/).

## How it work ?

- you write your code in cobol
- when you save your code, the plugin run cobc and get the result
- if there compile error, errors are displayed in the location list and signs are placed beside lines with errors
- the focus is given on the first line that contains an error

## Installation

### Requirement

- vim of course
- cobc https://sourceforge.net/projects/open-cobol/
- pathogen, vundle, neobundle or any vim plugin manager

### Installation with pathogen

    cd ~/.vim/bundle

    git clone https://github.com/emmanuelgrognet/vim-cobol-syntax-checker.git
    
## Configuration

### Strict/Free Cobol syntax

#### Free modern cobol syntax :

    let g:cobol_syntax_checker_cobc_compiler_option = '-free'
    
#### Traditional old cobol syntax (default)

    let g:cobol_syntax_checker_cobc_compiler_option = ''
    
### Check syntax when open cobol file (default)

    let g:cobol_syntax_checker_check_on_read = 1
    
### Check syntax when save cobol file (default)

    let g:cobol_syntax_checker_check_on_write = 1 
    
### Auto open/close location list (default)

    let g:cobol_syntax_checker_loc_auto_open_close = 1
    

