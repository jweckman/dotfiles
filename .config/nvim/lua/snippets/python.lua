local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("python", {
	s("o_domain", {
		t("self.env['"),
		i(1, "res.partner"),
		t({ "'].search([", "])" }),
	}),
})

ls.add_snippets("python", {
	s("o_leaf", {
		t("('"),
		i(1, "field_name"),
		t("', '=', "),
		i(2, "val"),
		t("),"),
	}),
})
