"=====================================================================================
" Description: 	Cobol syntax checker
" Maintener: 	Emmanuel Grognet <emmanuel AT grognet DOT fr>
" License: 	Copyright (C) 2016 Emmanuel Grognet
"		This program is free software; you can redistribute it and/or
"		modify it under the terms of the GNU General Public License
"		as published by the Free Software Foundation; either version 2
"		of the License, or (at your option) any later version.
"		This program is distributed in the hope that it will be useful,
"		but WITHOUT ANY WARRANTY; without even the implied warranty of
"		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
"		GNU General Public License for more details.
"		You should have received a copy of the GNU General Public License
"		along with this program.  If not, see <http://www.gnu.org/licenses/>.
"=====================================================================================

if exists('g:cobol_syntax_checker_loaded')
	finish
endif
let g:cobol_syntax_checker_loaded = 1

if !exists('g:cobol_syntax_checker_cobc_compiler_option')
	let g:cobol_syntax_checker_cobc_compiler_option = ''
endif

if !exists('g:cobol_syntax_checker_check_on_write')
	let g:cobol_syntax_checker_check_on_write = 1 
endif

if !exists('g:cobol_syntax_checker_check_on_read')
	let g:cobol_syntax_checker_check_on_read = 1
endif

if !exists('g:cobol_syntax_checker_loc_auto_open_close')
	let g:cobol_syntax_checker_loc_auto_open_close = 1
endif

function! Cobol_Syntax_Checker()
	set errorformat+=%f:%l:%m
	exe "sign define cobolError text=>> linehl=Warning texthl=Error"
	exe "sign unplace *"
	call setloclist(0, [])
	if g:cobol_syntax_checker_loc_auto_open_close == 1
		lclose
	endif
	if bufname('%')==''
		return 1
	endif
	if !filereadable(bufname('%'))
		return 1
	endif
	if &filetype != 'cobol'
		return 1
	endif
	let resultCobc = system('cobc -fsyntax-only '.g:cobol_syntax_checker_cobc_compiler_option.' '.bufname('%'))
	if resultCobc == ''
		return 1
	endif
	let splitResultCobc = split(resultCobc, '\n')
	if len(splitResultCobc)==0
		return 1
	endif
	let signId = 0
	let firstLineError = 0
	for lineResultCobc in splitResultCobc
		let splitLine = split(lineResultCobc,':')
		if len(splitLine)<4
			continue
		endif
		let signId = signId + 1
		let fileName = substitute(splitLine[0],"^\\s\\+\\|\\s\\+$","","g")
		let lineNumber = substitute(splitLine[1],"^\\s\\+\\|\\s\\+$","","g")+0
		if firstLineError == 0
			let firstLineError = lineNumber
			exe(':'.firstLineError)
		endif
		exe "sign place ".signId." line=".lineNumber." name=cobolError file=".fileName
		let errorTxt = substitute(splitLine[3],"^\\s\\+\\|\\s\\+$","","g")
		let errorMsg = printf('%s:%d:%s', fileName, lineNumber, errorTxt)
		laddexpr errorMsg
	endfor
	if resultCobc!=""
		if g:cobol_syntax_checker_loc_auto_open_close == 1
			lopen
		endif
	endif
endfunction

function! Cobol_syntax_checker_init()
	if g:cobol_syntax_checker_check_on_write == 1
		autocmd BufWritePost * call Cobol_Syntax_Checker()
	endif
	if g:cobol_syntax_checker_check_on_read == 1
		autocmd BufWinEnter * call Cobol_Syntax_Checker()
	endif
endfunction

autocmd FileType cobol call Cobol_syntax_checker_init()
