" Reuse Neovim's case-insensitive COBOL vocabulary without fixed-format columns.
syntax clear cobolMarker cobolSpace cobolAreaA cobolAreaB cobolBadLine cobolIndicator
syntax match cobolFreeLine /^.*$/ contains=@cobolLine,cobolDivision,cobolSection,cobolParagraph,cobolDeclA,cobolDecl
syntax region cobolInlineComment start=/\*>/ end=/$/ contains=cobolTodo containedin=ALLBUT,cobolString
