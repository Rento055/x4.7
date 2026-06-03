-- [[ Nyanko_x4.7 - Instoller ]]
-- Source: https://github.com/Rento055/x4.7
local repo_mods = "https://raw.githubusercontent.com/Rento055/x4.7/refs/heads/main/mods/";
local repo_ext = "https://raw.githubusercontent.com/Rento055/x4.7/refs/heads/main/ext/";
local repo_idx = "https://raw.githubusercontent.com/Rento055/x4.7/refs/heads/main/index.lua";
local path = "/sdcard/catfood/mods/";
local my_name = gg.getFile():match("[^/]+$");

-- Package Names
local package = {"menu", "util"};
local ext_list = {"Designate_Char"};

-- Create the directory and delete the ~/mods/address_pack.txt
local addr_path = ("%saddress_pack.txt"):format(path);
gg.saveList(addr_path);
os.remove(addr_path);

-- Create the directory and delete the ~/datas/address_pack.txt
addr_path = ("%saddress_pack.txt"):format(path.."../datas/");
gg.saveList(addr_path);
os.remove(addr_path);

-- Create the directory and delete the ~/ext/address_pack.txt
addr_path = ("%saddress_pack.txt"):format(path.."../ext/");
gg.saveList(addr_path);
os.remove(addr_path);

-- Download the module programs from the internet.
for _, mod_name in ipairs(package)do
    local mod = gg.makeRequest(("%s%s.lua"):format(repo_mods, mod_name));

    -- Request successfull -> Save to (/sdcard/catfood/mods/?.lua)
    if mod and mod.code == 200 then
        local fw = io.open(("%s%s.lua"):format(path, mod_name), "w");
        fw:write(mod.content);
        fw:close();
    else
        print(table.concat({
            "モジュールのダウンロードに失敗しました。\nネットワーク環境を確認してください。", 
            "Failed to download the module.\nPlease check your network environment."
        }, "\n\n"));
        return os.exit();
    end
end

-- Download the index program from the internet.
local idx_pro = gg.makeRequest(repo_idx);

-- Request successfull(idx_pro) -> Save to (./Nyanko_x4.7.lua)
if idx_pro and idx_pro.code == 200 then
    os.remove(my_name);
    local fw = io.open("./Nyanko_x4.7.lua", "w");
    fw:write(idx_pro.content);
    fw:close();
else
    print(table.concat({
        "実行ファイルのダウンロードに失敗しました。\nネットワーク環境を確認してください。", 
        "Failed to download the executable file.\nPlease check your network environment."
    }, "\n\n"));
    return os.exit();
end

-- Download the extension programs from the internet.
for _, ext_name in ipairs(ext_list) do
    local ext = gg.makeRequest(("%s%s.lua"):format(repo_ext, ext_name));

    -- Request successfull -> Save to (/sdcard/catfood/ext/?.lua)
    if ext and ext.code == 200 then
        local fw = io.open(("%s%s.lua"):format(path.."../ext/", ext_name), "w");
        fw:write(ext.content);
        fw:close();
    else
        print(table.concat({
            "拡張機能のダウンロードに失敗しました。\nネットワーク環境を確認してください。", 
            "Failed to download the extension.\nPlease check your network environment."
        }, "\n\n"));
        return os.exit();
    end
end

-- Download complete.
print(table.concat({
    "Nyanko_x4.7: Download completed.", 
    ("[ %s ] has been renamed to [ Nyanko_x4.7.lua ]"):format(my_name)
}, "\n\n"));
