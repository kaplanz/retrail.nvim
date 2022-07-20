-- File:        retrail.lua
-- Author:      Zakhary Kaplan <https://zakhary.dev>
-- Created:     20 Jul 2022
-- SPDX-License-Identifier: MIT

local config = require("retrail.config")

local M = {}

local refresh

function M.setup(opts)
  -- Initialize module
  M.config   = config.parse(opts)
  M.matches  = {}
  M.override = {}

  -- Prepare autocommands
  local augroup = vim.api.nvim_create_augroup("Retrail", {})
  vim.api.nvim_create_autocmd({ "BufWinEnter", "FileType" }, {
    group = augroup,
    callback = refresh,
  })
  vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    group = augroup,
    callback = function()
      if M:enabled() then
        M:trim()
      end
    end,
  })
end

refresh = function()
  if M:enabled() then
    M:matchadd()
  else
    M:matchdelete()
  end
end

function M:set(enabled)
  -- Record the override
  self.override[vim.fn.bufnr()] = enabled
  -- Trigger a refresh
  refresh()
end

function M:toggle()
  -- Record the override
  self.override[vim.fn.bufnr()] = not self:enabled()
  -- Trigger a refresh
  refresh()
end

function M:enabled()
  -- Check for a buffer override
  local override = self.override[vim.fn.bufnr()]
  if override ~= nil then
    return override
  end
  -- Check if this filetype is enabled
  local enabled = self.config.enabled[vim.bo.filetype]
  if self.config.strict then
    return enabled == true -- true
  else
    return enabled ~= false -- true | nil
  end
end

function M:matchadd()
  -- Extract match for window
  local ident = self.tabwinnr()
  local match = self.matches[ident]
  if not match then
    -- Add match to window
    match = vim.fn.matchadd(self.config.hlgroup, self.config.pattern)
    self.matches[ident] = match
  end
end

function M:matchdelete()
  -- Extract match for window
  local ident = M.tabwinnr()
  local match = self.matches[ident]
  if match then
    -- Delete match from window
    vim.fn.matchdelete(match)
    self.matches[ident] = nil
  end
end

function M.tabwinnr()
  return string.format("%d:%d", vim.fn.tabpagenr(), vim.fn.winnr())
end

function M:trim()
  -- Save cursor position
  local _, lnum, col, off, _ = unpack(vim.fn.getcurpos())
  -- Trim trailing whitespace
  if self.config.trim.whitespace then
    vim.cmd [[keeppatterns %s#\s\+$##e]]
  end
  -- Trim trailing blank lines
  if self.config.trim.blanklines then
    vim.cmd [[keeppatterns vg#\_s*\S#d]]
  end
  -- Restore cursor position
  vim.fn.cursor(lnum, col, off)
end

return M
