-- File:        init.lua
-- Author:      Zakhary Kaplan <https://zakhary.dev>
-- Created:     20 Jul 2022
-- SPDX-License-Identifier: MIT

local defaults = require("retrail.config.defaults")

local M = {}

function M.parse(opts)
  -- Populate missing keys from defaults
  local config = vim.tbl_deep_extend("keep", opts or {}, defaults)

  -- Extract filetypes
  config.enabled = (function(filetype)
    local enabled = {}
    -- Allow all included filetypes
    for _, v in ipairs(filetype.include) do
      enabled[v] = true
    end
    -- Disallow all excluded filetypes
    for _, v in ipairs(filetype.exclude) do
      enabled[v] = false
    end
    return enabled
  end)(config.filetype)

  return config
end

return M
