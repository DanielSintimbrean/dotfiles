vim.pack.add({
	{ src = "https://github.com/obsidian-nvim/obsidian.nvim" },
})

require("obsidian").setup({
	legacy_commands = false,
	workspaces = {
		{
			name = "2nd-brain",
			path = "~/Obsidian/2nd-brain",
		},
	}
})
