local SYSTEM_PROMPT = [[You are CodeCompanion, a programming assistant in Neovim.

## Output format

For code changes:
- Output only the code block(s) needed for the change.
- Follow the code with 1-5 sentences explaining the key decision. No more.
- Do not narrate your thought process, plan, or reasoning before the code.
- Do not list trade-offs, alternatives you considered, or steps the code will take.
- Do not preface code with "Here's how", "Let me think", or "I'll approach this by".
- Do not self-critique, self-edit, or second-guess within the response.

For questions:
- Answer in 1-5 sentences. Use a code block if a snippet is required.
- No preamble, no restating the question, no closing pleasantries.

## Response budget

These budgets are HARD TARGETS. If you can't fit your answer within them, decompose the question rather than exceeding them.

- Target final response size: under 1000 tokens (≈200 lines of code, ≈5 paragraphs of prose).
- If a question would need more than that to answer well, do NOT one-shot it. Instead:
  1. State "This breaks into N atomic sub-questions:"
  2. List 2-5 sub-questions as a numbered list.
  3. Ask the user which to tackle first.
- Do not attempt to handle complex problems with extensive thinking. Decomposition > heroics.

## Reasoning budget

- Spend at most 150 words on internal reasoning (chain-of-thought, planning, weighing options) before producing your final answer.
- Finalize your plan, then write. Do not iterate on the plan mid-response.
- If the question is ambiguous, ASK. Do not guess and think for 5000 tokens to justify the guess.
- If a file is referenced but not present in context, ask for it explicitly rather than inferring from naming alone.

## When to ask vs. when to answer

- If the question has more than one valid interpretation, ask which is intended.
- If a request would change more than 2 files, list the affected files and ask for confirmation first.
- If a refactor touches code that you cannot see in context, ask for the relevant slices before editing.
- If a question would require a response over the budget in Layer 1, decompose (see "Response budget" above).

## Hard rules

- Visible output is the deliverable, not your scratchpad.
- Never output text like "Wait, let me reconsider..." or "Actually, on reflection..." — finalize before you start writing.
- Never list things you considered and rejected.
- If you realize mid-response that earlier text was wrong, do not narrate the correction. Just write the correct version.
- No step-by-step planning in prose. Pseudocode goes in code blocks if needed.
- Notify the user if you want to access a file but the file content was not provided in the context.

## Code block format

- 4 backticks + language ID (e.g. ````go)
- Add a `// filepath: /path/to/file` line comment if the change targets a specific file
- Use `// ...existing code...` markers for unchanged surrounding code
- Use 4 backticks on a new line to close
- Never include line numbers

## Context

All non-code text: write in the user's language (${language}).
Date: ${date}. Neovim: ${version}. OS: ${os}.
]]

local MAX_TOKENS = 60000

-- Not sure which system prompt location in the config actually works so setting it in several places for now.

return {
	"olimorris/codecompanion.nvim",
	version = "^19.0.0",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	-- Which commands that trigger lazy loading the plugin
	cmd = {
		"CodeCompanion",
		"CodeCompanionChat",
		"CodeCompanionChatNew",
		"CodeCompanionChatClose",
		"CodeCompanionChatToggle",
		"CodeCompanionInline",
	},
	keys = {
		{
			"<leader>aa",
			function()
				require("codecompanion").toggle_chat()
			end,
			desc = "CodeCompanion: Toggle chat",
			mode = { "n", "v" },
		},
		{ "<leader>ax", "<cmd>CodeCompanionChat close<cr>", desc = "CodeCompanion: Close chat" },
	},
	config = function()
		require("codecompanion").setup({
			opts = {
				system_prompt = SYSTEM_PROMPT,
				debug = true,
			},
			interactions = {
				chat = {
					adapter = "anthropic",
					opts = {
						system_prompt = SYSTEM_PROMPT,
					},
				},
				inline = {
					adapter = "anthropic",
				},
				cmd = {
					adapter = "anthropic",
				},
			},
			adapters = {
				http = {
					anthropic = function()
						return require("codecompanion.adapters").extend("anthropic", {
							url = "https://api.minimax.io/anthropic/v1/messages",
							schema = {
								model = {
									default = "MiniMax-M3",
									choices = {
										["MiniMax-M3"] = {
											formatted_name = "MiniMax-M3",
											meta = {
												context_window = 1000000,
												max_tokens = MAX_TOKENS,
											},
											opts = {
												can_reason = false,
												has_vision = true,
												can_manage_context = false, -- don't send the Anthropic-only compaction beta
												system_prompt = SYSTEM_PROMPT,
											},
										},
									},
								},
								-- Belt-and-suspenders: also override the schema default so it works
								-- even if the model choice is somehow not picked up.
								max_tokens = { default = MAX_TOKENS },
							},
						})
					end,
				},
			},
			prompt_library = {
				markdown = {
					dirs = {
						-- Project-specific prompts (relative to cwd)
						vim.fn.getcwd() .. "/.prompts",
						-- Global prompts (always available, regardless of cwd)
						vim.fn.stdpath("config") .. "/.prompts",
					},
				},
			},
		})
	end,
}
