-- do you like french toast
local why = {}
local F = string.format
local ZERO = "#{}"
local ONE = "#{{}}"
local TRUE = "[[]]==[[]]"
local FALSE = "[[]]=={}"
local NIL = "({})[{}]" -- never actually used but cool i guess
local function int(n)
    if n == 0 or n == '0' then return ZERO end
    if n == 1 or n == '1' then return ONE end
    return F("#[[%s]]", ('.'):rep(n))
end
local function bigintstr(n)
    local nstr = tostring(n)
    local digits = {}
    for i = 1, #nstr do
        digits[#digits + 1] = int(nstr:sub(i, i))
    end
    return "((" .. table.concat(digits, ')..(') .. "))"
end
local function str2int(intstr)
    return F("(%s+%s)", ZERO, intstr)
end
local function int2str(intstr)
    return '(' .. intstr .. "..[[]])"
end
local function bigint(n)
    return str2int(bigintstr(n))
end
local map = {}
-- add allowed characters
for c in ("(){}[]=+.:#/typesubload' "):gmatch'.' do
    if c == "'" then c = "\\'" end
    map[c] = "'" .. c .. "'"
end
local string_byte = string.byte
local CHAR -- filled later
local function fromstring(str)
    local outstr = {}
    for c in str:gmatch'.' do
        outstr[#outstr + 1] = map[c] or F("%s(%s)", CHAR, bigint(string_byte(c)))
    end
    return table.concat(outstr, '..')
end
-- TODO: find best type and sub combinations
-- GOAL: get "string" (have: s, t)
map.r = F("type([[]]):sub(%s,%s)", int(3), int(3))
map.g = F("type([[]]):sub(%s,%s)", int(6), int(6))
local inf = int2str(ONE .. '/' .. ZERO)
map.i = F("%s:sub(%s,%s)", inf, ONE, ONE)
map.n = F("%s:sub(%s,%s)", inf, int(2), int(2))
-- ^ "string" achieved
-- GOAL: get "char" (can't, missing 'h')
-- GOAL: get "coroutine"
map.c = F("type(type):sub(%s,%s)", int(4), int(4))
map.t = F("type({}):sub(%s,%s)", ONE, ONE)
-- ^ "coroutine" achieved
-- GOAL: get "create" (achieved)
-- GOAL: get "return" (achieved)
-- GOAL: get 'h' for "char"
map.h = F("load(%s..' type('..%s..'.'..%s..'(type))')():sub(%s,%s)", fromstring("return"), fromstring("coroutine"), fromstring("create"), int(2), int(2))
CHAR = F("load(%s..' st'..%s..'.'..%s)()", fromstring("return"), fromstring("ring"), fromstring("char"))
-- ^ "char achieved"
-- bonus characters
map.f = F("%s:sub(%s,%s)", inf, int(3), int(3))
map.l = F("type({}):sub(%s,%s)", int(4), int(4))
local function program(code)
    return "load(" .. fromstring(code) .. ")()"
end
return {
    ZERO = ZERO,
    ONE = ONE,
    TRUE = TRUE,
    FALSE = FALSE,
    NIL = NIL,
    map = map,
    int = int,
    bigintstr = bigintstr,
    str2int = str2int,
    int2str = int2str,
    bigint = bigint,
    fromstring = fromstring,
    program = program
}
