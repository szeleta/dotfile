local float_buf = nil
local float_win = nil
local float_file = nil

-- 💡変更有無を確認する関数（git diff --quietを使うわ）
local function file_has_changes(git_dir, file_path, callback)
  vim.loop.spawn("git", {
    args = { "-C", git_dir, "diff", "--quiet", "--", file_path },
    stdio = {nil, nil, nil},
  }, function(code)
    vim.schedule(function()
      -- code == 1 → 変更あり、code == 0 → 変更なし
      callback(code == 1)
    end)
  end)
end

-- Gitコマンドを順番に実行する補助関数ね〜
local function run_git_commands_in_order(git_dir, file_path)
  local function run(cmd_args, next_step)
    vim.loop.spawn("git", {
      args = vim.tbl_flatten({ "-C", git_dir, cmd_args }),
      stdio = {nil, nil, nil},
    }, function(code)
      vim.schedule(function()
        print("git " .. table.concat(cmd_args, " ") .. " → 終了コード: " .. code)
        if code == 0 and next_step then
          next_step()
        elseif code ~= 0 then
          print("⚠️ git コマンド失敗: ", table.concat(cmd_args, " "))
        end
      end)
    end)
  end

  -- 実行順: add → commit → push
  run({ "add", file_path }, function()
    run({ "commit", "-m", "Auto commit from Neovim floating window" }, function()
      run({ "push" })
    end)
  end)
end

-- 非同期Gitコミット処理（変更があるときだけ行うわ）
local function async_git_commit_and_push(file_path)
  local git_dir = vim.fn.fnamemodify(file_path, ":p:h")

  file_has_changes(git_dir, file_path, function(has_changes)
    if has_changes then
      run_git_commands_in_order(git_dir, file_path)
    else
      print("✅ 変更なし、Gitコミットはスキップされました")
    end
  end)
end

-- トグル関数
local function toggle_floating_file(filename)
  if float_win and vim.api.nvim_win_is_valid(float_win) then
    if float_buf and vim.api.nvim_buf_is_valid(float_buf) then
      vim.api.nvim_buf_call(float_buf, function()
        vim.cmd('write! ' .. vim.fn.fnameescape(float_file))
      end)

      if float_file and vim.fn.filereadable(float_file) == 1 then
        async_git_commit_and_push(float_file)
      end
    end

    vim.api.nvim_win_close(float_win, true)
    float_buf = nil
    float_win = nil
    float_file = nil
    return
  end

  float_file = vim.fn.expand(filename)

  local lines = {}
  for line in io.lines(float_file) do

    table.insert(lines, line)
  end

  float_buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(float_buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(float_buf, 'modifiable', true)
  vim.api.nvim_buf_set_option(float_buf, 'filetype', 'markdown')

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  float_win = vim.api.nvim_open_win(float_buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  })
end

-- キーバインド
vim.keymap.set('n', '<C-t>', function()

  toggle_floating_file(vim.fn.expand('~/obsidian/dashboad.md'))
end, { noremap = true, silent = true })

