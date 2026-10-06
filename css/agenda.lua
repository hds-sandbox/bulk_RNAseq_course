-- Turn markdown tables inside a `::: {.agenda}` block into a timeline.
-- Columns: Time | Session | Type (lecture, exercise, discussion or break)

local function cell_inlines(cell)
  local blocks = cell.contents
  if #blocks > 0 and blocks[1].content then
    return blocks[1].content
  end
  return {}
end

local function agenda_items(tbl)
  local items = {}
  for _, body in ipairs(tbl.bodies) do
    for _, row in ipairs(body.body) do
      local time = pandoc.utils.stringify(row.cells[1].contents)
      local kind = pandoc.utils.stringify(row.cells[3].contents):lower()
      local inlines = {
        pandoc.Span(time, { class = "agenda-time" }),
        pandoc.Space(),
        pandoc.Span(cell_inlines(row.cells[2]), { class = "agenda-title" }),
      }
      table.insert(items, pandoc.Div(pandoc.Para(inlines), { class = "agenda-item " .. kind }))
    end
  end
  return items
end

function Div(div)
  if not div.classes:includes("agenda") then
    return nil
  end
  local content = {}
  for _, block in ipairs(div.content) do
    if block.t == "Table" then
      for _, item in ipairs(agenda_items(block)) do
        table.insert(content, item)
      end
    else
      table.insert(content, block)
    end
  end
  div.content = content
  return div
end
