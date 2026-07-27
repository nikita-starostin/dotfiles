local M = {}

local function extract_tags(line)
  local tags = {}
  for tag in line:gmatch("#[%w_%-]+") do
    tags[#tags + 1] = tag
  end
  return tags
end

local function parse_timestamp(line)
  local year, month, day, hour, min, sec = line:match("^(%d%d%d%d)%-(%d%d)%-(%d%d) (%d%d):(%d%d):(%d%d):")
  if not year then
    return nil
  end

  return os.time({
    year = tonumber(year),
    month = tonumber(month),
    day = tonumber(day),
    hour = tonumber(hour),
    min = tonumber(min),
    sec = tonumber(sec),
  })
end

function M.parse_journal(lines)
  local header_line = nil
  for index, line in ipairs(lines) do
    if line:match("^##%s+Journal%s*$") then
      header_line = index
      break
    end
  end

  if not header_line then
    return {
      header_line = nil,
      entries = {},
    }
  end

  local entries = {}
  for index = header_line + 1, #lines do
    local line = lines[index]

    if line:match("^##%s+") then
      break
    end

    local timestamp = parse_timestamp(line)
    if timestamp then
      entries[#entries + 1] = {
        line = index,
        timestamp = timestamp,
        is_chill = line:match("#chill%f[%W]") ~= nil,
        tags = extract_tags(line),
      }
    end
  end

  return {
    header_line = header_line,
    entries = entries,
  }
end

function M.calculate_chill_stats(entries)
  local total_seconds = 0
  local chill_seconds = 0

  for index = 1, #entries - 1 do
    local current = entries[index]
    local nxt = entries[index + 1]
    local delta = nxt.timestamp - current.timestamp

    if delta > 0 then
      total_seconds = total_seconds + delta
      if current.is_chill then
        chill_seconds = chill_seconds + delta
      end
    end
  end

  return {
    total_seconds = total_seconds,
    chill_seconds = chill_seconds,
  }
end

function M.calculate_tag_stats(entries)
  local total_seconds = 0
  local tag_seconds = {}

  for index = 1, #entries - 1 do
    local current = entries[index]
    local nxt = entries[index + 1]
    local delta = nxt.timestamp - current.timestamp

    if delta > 0 then
      total_seconds = total_seconds + delta

      if #current.tags > 0 then
        local share = delta / #current.tags
        for _, tag in ipairs(current.tags) do
          tag_seconds[tag] = (tag_seconds[tag] or 0) + share
        end
      end
    end
  end

  local items = {}
  for tag, seconds in pairs(tag_seconds) do
    items[#items + 1] = {
      tag = tag,
      seconds = seconds,
    }
  end

  table.sort(items, function(a, b)
    if a.seconds == b.seconds then
      return a.tag < b.tag
    end
    return a.seconds > b.seconds
  end)

  return {
    total_seconds = total_seconds,
    items = items,
  }
end

return M
