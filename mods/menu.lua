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
    gg.toast("Updating config data...");
    local new_conf = {
        ["version"] = gg.getTargetInfo().versionName, 
        ["menu_names"] = {"basic", "option"}, 
    };
    local datas = {{
        -- Basic menu
        [1] = {name = "ネコ缶(Catfood) [0;58999]", type = "number", value = "58000", key = "catfood"}, 
        [2] = {name = "XP [0;99999999]", type = "number", value = "777777777", key = "xp"}, 
        [3] = {name = "通常チケット(Normal Ticket) [0;999]", type = "number", value = "200", key = "normal_ticket"}, 
        [4] = {name = "レアチケット(Rare Ticket) [0;999]", type = "number", value = "200", key = "rare_ticket"}, 
        [5] = {name = "即勝利(Instant Win)", type = "checkbox", value = false, key = "win"},
        [6] = {name = "全ステージ開放(Unlock All Stages)", type = "checkbox", value = false,  key = "stage_flag"}, 
        [7] = {name = "戻る(Back)", type = "checkbox", value = false, key = "callmain"}
    }, {
        -- Option menu
        [1] = {name = "全キャラ開放(Unlock All Characters)", type = "checkbox", value = false, key = "char_flag"}, 
        [2] = {name = "全キャラレベル(All Characters Level)\n+値は数値の前に+を記入(例: 20+10)\nInput Example: 20+10", type = "number", value = "", key = "char_level", encrypt = false}, 
        [3] = {name = "全キャラ形態(All Characters Form) [0;5]", type = "number", value = "2", key = "char_form", encrypt = false}, 
        [4] = {name = "指定キャラまとめ(Selecta Characters)", type = "checkbox", value = false, key = "char_des"}, 
        [5] = {name = "エラキャラ削除(Remove Error Characters)", type = "checkbox", value = false, key = "char_delete"}, 
        [6] = {name = "お宝解放(Unlock Treasures)", type = "checkbox", value = false, key = "treasure"}, 
        [7] = {name = "施設レベル(Facility Level)\n+値は数値の前に+を記入(例: 20+10)\nInput Example: 20+10", type = "number", value = "", key = "facility_level", encrypt = false}, 
        [8] = {name = "NP", type = "checkbox", value = false, key = "on_off"}, 
        [9] = {name = "NP [0;99999]", type = "number", value = "2000", key = "np"}, 
        [10] = {name = "アイテム(Items)", type = "checkbox", value = false, key = "on_off"}, 
        [11] = {name = "アイテム(Items) [0;9999]", type = "number", value = "120", key = "items", encrypt = false}, 
        [12] = {name = "キャッツアイ(Catseye)", type = "checkbox", value = false, key = "on_off"}, 
        [13] = {name = "キャッツアイ(Catseye) [0;999]", type = "number", value = "30", key = "catseye", encrypt = false}, 
        [14] = {name = "ネコビタン(Catvitan)", type = "checkbox", value = false, key = "on_off"}, 
        [15] = {name = "ネコビタン(Catvitan) [0;999]", type = "number", value = "60", key = "catvitan", encrypt = false}, 
        [16] = {name = "城の素材(Castle Materials)", type = "checkbox", value = false, key = "on_off"}, 
        [17] = {name = "城の素材(Castle Materials) [0;999]", type = "number", value = "120", key = "castle_material", encrypt = false}, 
        [18] = {name = "広告非表示(Hide Ads)", type = "checkbox", value = false, key = "no_ads"},
        [19] = {name = "戻る(Back)", type = "checkbox", value = false, key = "callmain"}
    }};

    -- データ挿入
    for i = 1, #datas do
        for s, t in ipairs(datas[i]) do
            -- t.value = t.type == "number" and self[t.key.."_b"](t.key);
            t.value = self[t.key.."_b"](t.key) or t.value;
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

function encrypt(num)
    num = tonumber(num);
    local v2 = math.random(2^29) + (num/2^30 == 0 and 2^30 or 0);
    local v1 = decrypt({{["value"] = num}, {["value"] = v2}});
    v1 = v1 - (2^31 <= v1 and 2^32 or 0);
    return (2^31 <= v1 and v1 - 2^32 or v1), v2;
end

-- n > 0
local function gen_search_group(n)
    local min, max = -256, 256;
    local flag = ("%d~%d"):format(min, max);
    local rand = ("%d~~%d;"):format(min, max):rep(n);
    return ("%s;%s%s::%d"):format(flag, rand, flag, 4*n + 5);
end

local function val_edit(key, val, name)
    local t = menu.datas[key];
    menu.datas[key] = gg.getValues(menu.datas[key]);
    if not val then return decrypt(t); end
    t[1].name, t[2].name = name, name.."0";
    t[1].freeze, t[2].freeze = true, true;
    t[1].value, t[2].value = encrypt(val);
    gg.addListItems(t);
    return decrypt(menu.datas[key]);
end

local function edit_items(key, val, name)
    local res = menu.datas[key];
    local v = {encrypt(val)};
    for s, t in ipairs(res) do
        t.value = s%2 == 1 and v[1] or v[2];
        t.freeze = true;
        t.name = name..(s%2 == 1 and "" or "0");
    end
    gg.addListItems(res);
end

-- Search address
menu.catfood_b = function(key)
    gg.clearResults();
    gg.searchNumber(gen_search_group(2), 4, false, 536870912, base-0x300, base);
    gg.refineNumber("-256~~256", 4);
    local res = gg.getResults(2);
    menu.datas[key] = res;
    return decrypt(res);
end

-- Return value
menu.catfood = function(key, val)
    return val_edit(key, val, "ネコ缶(Catfood)");
end

menu.xp_b = function(key)
    gg.clearResults();
    gg.searchNumber(gen_search_group(4), 4, false, 536870912, base, base+0x100);
    gg.refineNumber("-256~~256", 4);
    menu.datas[key] = gg.getResults(2);
    menu.datas["np"] = gg.getResults(2, 2);
    return decrypt(menu.datas[key]);
end

menu.xp = function(key, val)
    return val_edit(key, val, "XP");
end

menu.normal_ticket_b = function(key)
    gg.clearResults();
    gg.searchNumber(baset, 4, false, 536870912, base+0x150000, base+0xffffff);
    local base2 = gg.getResults(2)[2].address;
    gg.clearResults();
    gg.searchNumber(gen_search_group(4), 4, false, 536870912, base2, base2+0xfff);
    gg.refineNumber("-256~~256", 4);
    menu.datas[key] = gg.getResults(2, gg.getResultsCount()-4);
    menu.datas["rare_ticket"] = gg.getResults(4, gg.getResultsCount()-2);
    return decrypt(menu.datas[key]);
end

menu.normal_ticket = function(key, val)
    return val_edit(key, val, "通常チケット(Normal Ticket)");
end

menu.rare_ticket_b = function(key)  --> normal_ticket_b
    return decrypt(menu.datas[key]);
end

menu.rare_ticket = function(key, val)
    return val_edit(key, val, "レアチケット(Rare Ticket)");
end

menu.win_b = function(key)
    return false;
end

menu.win = function(key, val)
    gg.clearResults();
    gg.searchNumber("3200;4400;1~2147483647::29", 4, false, 536870912, base, base+0xffffff);
    if gg.getResultsCount() < 4 then return gg.alert("試合中に実行してください。\n\nPlease run during a match.");end
    local res = gg.getResults(1, gg.getResultsCount()-1);
    gg.addListItems((function()
        res[1].freeze = true;
        res[1].value = 0;
        return res;
    end)());
    return false;
end

menu.stage_flag_b = function(key) -- array: ステ開始、ステ最後、全キャラ最後
    gg.clearResults();
    gg.searchNumber("-256~~255"..(";-256~~255"):rep(62)..";-256~255::253", 4, false, 536870912, base+0x512, base+0xfffff);
    gg.refineNumber("-256~~255;-256~255::5", 4);
    gg.refineNumber("-999999~~999999", 4);

    -- ステージ系
    local stage = gg.getResults(1);
    table.insert(stage, 1, table.unpack(gg.getValues({{
        address = stage[1].address - 1030*4, 
        flags = 4
    }})));
    menu.datas[key] = stage;

    -- キャラ系
    local char = gg.getResults(1, gg.getResultsCount()-2);
    gg.clearResults();
    gg.searchNumber("-256~256", 4, false, 536870912, char[1].address-0xffff, char[1].address);
    local res2 = gg.getResults(1, gg.getResultsCount()-1);
    local diff = char[1].address - res2[1].address;
    table.insert(char, 1, table.unpack(gg.getValues({{
        address = res2[1].address + (diff-4)%(3*4)+4, 
        flags = 4
    }})));
    menu.datas["char_flag"] = char;
    return false;   -- checkboxの初期値
end

menu.stage_flag = function(key, val)
    local res = menu.datas[key];
    gg.startFuzzy(4, res[1].address, res[2].address);
    gg.getResults(11);
    gg.editAll("304"..(";304"):rep(9)..";256", 4);
    gg.getResults(520, 11);
    gg.editAll("257"..(";257"):rep(47)..(";256"):rep(4), 4);    --差がクリア数
    return false;
end

menu.char_flag_b = function(key)
    return false;
end

menu.char_flag = function(key, val)
    local res = menu.datas[key];
    local diff = res[2].address - res[1].address;
    gg.startFuzzy(4, res[1].address, res[1].address + diff/3 - 4);
    local res2 = gg.getResults(gg.getResultsCount());
    gg.editAll(res2[1].value, 4);
    return false;
end

menu.char_level_b = function(key)    
    return false;
end

menu.char_level = function(key, val)    -- キャラ名あるといいね
    local res = menu.datas["char_flag"];
    local diff = res[2].address - res[1].address;
    -- gg.startFuzzy(4, res[2].address - 2*diff/3, res[2].address);
    local level, plus = val:match("^(%d*)%+?(%d*)$");
    level, plus = tonumber(level) or 0, tonumber(plus) or 0;
    local lp = (level > 0 and level-1 or 0)*65536 + plus;
    local v, res2 = {encrypt(lp)}, {};
    for i = res[2].address - 2*diff/3 + 4, res[2].address - 8, 8 do
        res2[#res2+1] = {address = i, flags = 4, freeze = true, name="キャラレベル(Characters Level)", value = v[1]};
        res2[#res2+1] = {address = i+4, flags = 4, freeze = true, name="キャラレベル0(Characters Level 0)", value = v[2]};
    end
    gg.addListItems(res2);
    return false;
end

menu.char_form_b = function(key)
    return 0;
end

menu.char_form = function(key, val)     -- レベル調整した方が安全
    local res = menu.datas["char_flag"];
    local diff = res[2].address - res[1].address;
    gg.toast("最大形態を取得します");
    local info = gg.makeRequest("https://battlecats-db.com/unit/frm_final.html").content or "";
    local i, res2 = 1, {};
    for addr = res[2].address + 4, res[2].address + diff/3 - 4, 4 do
        local n = info:match("<td>"..("%03d"):format(i).."%-([0-6])</td>");
        val, n = tonumber(val), tonumber(n) or 100;
        if val then
            n = val < n and val or n;
            res2[#res2+1] = {address = addr, flags = 4, name="キャラ形態(Characters Form)", value = n - 1};
        end
        i = i + 1;
    end
    gg.setValues(res2);
    return 0;
end

menu.char_des_b = function(key)     -- 指定キャラ
    return false;
end

menu.char_des = function(key, val)
    dofile(path.."ext/Designate_Char.lua");
    return false;
end

menu.char_delete_b = function(key)  -- エラキャラ削除
    return false;
end

menu.char_delete = function(key, val)
    local res = menu.datas["char_flag"];
    local diff = res[2].address - res[1].address;
    local e, res2 = gg.getValues({{address = res[1].address + diff/3, flags = 4}}), {};
    local info = gg.makeRequest("https://battlecats-db.com/unit/r_all.html").content or "";
    for i = 1, diff/12 do
        if not info:find("<td>"..("%03d"):format(i).."</td>") or i == 674 then
            res2[#res2+1] = {address = res[1].address + (i-1)*4, flags = 4, value = e[1].value};
        end
    end
    gg.setValues(res2);
    return false;
end

menu.treasure_b = function(key)
    return false;
end

menu.treasure = function(key, val)
    local res = menu.datas["stage_flag"];
    gg.startFuzzy(4, res[2].address - 500*4 + 4, res[2].address);
    local i, res2 = 0, {};
    for addr = res[2].address - 500*4 + 4, res[2].address, 4 do
        res2[i] = {address = addr, flags = 4, name = "宝箱(Treasure)", value = i%50 > 47 and 259 or 256};
        i = i + 1;
    end
    gg.setValues(res2);
    return false;
end

menu.facility_level_b = function(key)
    gg.clearResults();
    gg.searchNumber(gen_search_group(22), 4, false, 536870912, base, base+0xfffff);
    gg.refineNumber("-256~~256", 4);
    menu.datas[key] = gg.getResults(22);
    return false;
end

menu.facility_level = function(key, val)
    local level, plus = val:match("^(%d*)%+?(%d*)$");
    level, plus = tonumber(level) or 0, tonumber(plus) or 0;
    if level > 20 then level = 20; end  -- レベル上限
    if plus > 10 then plus = 10; end    -- レベル上限
    local lp = (level > 0 and level-1 or 0)*65536 + plus;
    edit_items(key, lp, "施設レベル(Facility Level)");
    return false;
end

menu.np_b = function(key)   --> XP
    return decrypt(menu.datas[key]);
end

menu.np = function(key, val)
    return val_edit(key, val, "NP");
end

menu.items_b = function(key)
    gg.clearResults();
    gg.searchNumber(gen_search_group(12), 4, false, 536870912, base+0x2000, base+0x4ffff);
    gg.refineNumber("-256~~256", 4);
    menu.datas[key] = gg.getResults(12);
    return false;
end

menu.items = function(key, val)
    edit_items(key, val, "アイテム(Items)");
    return false;
end

menu.catseye_b = function(key)
    gg.clearResults();
    gg.searchNumber("h E3 00 00 00 EB 00 00 00", 1, false, 536870912, base, base+0xffffff);
    local base2 = gg.getResults(1, gg.getResultsCount() - 2)[1].address;
    gg.clearResults();
    gg.searchNumber("-256~~256;0", 4, false, 536870912, base2, base2 + 50*4 + 4, 1);
    menu.datas["catseye"] = gg.getResults(12);              -- キャッツアイ
    menu.datas["catvitan"] = gg.getResults(6, 12);          -- ネコビタン
    menu.datas["castle_material"] = gg.getResults(18, 18);  -- 城の素材
    return false;
end

menu.catseye = function(key, val)
    edit_items(key, val, "キャッツアイ(Catseye)");
    return false;
end

menu.catvitan_b = function(key)         --> catseye_b
    return false;
end

menu.catvitan = function(key, val)
    edit_items(key, val, "ネコビタン(Catvitan)");
    return false;
end

menu.castle_material_b = function(key)  --> catseye_b
    return false;
end

menu.castle_material = function(key, val)
    edit_items(key, val, "城の素材(Castle Materials)");
    return false;
end

menu.no_ads_b = function(key)
    gg.clearResults();
    gg.searchNumber("h 4B 1F 00 00 70 42 00 00", 1);
    gg.refineNumber("h4b", 1);
    menu.datas[key] = gg.getResults(gg.getResultsCount());
    return false;
end

menu.no_ads = function(key, val)
    local res = menu.datas[key];
    for i, v in ipairs(res) do
        gg.clearResults();
        gg.searchNumber("-1~101", 4, false, 536870912, v.address-0x2c, v.address);
        gg.refineNumber("-1~~101", 4);
        gg.addListItems({{
            address = gg.getResults(1, gg.getResultsCount()-1)[1].address, 
            flags = 4, 
            name = "広告非表示(No Ads) "..1, 
            freeze = true, 
            value = -1
        }, {
            address = gg.getResults(1, gg.getResultsCount()-1)[1].address+4, 
            flags = 4, 
            name = "広告非表示(No Ads) "..1, 
            freeze = true, 
            value = 0
        }});
    end
    return false;
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
