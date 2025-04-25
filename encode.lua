function encode(input_string, lib_path)
    -- libs
    dofile(lib_path .. "/wowhelpers.lua")
    dofile(lib_path .. "/LibStub/LibStub.lua")
    dofile(lib_path .. "/LibDeflate/LibDeflate.lua")
    dofile(lib_path .. "/LibSerialize/LibSerialize.lua")
    local LibDeflate = LibStub:GetLibrary("LibDeflate")
    local LibSerialize = LibStub("LibSerialize")
    local JSON = dofile(lib_path .. "/json.lua")

    -- execution
    local luatable = JSON:decode(input_string)
    -- local t = luatable
    if not luatable then
        return ('failed to decode JSON to lua table')
    end
    function fixNumericIndexes(tbl)
        local fixed = {}
        for k, v in pairs(tbl) do
            if tonumber(k) and tonumber(k) > 0 then
                fixed[tonumber(k)] = v
            else
                fixed[k] = v
            end
        end
        return fixed
    end
    -- fixes tables; the lua-json process can break these
    function fixWATables(t)
        if t.triggers then
            t.triggers = fixNumericIndexes(t.triggers)
            for n in ipairs(t.triggers) do
                if t.triggers[n].trigger and type(t.triggers[n].trigger.form) ==
                    "table" and t.triggers[n].trigger.form.multi then
                    t.triggers[n].trigger.form.multi = fixNumericIndexes(
                                                           t.triggers[n].trigger
                                                               .form.multi)
                end

                if t.triggers[n].trigger and t.triggers[n].trigger.talent and
                    t.triggers[n].trigger.talent.multi then
                    t.triggers[n].trigger.talent.multi = fixNumericIndexes(
                                                             t.triggers[n]
                                                                 .trigger.talent
                                                                 .multi)
                end

                if t.triggers[n].trigger and t.triggers[n].trigger.specId and
                    t.triggers[n].trigger.specId.multi then
                    t.triggers[n].trigger.specId.multi = fixNumericIndexes(
                                                             t.triggers[n]
                                                                 .trigger.specId
                                                                 .multi)
                end

                if t.triggers[n].trigger and t.triggers[n].trigger.herotalent and
                    t.triggers[n].trigger.herotalent.multi then
                    t.triggers[n].trigger.herotalent.multi = fixNumericIndexes(
                                                                 t.triggers[n]
                                                                     .trigger
                                                                     .herotalent
                                                                     .multi)
                end

                if t.triggers[n].trigger and t.triggers[n].trigger.actualSpec then
                    t.triggers[n].trigger.actualSpec = fixNumericIndexes(
                                                           t.triggers[n].trigger
                                                               .actualSpec)
                end

                if t.triggers[n].trigger and t.triggers[n].trigger.arena_spec then
                    t.triggers[n].trigger.arena_spec = fixNumericIndexes(
                                                           t.triggers[n].trigger
                                                               .arena_spec)
                end
            end
        end

        if t.load and t.load.talent and t.load.talent.multi then
            t.load.talent.multi = fixNumericIndexes(t.load.talent.multi)
        end
        if t.load and t.load.talent2 and t.load.talent2.multi then
            t.load.talent2.multi = fixNumericIndexes(t.load.talent2.multi)
        end
        if t.load and t.load.talent3 and t.load.talent3.multi then
            t.load.talent3.multi = fixNumericIndexes(t.load.talent3.multi)
        end
        if t.load and t.load.herotalent and t.load.herotalent.multi then
            t.load.herotalent.multi = fixNumericIndexes(t.load.herotalent.multi)
        end

        if t.load and t.load.class_and_spec and t.load.class_and_spec.multi then
            t.load.class_and_spec.multi =
                fixNumericIndexes(t.load.class_and_spec.multi)
        end

        return t
    end

    if luatable.d then
        luatable.d = fixWATables(luatable.d)
    end
    if luatable.c then
        for i = 1, #luatable.c do
            if luatable.c[i] then luatable.c[i] = fixWATables(luatable.c[i]) end
        end
    end

    local configForLS = {
      errorOnUnserializableType =  false
    }
    local serialized = LibSerialize:SerializeEx(configForLS, luatable)
    local compressed
    local configForDeflate = {level = 9}
    compressed = LibDeflate:CompressDeflate(serialized, configForDeflate)
    local encoded = "!WA:2!"
    encoded = encoded .. LibDeflate:EncodeForPrint(compressed)
    print(encoded)
    return encoded
end

function readAll(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    f:close()
    return content
end

local params = {...}
encode(readAll(params[1]), './libs')