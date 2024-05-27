function Div(div)
  -- process exercise
  if div.classes:includes("callout-exercise") then
    -- default title
    local title = "Exercise"
    -- Use first element of div as title if this is a header
    if div.content[1] ~= nil and div.content[1].t == "Header" then
      title = pandoc.utils.stringify(div.content[1])
      div.content:remove(1)
    end
    -- return a callout instead of the Div
    return quarto.Callout({
      type = "exercise",
      content = { pandoc.Div(div) },
      title = title,
      collapse = false
    })
  end

  -- process hint
  if div.classes:includes("callout-solution") then
    -- default title
    local title = "Solution"
    -- return a callout instead of the Div
    return quarto.Callout({
      type = "solution",
      content = { pandoc.Div(div) },
      title = title,
      collapse = true
    })
  end

-- process definition
  if div.classes:includes("callout-definition") then
    -- default title
    local title = "definition"
    -- Use first element of div as title if this is a header
    if div.content[1] ~= nil and div.content[1].t == "Header" then
      title = pandoc.utils.stringify(div.content[1]) 
      div.content:remove(1)
    end
    -- return a callout instead of the Div
    return quarto.Callout({
      type = "definition",
      content = { pandoc.Div(div) },
      title = title,
      collapse = true
    })
  end


-- process definition
if div.classes:includes("callout-readme") then
  -- default title
  local title = "README"
  -- return a callout instead of the Div
  return quarto.Callout({
    type = "readme",
    content = { pandoc.Div(div) },
    title = title,
  })
end


end