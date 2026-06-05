-- [[ Nyanko_x4.7 - Index File ]]
-- Source: https://github.com/Rento055/x4.7
local repo_inst = "https://raw.githubusercontent.com/Rento055/x4.7/refs/heads/main/installer.lua";
path = "/sdcard/catfood/";
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
    gg.alert(table.concat({
        "モジュールが見つかりませんでした。\nネットワーク経由でダウンロードできます。", 
        "The module could not be found.\nIt can be downloaded over the network."
    }, "\n\n"));
    xpcall(load(gg.makeRequest(repo_inst).content or "error"), function()
        print(table.concat({
            "手動でインストールを行ってください。\nソース: "..repo_inst,    -- japanese
            "Please install manually from "..repo_inst                  -- english
        }, "\n\n"));
    end);
    gg.setVisible(true);
    return os.exit();
end

-- Include modules
local menu_ok, menu = pcall(require, "menu");
local util_ok, util = pcall(require, "util");

-- Load error -> delete the files!
if not menu_ok or not util_ok then
    gg.alert(table.concat({
        "モジュールの読み込みに失敗しました。\nスクリプトを再実行してください。", 
        "Module loading failed. Please rerun the script."
    }, "\n\n"));
    os.remove(package.path:gsub("?", "util"));
    os.remove(package.path:gsub("?", "menu"));
    return os.exit();
end

-- Load the config file
local target = gg.getTargetInfo();
local result = package.searchpath(conf_path:match("([^/]+)%.%w+$"), path.."?.lua");
local _;

-- Comfirm the game name
if target.name ~= "にゃんこ大戦争" and target.name ~= "The Battle Cats" then
    print("プロセス未設定/Process not set");
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
        "基本メニュー/Basic Menu", 
        "オプションメニュー/Option Menu", 
        "スクリプト設定/Settings", 
        "終了/Exit"
    }, 2026, ("%s v%s"):format(target.name, target.versionName or "実行環境が不安定です/Unstable Environment"));

    if not mp then

    -- basic menu
    elseif mp == 1 then dispatch("basic");

    -- option menu
    elseif mp == 2 then dispatch("option");

    -- settings
    elseif mp == 3 then
        local mp2 = gg.choice({ 
            "数値データの更新/Update Numeric Data",     -- 手動または自動で更新
            "入力形式の変更/Change Input Format",       -- gg.promptのNumber型とSeekbar型の変更
            "アカウント連携/Account Linking",       -- Pastebin連携でアップロードと取り込み対応
            "戻る/Back"
        }, 2026, ("%s v%s"):format(target.name, target.versionName or "実行環境が不安定です/Unstable Environment"));

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
        elseif (tonumber(mp2[i]) or mp2[i]) ~= datas[i].value then
            util:exe(datas[i], mp2[i]);
        end
    end
    return 0;
end

-- Setup
util:set_base_address();
menu:load_data();
util:update_values();
gg.setVisible(true);

-- Maintain execution
while true do
    if gg.isVisible() then
        gg.setVisible(false);
        main();
    end
end
