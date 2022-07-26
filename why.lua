
local why = {}

why.allowed = {}
local allowed = why.allowed
for c in ("#()[]{}char._G= "):gmatch'.' do
    allowed[c] = true
end

why.charFunc = "([[]])[([[char]])]"
local ZERO = "#_G"
local ONE = "#{{}}"

function why.smallint(n)
    if n == 0 or n == '0' then return ZERO end
    if n == 1 or n == '1' then return ONE end
    return "#[[" .. string.rep('.', n) .. "]]"
end

function why.int(n)
    n = tostring(math.floor(n))
    if #n == 1 then return why.smallint(n) end
    local outstr = {}
    for d in n:gmatch'.' do
        outstr[#outstr + 1] = why.smallint(d)
    end
    return '(' .. ZERO .. "+(" .. table.concat(outstr, "..") .. "))"
end

function why.toEvaluableString(str, level)
    level = string.rep('=', level or 1)
    local lb, rb = '[' .. level .. '[', ']' .. level .. ']'
    local members = {}
    local compound = {}
    for c in str:gmatch'.' do
        if allowed[c] then
            compound[#compound + 1] = c
        else
            if #compound > 0 then
                -- if we ended a compound string, append it to members
                members[#members + 1] = lb .. table.concat(compound, '') .. rb
                compound = {}
            end
            members[#members + 1] = why.charFunc .. '(' .. why.int(string.byte(c)) .. ')'
        end
    end
    if #compound > 0 then
        -- if we had a compound string, append it to members
        members[#members + 1] = lb .. table.concat(compound, '') .. rb
    end
    return '(' .. table.concat(members, ")..(") .. ')'
end

function why.getGlobal(name, lvl)
    return "_G[" .. why.toEvaluableString(name, lvl) .. ']'
end

function why.toProgram(code)
    return why.getGlobal("load") .. '(' .. why.toEvaluableString(code) .. ")()"
end

return why
