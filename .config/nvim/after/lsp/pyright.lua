-- Helper: conda python resolver
local function conda_python()
  local p = vim.env.CONDA_PREFIX
  if p and p ~= "" then
    return p .. "/bin/python"
  end
  -- fallback
  local py = vim.fn.exepath("python3")
  if py ~= "" then return py end
  return vim.fn.exepath("python")
end

return {
  filetypes = { "python" },
  settings = {
    python = {
      pythonPath = conda_python(),
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true,
      },
    },
  },
}
