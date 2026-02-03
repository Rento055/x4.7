-- [[ Nyanko_x4.7 - Instoller ]]
-- Source: https://github.com/Rento055/x4.7
local repo_mods = "https://raw.githubusercontent.com/Rento055/x4.7/refs/heads/main/mods/";
local repo_idx = "https://raw.githubusercontent.com/Rento055/x4.7/refs/heads/main/index.lua";
local path = "/sdcard/catfood/mods/";
local my_name = gg.getFile():match("[^/]+$");

-- Create the directory and delete the address_pack.txt
local addr_path = ("%saddress_pack.txt"):format(path);
gg.saveList(addr_path);
os.remove(addr_path);

-- Download the module programs from the internet.
local mod_menu = gg.makeRequest(("%smenu.lua"):format(repo_mods));
local mod_util = gg.makeRequest(("%sutil.lua"):format(repo_mods));

-- Request successfull(menu) -> Save to (/sdcard/catfood/mods/menu.lua)
if mod_menu and mod_menu.code == 200 then
    local fw = io.open(("%smenu.lua"):format(path), "w");
    fw:write(mod_menu.content);
    fw:close();
else
    print("ダウンロードに失敗しました。");
    return os.exit();
end

-- Request successfull(util) -> Save to (/sdcard/catfood/mods/util.lua)
if mod_util and mod_util.code == 200 then
    local fw = io.open(("%sutil.lua"):format(path), "w");
    fw:write(mod_util.content);
    fw:close();
else
    print("ダウンロードに失敗しました。");
    return os.exit();
end

-- Download the index program from the internet.
local idx_pro = gg.makeRequest(repo_idx);

-- Request successfull(idx_pro) -> Save to (./Nyanko_x4.7.lua)
if idx_pro and idx_pro.code == 200 then
    local fw = io.open("./Nyanko_x4.7.lua", "w");
    fw:write(idx_pro.content);
    fw:close();
    io.remove(my_name);
else
    print("実行ファイルのダウンロードに失敗しました。");
    return os.exit();
end

-- Download complete.
print(table.concat({
    "Nyanko_x4.7: ダウンロード完了", 
    ("[ %s ] -> [ Nyanko_x4.7.lua ] に名称変更されました。"):format(my_name)
}, "\n\n"));
