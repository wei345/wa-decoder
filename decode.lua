function decode(input_string, lib_path)
    -- libs
    dofile(lib_path .. "/wowhelpers.lua" )
    dofile(lib_path .. "/LibStub/LibStub.lua")
    dofile(lib_path .. "/LibDeflate/LibDeflate.lua")
    dofile(lib_path .. "/LibSerialize/LibSerialize.lua")
    local LibDeflate = LibStub:GetLibrary("LibDeflate")
    local LibSerialize = LibStub("LibSerialize")
    local JSON = dofile(lib_path .. "/json.lua")

    -- execution
    if type(input_string) ~= "string" then
      return('invalid string type')
    end
    local strlen = #input_string
    if strlen == 1 then
      return('invalid string len')
    end
    local _, _, encodeVersion, encoded = input_string:find("^(!WA:%d+!)(.+)$")

    if encodeVersion then
        encodeVersion = tonumber(encodeVersion:match("%d+"))
    else
        encoded, encodeVersion = input_string:gsub("^%!", "")
    end
        
    if encodeVersion < 2 then
      return('unsupported wa version')
    end
    
    local decoded = LibDeflate:DecodeForPrint(encoded)

    local decompressed, errorMsg
    if decoded then
      decompressed = LibDeflate:DecompressDeflate(decoded)
    else
      return('failed to decode')
    end

    if not (decompressed) then
      return('failed to decompress')
    end

    local success, deserialized = LibSerialize:Deserialize(decompressed)

    if not (success) then
      return('deserialization failed')
    end
    local json = JSON:encode(deserialized)
    print(json)
    return json
end

function readAll(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    f:close()
    return content
end

local params = {...}
decode(readAll(params[1]), './libs')