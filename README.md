# WeakAuras String Decoder and Encoder

Based on encode/decode functions of WeakAuras2 and python-weakauras-tool

* https://github.com/WeakAuras/WeakAuras2/blob/main/WeakAuras/Transmission.lua#L270
* https://github.com/WeakAuras/WeakAuras2/blob/main/WeakAuras/Transmission.lua#L299
* https://github.com/geexmmo/python-weakauras-tool

WeakAura strings version 2 are supported.

Only Lua environment is required, no need of Python.

## 1. Preparing Lua Environment (on macOS 15)

```bash
# The current version of Lua, which is 5.4.4, is needed for installing luarocks via brew.
brew install --build-from-source lua

# luarocks is needed to install luabitop which is required in libs/wowhelpers.lua.
brew install --build-from-source luarocks

# lua@5.1 is needed for luabitop which is not compatible with the current version of Lua.
brew install --build-from-source lua@5.1

# luabitop which is required in libs/wowhelpers.lua.
luarocks --lua-dir=/usr/local/opt/lua@5.1 install luabitop
# output:
# luabitop 1.0.2-3 depends on lua >= 5.1, < 5.3 (5.1-1 provided by VM)
# luabitop 1.0.2-3 is now installed in ~/.luarocks (license: MIT/X license)

# By default, bit.so is located in ~/.luarocks, which can not be found.
cp ~/.luarocks/lib/lua/5.1/bit.so .
```

## 2. Decoder

```bash
lua-5.1 decode.lua example-exported.txt
```

The process in the decode.lua

1. the file content
2. -> WeakAuras version and encoded string
3. -> the compressed data
4. -> the serialized data
5. -> a Lua table
6. -> a JSON string

## 3. Encoder

```bash
lua-5.1 encode.lua example-decoded.json
```

The process in the encode.lua

1. the file content (a JSON string)
2. -> a Lua table
3. -> serialized data
4. -> compressed data
5. -> "!WA:2!" + encoded string