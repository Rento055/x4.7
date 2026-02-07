-- [[ Nyanko_x4.7 - Module(menu) ]]
-- Source: https://github.com/Rento055/x4.7

-- ※モジュールの仕様を変更する場合(特に既存プログラム)、x4.7(正規版)の実行時にconf.luaの自動更新は行われません。
-- > 変更箇所を反映するには「スクリプト設定」->「数値のデータ更新」を実行してください。

local menu = {
    version = gg.getTargetInfo().versionName;
    path = "/sdcard/catfood/datas/?.lua", 
    datas = {}
};

menu.load_data = function(self)
    if not package.searchpath(self.version, self.path) then
        menu:setup();
    else
        self.datas = dofile(self.path:gsub("?", self.version));
    end
end

menu.setup = function(self)
    local new_conf = {
        ["version"] = self.version, 
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
            self[t.key.."_b"]();
            t.value = t.type == "number" and self[t.key]();
        end
    end

    -- データ結合
    for s, t in ipairs(new_conf.menu_names) do
        new_conf[t.."_datas"] = datas[s];
    end

    -- データ保存
    local save_path = self.path:gsub("?", self.version);
    gg.saveVariable(self.datas, save_path);

    return new_conf;
end

-- Search address
menu.catfood_b = function()

end

-- Return value
menu.catfood = function(val)

    print("Rx: "..(val or 0));
    return 58999;
end

menu.xp_b = function()

end

menu.xp = function(val)

    return 100;
end

menu.noarmal_ticket_b = function()

end

menu.noarmal_ticket = function(val)

    return 100;
end

menu.rare_ticket_b = function()

end

menu.rare_ticket = function(val)

    return 100;
end

menu.stage_flag_b = function()

end

menu.stage_flag = function(val)

    return 100;
end

menu.char_flag_b = function()

end

menu.char_flag = function(val)

    return 100;
end

menu.char_level_b = function()

end

menu.char_level = function(val)

    return 100;
end

menu.char_form_b = function()

end

menu.char_form = function(val)

    return 100;
end

menu.char_des_b = function()

end

menu.char_des = function(val)

    return 100;
end

menu.treasure_b = function()

end

menu.treasure = function(val)

    return 100;
end

menu.np_b = function()

end

menu.np = function(val)

    return 100;
end

menu.items_b = function()

end

menu.items = function(val)

    return 100;
end

menu.catseye_b = function()

end

menu.catseye = function(val)

    return 100;
end

menu.catvitan_b = function()

end

menu.catvitan = function(val)

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
