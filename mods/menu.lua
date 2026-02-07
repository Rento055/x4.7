-- [[ Nyanko_x4.7 - Module(menu) ]]
-- Source: https://github.com/Rento055/x4.7

-- ※モジュールの仕様を変更する場合、x4.7(正規版)の実行時にconf.luaの自動更新は行われません。
-- > 変更箇所が反映されない場合には「スクリプト設定」->「数値のデータ更新」を実行してください。

local menu = {
    version = gg.getTargetInfo().versionName:gsub("%.", "_");
    path = "/sdcard/catfood/datas/?.lua", 
    datas = {}
};

menu.load_data = function(self)
    if not package.searchpath(self.version, self.path) then
        gg.toast("更新開始");
        menu:setup();
    end

    -- 数値更新
    local v = dofile(self.path:gsub("?", self.version));
    for s, t in pairs(v) do
        if s == "base" then goto continue;end
        for i = 1, #t do
            t[i].address = t[i].address - v.base + base;
        end
        self.datas[s] = gg.getValues(t);
        ::continue::
    end
    self.datas.base = base;
end

menu.setup = function(self)
    local new_conf = {
        ["version"] = gg.getTargetInfo().versionName, 
        ["menu_names"] = {"basic", "option"}, 
    };
    local datas = {{
        -- Basic menu
        [1] = {name = "ネコ缶 [0;58999]", type = "number", value = "58000", key = "catfood"}, 
        [2] = {name = "XP [0;999999999]", type = "number", value = "777777777", key = "xp"}, 
        [3] = {name = "通常チケット [0;999]", type = "number", value = "200", key = "noarmal_ticket"}, 
        [4] = {name = "レアチケット [0;999]", type = "number", value = "200", key = "rare_ticket"}, 
        [5] = {name = "全ステージ開放", type = "checkbox", value = false,  key = "stage_flag"}, 
        [6] = {name = "戻る", type = "checkbox", value = false, key = "callmain"}
    }, {
        -- Option menu
        [1] = {name = "全キャラ開放", type = "checkbox", value = false, key = "char_flag"}, 
        [2] = {name = "全キャラレベル", type = "number", value = "0+0", key = "char_level"}, 
        [3] = {name = "全キャラ形態", type = "checkbox", value = false, key = "on_off"}, 
        [4] = {name = "全キャラ形態 [0;5]", type = "number", value = "2", key = "char_form"}, 
        [5] = {name = "指定キャラまとめ", type = "checkbox", value = false, key = "char_des"}, 
        [6] = {name = "お宝解放", type = "checkbox", value = false, key = "treasure"}, 
        [7] = {name = "NP", type = "checkbox", value = false, key = "on_off"}, 
        [8] = {name = "NP [0;99999]", type = "number", value = "2000", key = "np"}, 
        [9] = {name = "アイテム", type = "checkbox", value = false, key = "on_off"}, 
        [10] = {name = "アイテム [0;99999]", type = "number", value = "120", key = "items"}, 
        [11] = {name = "キャッツアイ", type = "checkbox", value = false, key = "on_off"}, 
        [12] = {name = "キャッツアイ [0;999]", type = "number", value = "30", key = "catseye"}, 
        [13] = {name = "ネコビタン", type = "checkbox", value = false, key = "on_off"}, 
        [14] = {name = "ネコビタン [0;999]", type = "number", value = "60", key = "catvitan"}, 
        [15] = {name = "戻る", type = "checkbox", value = false, key = "callmain"}
    }};

    -- データ挿入
    for i = 1, #datas do
        for s, t in ipairs(datas[i]) do
            t.value = t.type == "number" and self[t.key.."_b"](t.key);
        end
    end

    -- データ結合
    for s, t in ipairs(new_conf.menu_names) do
        new_conf[t.."_datas"] = datas[s];
    end

    -- データ保存
    self.datas.base = base;
    local save_path = self.path:gsub("?", self.version);
    gg.saveVariable(self.datas, save_path);

    return new_conf;
end

function decrypt(vals)
    local sum = 0;
    local v1 = vals[1].value + (vals[1].value < 0 and 2^32 or 0);
    local v2 = vals[2].value + (vals[2].value < 0 and 2^32 or 0);
    for i = 24, 0, -8 do
        local x1, x2 = math.floor(v1/2^(i)), v2%2^8;
        v1, v2 = v1%2^i, math.floor(v2/2^8);
        x1 = math.tointeger(x1 - (2^7 <= x1 and 2^8 or 0));
        x2 = math.tointeger(x2 - (2^7 <= x2 and 2^8 or 0));
        local xor = x1 ~ x2;
        sum = sum + (xor + (xor < 0 and 2^8 or 0))*2^i;
    end
    return sum;
end

local function encrypt(num)
    num = tonumber(num);
    local v2 = math.random(2^29) + (num/2^30 == 0 and 2^30 or 0);
    local v1 = decrypt({{["value"] = num}, {["value"] = v2}});
    v1 = v1 - (2^31 <= v1 and 2^32 or 0);
    return (2^31 <= v1 and v1 - 2^32 or v1), v2;
end

-- n > 0
local function gen_search_group(n)
    local min, max = -256, 256;
    local rand = ("%d~~%d;"):format(min, max):rep(n);
    return ("0;%s0::%d"):format(rand, 4*n + 5);
end

-- Search address
menu.catfood_b = function(key)
    gg.clearResults();
    gg.searchNumber(gen_search_group(2), 4, false, 536870912, base-0x200, base);
    gg.refineNumber("-256~~256", 4);
    local res = gg.getResults(2);
    menu.datas[key] = res;
    return decrypt(res);
end

-- Return value
menu.catfood = function(key, val)
    local t = menu.datas[key];
    menu.datas[key] = gg.getValues(menu.datas[key]);
    if not val then
        return decrypt(t);
    end
    t[1].name, t[2].name = "ネコ缶", "ネコ缶0";
    t[1].freeze, t[2].freeze = true, true;
    t[1].value, t[2].value = encrypt(val);
    gg.addListItems(t);
    gg.toast("猫缶成功");
    return decrypt(t);
end

menu.xp_b = function(key)

    return 100;
end

menu.xp = function(key, val)

    return 100;
end

menu.noarmal_ticket_b = function(key)

    return 100;
end

menu.noarmal_ticket = function(key, val)

    return 100;
end

menu.rare_ticket_b = function(key)

    return 100;
end

menu.rare_ticket = function(key, val)

    return 100;
end

menu.stage_flag_b = function(key)

    return 100;
end

menu.stage_flag = function(key, val)

    return 100;
end

menu.char_flag_b = function(key)

    return 100;
end

menu.char_flag = function(key, val)

    return 100;
end

menu.char_level_b = function(key)

    return 100;
end

menu.char_level = function(key, val)

    return 100;
end

menu.char_form_b = function(key)

    return 100;
end

menu.char_form = function(key, val)

    return 100;
end

menu.char_des_b = function(key)

    return 100;
end

menu.char_des = function(key, val)

    return 100;
end

menu.treasure_b = function(key)

    return 100;
end

menu.treasure = function(key, val)

    return 100;
end

menu.np_b = function(key)

    return 100;
end

menu.np = function(key, val)

    return 100;
end

menu.items_b = function(key)

    return 100;
end

menu.items = function(key, val)

    return 100;
end

menu.catseye_b = function(key)

    return 100;
end

menu.catseye = function(key, val)

    return 100;
end

menu.catvitan_b = function(key)

    return 100;
end

menu.catvitan = function(key, val)

    return 100;
end

-- menu.on_off = function()
--     return false;
-- end

menu.on_off_b = function()
    return false;
end

menu.callmain_b = function()
    return false;
end

menu.callmain = function()
    return main();
end

return menu;
