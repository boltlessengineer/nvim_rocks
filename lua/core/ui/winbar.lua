local Util = require("utils")
local util_hl = require("utils.highlights")

local function is_win_current()
  local winid = vim.api.nvim_get_current_win()
  local curwin = tonumber(vim.g.actual_curwin)
  return winid == curwin
end

local hls = {
}

local hl_text = util_hl.hl_text

local function file_name()
  local path = vim.fn.expand("%:p:h")--[[@as string]]
  path = path:gsub("oil://", "")
  -- stylua: ignore
  path = vim.fs.joinpath(path, "")
    :gsub(vim.pesc(vim.fs.joinpath(Util.root(), "")), "")

  local name = vim.fn.expand("%:p:t")--[[@as string]]
  if vim.bo.filetype == "oil" then
    name = path == "" and "." or path
    path = "oil://"
  elseif name == "" then
    name = "[No Name]"
  end

  local hi = is_win_current() and hls.bold or hls.nc_bold
  return hl_text(path, hls.nc_base) .. hl_text(name, hi)
end

local function sg_name()
  local path = vim.fn.expand("%:p:h")
  path = path .. "/"
  local name = vim.fn.expand("%:p:t")
  local hi = is_win_current() and hls.bold or hls.nc_bold
  return hl_text(path, hls.nc_base) .. hl_text(name, hi)
end

local function sg_status()
  -- TODO:
  -- on github.com
  -- on crates.io
  return ""
end

function _G.winbar()
  local modules = {}
  local buftype = vim.bo.buftype
  local filetype = vim.bo.filetype
  local filename = vim.api.nvim_buf_get_name(0)
  local function center(title)
    return {
      vi_mode(),
      "%=" .. title .. "%=",
      vi_mode_placer,
    }
  end
  if buftype == "" or filename:match('^suda://') then
    modules = {
      vi_mode(),
      "  ",
      file_name(),
      file_modi(),
      "  ",
      git_status(),
      "%=",
      "%<",
      "%-14.(" .. lsp_status() .. "%)",
      " ",
      "%P ",
    }
  elseif buftype == "help" then
    modules = center(help_file())
  elseif buftype == "terminal" then
    modules = {
      vi_mode(),
      "%=Terminal%=",
      -- TODO: add terminal id too
      vi_mode_placer,
    }
  elseif buftype == "nofile" and filetype == "query" and vim.bo.modifiable and not vim.bo.readonly then
    modules = center("Edit Query")
  elseif filetype == "qf" then
    modules = center("Quickfix List")
  elseif filetype == "checkhealth" then
    modules = center("checkhealth")
  elseif filetype == "oil" then
    modules = {
      vi_mode(),
      "  ",
      file_name(),
      file_modi(),
      "  ",
      git_status(),
      "%=",
      " ",
      "%P ",
    }
  elseif filetype:match("^Neogit.*") then
    modules = center("Neogit")
  elseif filetype == "neotest-summary" then
    modules = center("Test Summary")
  elseif filetype == "tsplayground" then
    modules = center("TSPlayground")
  elseif vim.fn.win_gettype(vim.api.nvim_get_current_win()) == "command" then
    modules = center("Command Window")
  elseif filename:match("^sg://") then
    modules = {
      vi_mode(),
      "  ",
      sg_name(),
      file_modi(),
      "  ",
      sg_status(), -- TODO: sg_status instead of git_status
      "%=",
      "%<",
      " ",
      "%P ",
    }
  else
    modules = center(filetype)
  end
  return table.concat(vim.tbl_filter(function(i)
    return i ~= nil
  end, modules))
end
