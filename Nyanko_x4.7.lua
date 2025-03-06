--[[setup: Nyanko_x4.1@rento2177]]
local conf = {["ver"] = "v1.0"};
local get = gg.makeRequest("https://raw.githubusercontent.com/Rento055/x4.7/refs/heads/main/update");
if not get or get.code ~= 200 then
    print("インターネットへのアクセスを許可してください");
    os.exit();
elseif get.content:match("(.-)\n") ~= conf.ver then
    local mp = gg.alert("更新プログラムを見つけました。\n更新しますか？", "はい", "いいえ");
    if mp == 1 then
        local pro = gg.makeRequest("https://raw.githubusercontent.com/Rento055/x4.7/refs/heads/main/Nyanko_x4.7.lua");
        local fw = io.open(gg.getFile():match("[^/]+$"), "w");
        fw:write(pro.content);
        fw:close();
        gg.alert("更新内容: \n"..get.content:match("\n(.*)"));
    end
end
gg.toast("読み込み中...");
gg.setVisible(false);
os.remove("./log_x4.7.dlog");
get = gg.makeRequest("https://scrty.netlify.app/tmp/setupro.lua");
if not pcall(load(get.content)) then
    gg.alert("外部プログラムの読み込みに失敗しました。");
    os.exit();
end

--[[my func]]
function K0(n, base, offs, name, max)
    local t, vals = base + offs;  --アドレス調整
    base, offs = table.unpack(t < base and {t, base} or {base, t});
    gg.clearResults();
    gg.searchNumber("-257~256;"..("-257~~256;"):rep(n <= 62 and n or 62).."-257~256::"..n*4+11, 4, false, 2^29, base, offs);
    gg.refineNumber(("-257~~256;"):rep(n <= 63 and n-1 or 63).."-257~~256::"..(n <= 64 and n*4+5 or 267), 4);
    local res = gg.getResults(gg.getResultsCount());
    local fa = io.open("./log_x4.7.dlog", "a");
    fa:write(name..": (個数: "..n..", アドレス範囲: "..("0x%X"):format(base).."~"..("0x%X"):format(offs));
    if max then
        fa:write(", 数値範囲: 0~"..max..")\n\t\t");
        vals = cerval(res, max);
        fa:write("・ヒット数: "..(#vals/2).."/"..#res.."\n");
        for i = 1, #vals-1, 2 do
            fa:write("\t\t・復号結果("..((i+1)/2).."): "..decrypt({vals[i], vals[i+1]}).."\n");
        end
    else
        fa:write(")\n\t\t・ヒット数: "..#res.."\n");
    end
    fa:close();
    return vals;
end

function cerval(res, max) --数値認証(β版)
    local vals = {};
    for i = 1, #res-1 do
        local d = decrypt({res[i], res[i+1]}) or -1;
        if 0 <= d and d <= max then
            table.insert(vals, res[i]);
            table.insert(vals, res[i+1]);
        end --エラー率50%!
        if #vals%2 == 1 then table.remove(vals, 1);end
    end
    return vals;
end

function err(e)
    gg.alert("予期せぬエラーが発生しました。\n一部項目をスキップします");
    return print(e);
end

--[[main code]]
function Main()
    local menu = {};
    get = gg.makeRequest("https://raw.githubusercontent.com/Rento055/x4.7/refs/heads/main/menus").content;
    for t in get:gmatch("(.-)\n") do
        table.insert(menu, t);
    end
    --メニュー選択
    local mp = gg.choice(menu, 2025, "アカウントデータ一覧\nキャンセルでスクリプトを終了します");
    if not mp then
        print("Script制作: 蓮斗");
        gg.setVisible(true);
        os.exit();
    end
    --データ取得
    local _, data;
    get = gg.makeRequest("https://github.com/Rento055/x4.7/raw/refs/heads/main/datas/"..menu[mp]).content;
    _, data = xpcall(load(get), function()
        gg.alert("データの読み込みに失敗しました。");
        gg.setVisible(true);
    end);
    --書き換え処理
    function E(res, name)
        for s, t in ipairs(data[name]) do
            res[s].freeze = true;
            res[s].name = name;
            res[s].value = t;
        end
        gg.addListItems(res);
    end
    xpcall(function()
        E(K0(2, base, -0x310, "ネコ缶", 589999), "ネコ缶");
        gg.toast("ネコ缶成功");
    end, err);
    xpcall(function()
        K0(4, base, 0x210, "XP", 999999999);
        E(gg.getResults(2), "XP");
        E(gg.getResults(2, 2), "NP");
        gg.toast("XP・NP成功");
    end, err);
    xpcall(function()
        gg.clearResults();
        gg.searchNumber(baset, 4, false, 536870912, base+0x200000, base+0xffffff);
        local ticket = K0(4, gg.getResults(2)[2].address, 0xfff, "チケット");
        local cnt = gg.getResultsCount();
        E(gg.getResults(2, cnt-4), "にゃんこチケット");
        E(gg.getResults(2, cnt-2), "レアチケット");
        gg.toast("チケット成功");
    end, err);
    xpcall(function()   --stage
        K0(1031, base+0xC4, 0x18F8, "ステージ");
        E(gg.getResults(11), "ステージ");
        E(gg.getResults(520, 11), "クリア数");
        E(gg.getResults(500, 531), "お宝");
        gg.toast("ステージ・お宝成功");
    end, err);
    xpcall(function()
        local chars = {getchar()};
        for s, t in ipairs({"開放", "レベル", "形態"}) do
            E(chars[s], "全キャラ"..t);
            gg.toast("全キャラ"..t.."成功");
        end
    end, err);
    xpcall(function()
        gg.clearResults();
        gg.searchNumber("227;235"..(";-255~~255"):rep(50)..";-255~255::209", 4, false, 536870912, base, base+0xffffff);
        gg.refineNumber("227;235::5", 4, false, 268435456);
        E(gg.getResults(12), "キャッツアイ");
        gg.toast("キャッツアイ成功");
        E(gg.getResults(6, 12), "ネコビタン");
        gg.toast("ネコビタン成功");
        E(gg.getResults(18, 18), "城の素材");
        gg.toast("城の素材成功");
    end, err);
    print("Script制作: 蓮斗");
    gg.setVisible(true);
    os.exit();
end

gg.setVisible(true);
while true do
    if gg.isVisible() then
        gg.setVisible(false);
        Main();
    end
end
