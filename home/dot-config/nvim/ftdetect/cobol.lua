vim.filetype.add { extension = { cob = 'cobol', cbl = 'cobol', cpy = 'cobol', COB = 'cobol', CBL = 'cobol', CPY = 'cobol' } }

-- The bundled mappings assume fixed columns and override normal indentation keys.
vim.g.no_cobol_maps = 1
vim.g.cobol_inline_comment = 1
