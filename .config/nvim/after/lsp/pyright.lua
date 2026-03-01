-- Helpers
local function path_join(...)
  return table.concat({ ... }, "/")
end

local function exists(p)
  return vim.loop.fs_stat(p) ~= nil
end

-- pythonPath resolver
local function get_python()
  --workspace = workspace or vim.fn.getcwd()
  --local root = find_root(workspace)
  local root = vim.fn.getcwd()

  -- 1) If user activated a venv/conda before launching nvim, respect it
  if vim.env.VIRTUAL_ENV and #vim.env.VIRTUAL_ENV > 0 then
    return path_join(vim.env.VIRTUAL_ENV, "bin", "python")
  end

  if vim.env.CONDA_PREFIX and #vim.env.CONDA_PREFIX > 0 then
    return path_join(vim.env.CONDA_PREFIX, "bin", "python")
  end

  -- 2) Prefer project-local uv/venv (.venv)
  local venv = path_join(root, ".venv")
  if exists(venv) then
    local p = path_join(venv, "bin", "python")
    if exists(p) then return p end
  end

  -- 3) Fallback
  return vim.fn.exepath("python3") ~= "" and vim.fn.exepath("python3") or vim.fn.exepath("python")
end

return {
  filetypes = { "python" },
  settings = {
    python = {
      pythonPath = get_python(),
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true,
      },
    },
  },
}
