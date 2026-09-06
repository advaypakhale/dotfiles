-- Puts Neovim's toolchain (../mise.toml) on Neovim's PATH alone: on a login
-- PATH this python would shadow the 3.10 that ROS Humble is built against.
-- `:terminal` does inherit it.

local config_dir = vim.fn.stdpath "config"
-- `mise bin-paths` costs ~40ms, so it is cached until a manifest changes.
local cache_file =
    vim.fs.joinpath(vim.fn.stdpath "cache", "mise-bin-paths.json")
local manifests = {
    vim.fs.joinpath(config_dir, "mise.toml"),
    vim.fs.joinpath(config_dir, "mise.lock"),
}

local tools = { "node", "python", "cargo:tree-sitter-cli" }

local function mtime(path)
    local stat = vim.uv.fs_stat(path)
    return stat and stat.mtime.sec or 0
end

local function cached()
    local newest = 0
    for _, manifest in ipairs(manifests) do
        newest = math.max(newest, mtime(manifest))
    end
    if mtime(cache_file) <= newest then
        return nil
    end
    local ok, data = pcall(function()
        return vim.json.decode(table.concat(vim.fn.readfile(cache_file), "\n"))
    end)
    if ok and type(data) == "table" and #data > 0 then
        return data
    end
    return nil
end

local function resolve()
    local cmd = { "mise", "bin-paths" }
    vim.list_extend(cmd, tools)
    local result = vim.system(cmd, { cwd = config_dir, text = true }):wait()
    if result.code ~= 0 then
        return {}
    end
    local paths =
        vim.split(vim.trim(result.stdout or ""), "\n", { trimempty = true })
    -- A short answer means a tool is missing; caching it would pin the gap.
    if #paths == #tools then
        vim.fn.mkdir(vim.fs.dirname(cache_file), "p")
        pcall(vim.fn.writefile, { vim.json.encode(paths) }, cache_file)
    end
    return paths
end

if vim.fn.executable "mise" == 1 then
    local paths = cached() or resolve()
    if #paths > 0 then
        vim.env.PATH = table.concat(paths, ":") .. ":" .. vim.env.PATH
    end
end
