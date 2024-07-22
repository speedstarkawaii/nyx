local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local b64 = {}
for i = 1, #b64chars do
    b64[i - 1] = b64chars:sub(i, i)
    b64[b64chars:sub(i, i)] = i - 1
end

function base64_encode(data)
    local result = {}
    local padding = 2 - ((#data - 1) % 3)
    data = data .. string.rep('\0', padding)
    
    for i = 1, #data, 3 do
        local n = (data:byte(i) << 16) + (data:byte(i + 1) << 8) + data:byte(i + 2)
        result[#result + 1] = b64[(n >> 18) & 63]
        result[#result + 1] = b64[(n >> 12) & 63]
        result[#result + 1] = b64[(n >> 6) & 63]
        result[#result + 1] = b64[n & 63]
    end
    
    return table.concat(result):sub(1, #result - padding) .. string.rep('=', padding)
end

function base64_decode(data)
    data = data:gsub('[^' .. b64chars .. '=]', '')
    local padding = #data % 4
    data = data .. string.rep('A', padding)
    
    local result = {}
    
    for i = 1, #data, 4 do
        local n = (b64[data:sub(i, i)] << 18) + (b64[data:sub(i + 1, i + 1)] << 12) + (b64[data:sub(i + 2, i + 2)] << 6) + b64[data:sub(i + 3, i + 3)]
        result[#result + 1] = string.char((n >> 16) & 255)
        result[#result + 1] = string.char((n >> 8) & 255)
        result[#result + 1] = string.char(n & 255)
    end
    
    return table.concat(result):sub(1, #result - padding)
end
