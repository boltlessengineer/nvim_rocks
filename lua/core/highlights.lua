local util_hl = require("utils.highlights")

pcall(vim.cmd.colorscheme, "github_dark_default")

util_hl.set("StatusLineNC", { reverse = true, inherit = "StatusLine" })
-- util_hl.set("StatusLine", { bold = true })
-- local sep = util_hl.tint(util_hl.get("WinBar", "fg"), -0.25)
-- util_hl.set("WinBar", { reverse = true })
-- util_hl.set("WinBarNC", { fg = sep, reverse = true })
-- util_hl.set("WinSeparator", { fg = sep })

--[[
some good-looking colorscheems

# light-theme
- https://github.com/yorickpeterse/nvim-grey
]]
