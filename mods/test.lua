-- ベースアドレスの設定
gg.setRanges(16);
gg.clearResults();
gg.searchNumber("32400", 4);
local base = gg.getResults(1)[1].address;

-- 数値（ステージ、キャラ系）の検索
gg.clearResults();
gg.searchNumber("-256~~255"..(";-256~~255"):rep(62)..";-256~255::253", 4, false, 536870912, base+0x512, base+0xfffff);
gg.refineNumber("-256~~255;-256~255::5", 4);
gg.refineNumber("-999999~~999999", 4);

-- キャラ系の数値だけ取り出す
local res = gg.getResults(1, gg.getResultsCount()-2)[1].address;
gg.clearResults();
gg.searchNumber("-256~256", 4, false, 536870912, res-0xffff, res);
local res2 = gg.getResults(1, gg.getResultsCount()-1)[1].address;
local diff = res - res2;
local char_top = res2 + (diff-4)%(3*4)+4;

-- 数値変更
gg.clearResults();
gg.startFuzzy(4, char_top, char_top + diff/3 - 4);
local res3 = gg.getResults(gg.getResultsCount()-1);
gg.editAll(res3[1].value, 4);