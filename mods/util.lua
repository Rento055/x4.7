-- [[ Nyanko_x4.7 - Module(util) ]]
-- Source: https://github.com/Rento055/x4.7

-- ※モジュールの仕様を変更する場合、x4.7(正規版)の実行時にconf.luaの自動更新は行われません。
-- > 変更箇所が反映されない場合には「スクリプト設定」->「数値のデータ更新」を実行してください。

local menu = require("menu");
local util = {};

-- Config data management
util.data = {};

util.set_base_address = function()
    if base then
        return 0;
    end
    -- Retrieve lib file and time zone
    local lib = gg.getRangesList("libnative-lib.so:bss");
    local t = os.time();
    local time_zone = os.difftime(t, os.time(os.date("!*t", t)));
    baset = math.tointeger(time_zone);

    --Set base address
    if lib and lib[1] then
        gg.clearResults();
        gg.searchNumber(baset, 4, false, 536870912, lib[1].start, lib[1]["end"]);
        base = gg.getResults(1)[1].address;
    else
        gg.alert(table.concat({
            "ベースアドレスの取得に失敗しました。\nCb版apkを使用してください。", 
            "Failed to get base address.\nPlease use the Cb version apk."
        }, "\n\n"));
        return os.exit();
    end
end

util.update_values = function(self)
    for _, u in ipairs(self.data.menu_names) do
        for s, t in pairs(self.data[u.."_datas"]) do
            if menu.datas[t.key] and t.type == "number" and t.encrypt ~= false then
                t.value = decrypt(menu.datas[t.key]);
            end
        end
    end
end

-- util.conf_updateは実行時の更新処理のみ。
util.conf_update = function(self, _spec)
    util:set_base_address();

    -- 各項目の実行及びデータの新規保存、値の抽出
    self.data = menu:setup();

    -- Save config data
    gg.toast("Update completed");
    return gg.saveVariable(util.data, "/sdcard/catfood/conf.lua");
end

-- util.gen_menu(mnu_name)の返却値はutil[menu_name.."_datas"]に依存します。
util.gen_menu = function(self, menu_name)
    local datas = util.data[menu_name.."_datas"];
    local names, values, types = {}, {}, {};
    for i = 1, #datas do
        table.insert(names, datas[i].name or "noname");
        table.insert(types, datas[i].type or "checkbox");
        table.insert(values, datas[i].value);
    end
    return names, values, types;
end

util.exe = function(self, data, val)
    local value = menu[data.key](data.key, val);
    if data.type == "number" and data.encrypt ~= false then
        data.value = tostring(value);
    end
    -- gg.saveVariable(util.data, "/sdcard/catfood/conf.lua");
end

util.input_type = function(self)
    local datas = self.data;
    local checked = datas.basic_datas[1].type == "number" and 1 or 2;
    local mp2 = gg.choice({
        "シークバー(標準)/Seekbar", 
        "直接入力式/Direct Input"
    }, checked, "数値の入力形式を選択してください。\nSelect the input format of numeric data.");

    if mp2 == checked then
        return gg.toast("Cancelled");
    end

    local type = mp2 == 1 and "number" or "not_seek";
    local data = {};
    for _, s in ipairs(datas.menu_names) do
        for t = 1, #datas[s.."_datas"] do
            data = datas[s.."_datas"][t];
            if data.type == "number" or data.type == "not_seek"then
                data.type = type;
            end
        end
    end
    gg.toast("Completed");
end

util.data_link = function(self)

end

return util;
