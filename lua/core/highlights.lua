local util_hl = require("utils.highlights")

pcall(vim.cmd.colorscheme, "github_dark_default")

--[[
some good-looking colorscheems

# dark-theme
- https://github.com/sho-87/kanagawa-paper.nvim

# light-theme
- https://github.com/yorickpeterse/nvim-grey
]]

-- colorscheme callback map used from core.autocmds
return {
    ["github_dark_default"] = function ()
        util_hl.set("StatusLineNC", { reverse = true, inherit = "StatusLine" })
        -- util_hl.set("StatusLine", { bold = true })
        -- local sep = util_hl.tint(util_hl.get("WinBar", "fg"), -0.25)
        -- util_hl.set("WinBar", { reverse = true })
        -- util_hl.set("WinBarNC", { fg = sep, reverse = true })
        -- util_hl.set("WinSeparator", { fg = sep })
    end
}
