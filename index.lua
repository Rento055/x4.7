-- [[ Nyanko_x4.7 - Index File ]]
-- Source: https://github.com/Rento055/x4.7
local repo_inst = "https://github.com/Rento055/x4.7/installer.lua";
local path = "/sdcard/catfood/";
local conf_path = ("%sconf.lua"):format(path);
package.path = ("%smods/?.lua"):format(path);
gg.setVisible(false);

-- Check if the module exists
local function module_exists(...)
    local is_exists = true;
    for _, name in ipairs({...}) do
        is_exists = is_exists and package.searchpath(name, package.path);
    end
    return is_exists;
end

-- Module Check and Installation
if not module_exists("util", "menu") then
    gg.alert("モジュールが見つかりませんでした。\nネットワーク経由でダウンロードできます。");
    xpcall(load(gg.makeRequest(repo_inst).content or "error"), function()
        print("手動でインストールを行ってください。\nソース: "..repo_inst);
    end);
    return os.exit();
end

-- Include modules
local menu_ok, menu = pcall(require, "menu");
local util_ok, util = pcall(require, "util");

-- Load error -> delete the files!
if not menu_ok or not util_ok then
    gg.alert("モジュールの読み込みに失敗しました。\nスクリプトを再実行してください。");
    os.remove(package.path:gsub("?", "util"));
    os.remove(package.path:gsub("?", "menu"));
    return os.exit();
end

-- Load the config file
local target = gg.getTargetInfo();
local result = package.searchpath(conf_path:match("([^/]+)%.%w+$"), path.."?.lua");
local _;

-- Comfirm the game name
if target.name ~= "にゃんこ大戦争" then
    print("プロセス未設定");
    return os.exit();

-- Search result for the config file
elseif result then
    _, util.data = xpcall(loadfile(conf_path), function() return {}; end);

    -- Version check
    if util.data.version ~= target.versionName then
        util:conf_update();
    end
else
    util:conf_update();
end

-- Save config data
gg.saveVariable(util.data, conf_path);

-- [[ main code ]]
function main()
    local mp = gg.choice({
        "基本メニュー", 
        "オプションメニュー", 
        "スクリプト設定", 
        "終了"
    }, 2026, ("にゃんこ大戦争 v%s"):format(target.versionName or "実行環境が不安定です"));

    if not mp then

    -- basic menu
    elseif mp == 1 then dispatch("basic");

    -- option menu
    elseif mp == 2 then dispatch("option");

    -- settings
    elseif mp == 3 then
        local mp2 = gg.choice({ 
            "数値データの更新",     -- 手動または自動で更新
            "入力形式の変更",       -- gg.promptのNumber型とSeekbar型の変更
            "アカウント連携",       -- Pastebin連携でアップロードと取り込み対応
            "戻る"
        }, 2026, ("にゃんこ大戦争 v%s"):format(target.versionName or "実行環境が不安定です"));

        if not mp2 then
        elseif mp2 == 1 then util:conf_update();    -- self(util.data)に変更
        elseif mp2 == 2 then util:input_type();     -- self(util.data)に変更
        elseif mp2 == 3 then util:data_link();      -- self(util.data)に変更
        elseif mp2 == 4 then return main();         -- mainを呼び出して閉じる
        end

    -- exit
    elseif mp == 4 then
        print("Thank you for using Nyanko_x4.7!");
        gg.setVisible(true);
        return os.exit();
    end
end

function dispatch(menu_name)
    local mp2 = gg.prompt(util:gen_menu(menu_name));
    local datas = util.data[menu_name.."_datas"];
    local idx = 0;

    -- Input processing
    for i = 1, #(mp2 or {}) do

        -- Checkbox processing
        if mp2[i] == true then
            idx = i + (datas[i].key == "on_off" and 1 or 0);
            util:exe(datas[idx], mp2[idx]);

        -- Block string type and i == idx
        elseif type(mp2[i]) ~= "string" or i == idx then

        -- Number(prompt type) processing
        elseif tonumber(mp2[i]) ~= datas[i].value then
            util:exe(datas[i], mp2[i]);
        end
    end
    return 0;
end

-- Retrieve lib file and time zone
local lib = gg.getRangesList("libnative-lib.so:bss");
local t = os.time();
local time_zone = os.difftime(t, os.time(os.date("!*t", t)));

--Set base address
if lib and lib[1] then
    gg.clearResults();
    gg.searchNumber(math.tointeger(time_zone), 4, false, 536870912, lib[1].start, lib[1]["end"]);
    base = gg.getResults(1)[1].address;
else
    gg.alert("Cb版apkを使用してください。");
    return os.exit();
end

menu:load_data();
gg.setVisible(true);

-- Maintain execution
while true do
    if gg.isVisible() then
        gg.setVisible(false);
        main();
    end
end
