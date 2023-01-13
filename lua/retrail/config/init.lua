-- File:        init.lua
-- Author:      Zakhary Kaplan <https://zakhary.dev>
-- Created:     20 Jul 2022
-- SPDX-License-Identifier: MIT

local defaults = require("retrail.config.defaults")

local M = {}

function M.parse(opts)
  -- Populate missing keys from defaults
  local config = vim.tbl_deep_extend("keep", opts or {}, defaults)

  -- Merge enabled/disabled
  config.enabled = {}
  local function merge(property)
    local enabled = {}
    -- Allow all included filetypes
    for _, v in ipairs(property.include) do
      enabled[v] = true
    end
    -- Disallow all excluded filetypes
    for _, v in ipairs(property.exclude) do
      enabled[v] = false
    end
    return enabled
  end

  -- Extract buftypes
  config.enabled.buftype = merge(config.buftype)
  -- Extract filetypes
  config.enabled.filetype = merge(config.filetype)

  return config
end

return M
