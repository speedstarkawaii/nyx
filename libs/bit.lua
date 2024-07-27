-- bit library 
local bit = {}

function bit.bdiv(dividend, divisor)
    return math.floor(dividend / divisor)
end

function bit.badd(a, b)
    return (a + b) & 0xFFFFFFFF
end

function bit.bsub(a, b)
    return (a - b) & 0xFFFFFFFF
end

function bit.band(val, by)
    return val & by
end

function bit.bor(val, by)
    return val | by
end

function bit.bxor(val, by)
    return val ~ by
end

function bit.bnot(val)
    return ~val & 0xFFFFFFFF
end

function bit.bmul(val, by)
    return (val * by) & 0xFFFFFFFF
end

function bit.bswap(val)
    return ((val * 0x00000001) & 0xFF) * 0x1000000 |
           ((val * 0x00000100) & 0xFF) * 0x10000 |
           ((val * 0x00010000) & 0xFF) * 0x100 |
           ((val * 0x01000000) & 0xFF)
end

function bit.ror(val, by)
    local shift = by % 32
    return ((val * 2 ^ (32 - shift)) & 0xFFFFFFFF) | (val // 2 ^ shift)
end

function bit.rol(value, shiftCount)
    local shift = shiftCount % 32
    return ((value * 2 ^ shift) & 0xFFFFFFFF) | (value // 2 ^ (32 - shift))
end

function bit.tohex(val)
    return string.format("%08X", val)
end

function bit.tobit(val)
    return val & 0xFFFFFFFF
end

function bit.lshift(val, by)
    return (val * 2 ^ by) & 0xFFFFFFFF
end

function bit.rshift(val, by)
    return math.floor(val / 2 ^ by)
end

function bit.arshift(value, shiftCount)
    local mask = 0x80000000
    for i = 1, shiftCount do
        value = (value // 2) | (value & mask)
    end
    return value
end

return bit
