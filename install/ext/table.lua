--- @author: Josélio Júnior <joseliojrx25@gmail.com>
--- @copyright: Josélio Júnior 2022
--- @license: MIT

-- MIT License

-- Copyright (c) 2022 Josélio Júnior

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

require 'ext.dependencies.short-methods'
require 'ext.dependencies.errors'
require 'ext.dependencies.array-funs'

function table.slice(list, i, j)
  if type(list) ~= 'table' then
    return error(err.EMPTY_OR_NOT_TABLE)
  end
  i = (i == nil or i == 0) and 1 or i
  j = (j == nil or j == 0) and #list or j
  if i < 0 then
    i = #list + i + 1
  elseif i < 0 and j < 0 then
    i = #list + i + 1
    j = #list + j + 1
  end
  return pack(unpack(list, i, j))
end

function table.reduce(list, operator)
  if type(list) == 'table' and #list <= 0 then
    return error(err.EMPTY_OR_NOT_TABLE)
  elseif type(list) ~= 'table' then
    return error(err.NOT_TABLE)
  elseif operator == nil then
    return error(err.WRONG_OPERATOR)
  elseif array.every({ '+', '-', '*', '/', '//', '%', '^' },
    function(e) return e ~= operator end) then
    return nil
  end
  local t = list
  for i = 1, #t do
    if type(t[i]) == 'nil' then return nil end
    if not tonumber(t[i]) and type(t[i]) ~= 'boolean' then
      return 0 / 0
    end
  end
  local function b(x)
    return x == true and 1 or x == false and 0 or x
  end

  local r = t[1]
  local k = pack(unpack(t, 2))
  if operator == '+' then
    for _, e in ipairs(k) do r = b(r) + b(e) end
  elseif operator == '-' then
    for _, e in ipairs(k) do r = b(r) - b(e) end
  elseif operator == '*' then
    for _, e in ipairs(k) do r = b(r) * b(e) end
  elseif operator == '/' then
    for _, e in ipairs(k) do r = b(r) / b(e) end
  elseif operator == '//' then
    for _, e in ipairs(k) do r = math.floor(b(r) / b(e)) end
  elseif operator == '^' then
    for _, e in ipairs(k) do r = b(r) ^ b(e) end
  elseif operator == '%' then
    for _, e in ipairs(k) do
      if b(e) == 0 then
        return 0 / 0
      else
        r = b(r) % b(e)
      end
    end
  end
  return r
end

function table.reverse(list)
  if type(list) ~= 'table' then return {} end
  local t = list
  for i = 1, #t do
    if type(t[i]) == 'nil' then return t end
  end
  for i = #t, 1, -1 do
    push(t, t[i])
    remove(t, i)
  end
  return t
end
