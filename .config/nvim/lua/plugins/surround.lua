-- nvim-surround: テキストを囲む・変更・削除
-- Web 開発で HTML タグの追加・変更に特に便利
--
-- 使い方:
--   ys{motion}{char}  囲む      例: ysiw"  → "word"
--   ys{motion}<tag>   タグで囲む 例: ysiw<div> → <div>word</div>
--   cs{old}{new}      変更する   例: cs"'   → "hello" → 'hello'
--   ds{char}          削除する   例: ds"    → "hello" → hello
--   dst               タグ削除   例: dst    → <div>word</div> → word

return {
  "kylechui/nvim-surround",
  event = "VeryLazy",
  opts = {},
}
