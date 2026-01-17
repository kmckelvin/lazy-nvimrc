local M = {}

local function split_parts(raw)
  local segments = {}
  local buffer = ""
  local depth = { paren = 0, brace = 0, bracket = 0 }
  local in_string = false
  local string_char = nil
  local i = 1

  local function push_buffer()
    local trimmed = vim.trim(buffer)
    if trimmed ~= "" then
      table.insert(segments, trimmed)
    end
    buffer = ""
  end

  while i <= #raw do
    local char = raw:sub(i, i)
    if in_string then
      if char == "\\" then
        buffer = buffer .. char
        i = i + 1
        if i <= #raw then
          buffer = buffer .. raw:sub(i, i)
        end
      elseif char == string_char then
        in_string = false
        string_char = nil
        buffer = buffer .. char
      else
        buffer = buffer .. char
      end
    else
      if char == "\"" or char == "'" or char == "`" then
        in_string = true
        string_char = char
        buffer = buffer .. char
      elseif char == "," and depth.paren == 0 and depth.brace == 0 and depth.bracket == 0 then
        push_buffer()
      else
        if char == "(" then
          depth.paren = depth.paren + 1
        elseif char == ")" then
          depth.paren = depth.paren - 1
        elseif char == "{" then
          depth.brace = depth.brace + 1
        elseif char == "}" then
          depth.brace = depth.brace - 1
        elseif char == "[" then
          depth.bracket = depth.bracket + 1
        elseif char == "]" then
          depth.bracket = depth.bracket - 1
        end
        buffer = buffer .. char
      end
    end
    i = i + 1
  end

  push_buffer()
  return segments
end

local function find_first_delimiter(line)
  local open_paren = line:find("%(")
  local open_bracket = line:find("%[")
  local open_brace = line:find("{", 1, true)

  local open_pos
  local open_char
  local close_char

  for _, entry in ipairs({
    { open_paren, "(", ")" },
    { open_bracket, "[", "]" },
    { open_brace, "{", "}" },
  }) do
    if entry[1] and (not open_pos or entry[1] < open_pos) then
      open_pos = entry[1]
      open_char = entry[2]
      close_char = entry[3]
    end
  end

  return open_pos, open_char, close_char
end

local function find_last_delimiter(line, close_char)
  if close_char == ")" then
    return line:match(".*()%)")
  end
  if close_char == "]" then
    return line:match(".*()%]")
  end
  return line:match(".*()%}")
end

local function expand_top_level_parts(open_char, parts)
  if open_char ~= "[" and open_char ~= "{" then
    return parts
  end

  local expanded = {}
  for _, part in ipairs(parts) do
    for _, segment in ipairs(split_parts(part)) do
      table.insert(expanded, segment)
    end
  end
  return expanded
end

function M.split_line(line)
  if line == "" then
    return nil
  end

  local indent = line:match("^%s*") or ""
  local open_pos, open_char, close_char = find_first_delimiter(line)
  if not open_pos then
    return nil
  end

  local close_pos = find_last_delimiter(line, close_char)
  if not close_pos then
    return nil
  end

  local prefix = line:sub(1, open_pos - 1)
  local args = line:sub(open_pos + 1, close_pos - 1)
  local suffix = line:sub(close_pos + 1)
  local trailing_comma = suffix:match("^%s*,%s*$") ~= nil

  local parts = expand_top_level_parts(open_char, split_parts(args))
  if #parts == 0 then
    return nil
  end

  local lines = { prefix .. open_char }
  local inner_indent = indent .. "  "

  for index, part in ipairs(parts) do
    local inner_suffix = index == #parts and "" or ","
    table.insert(lines, inner_indent .. part .. inner_suffix)
  end

  local closing = indent .. close_char
  if trailing_comma then
    closing = closing .. ","
  elseif suffix:match("%S") then
    closing = closing .. suffix
  end
  table.insert(lines, closing)

  return lines
end

return M
