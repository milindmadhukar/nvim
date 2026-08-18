-- NOTE: Java LSP
--
-- jdtls is started per-buffer by nvim-jdtls rather than by vim.lsp.enable(),
-- which is why "jdtls" is absent from plugins/lsp/servers.lua.
--
-- Requires a JDK on PATH. Without one the launcher dies with a Python
-- traceback into lsp.log and nothing surfaces in the editor, so this guards
-- on `java` and says so instead of failing silently.
return {
	"mfussenegger/nvim-jdtls",
	ft = "java",
	config = function()
		local launcher = vim.fn.stdpath("data") .. "/mason/packages/jdtls/bin/jdtls"

		local warned = false

		local function start()
			-- start() is reachable from both the autocmd and the explicit call
			-- below, so guard per buffer to avoid attaching (or warning) twice.
			if vim.b.jdtls_started then
				return
			end
			vim.b.jdtls_started = true

			if vim.fn.executable("java") ~= 1 then
				if not warned then
					warned = true
					vim.notify("jdtls: no `java` on PATH; install a JDK (e.g. pacman -S jdk-openjdk)", vim.log.levels.WARN)
				end
				return
			end
			if vim.fn.filereadable(launcher) ~= 1 then
				vim.notify("jdtls: launcher missing; run :MasonInstall jdtls", vim.log.levels.WARN)
				return
			end

			-- Fall back to the file's own directory for single-file work.
			local markers = { "gradlew", "mvnw", "pom.xml", "build.gradle", "build.gradle.kts", ".git" }
			local found = vim.fs.find(markers, { upward = true, path = vim.fn.expand("%:p:h") })[1]
			local root = found and vim.fs.dirname(found) or vim.fn.expand("%:p:h")

			require("jdtls").start_or_attach({
				cmd = { launcher, "-data", vim.fn.stdpath("cache") .. "/jdtls/" .. vim.fn.fnamemodify(root, ":p:h:t") },
				root_dir = root,
			})
		end

		-- Per-buffer, not once: lazy's `config` runs a single time, so opening a
		-- second Java project in the same session would never attach.
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("user_jdtls", { clear = true }),
			pattern = "java",
			callback = start,
		})

		-- `config` runs *after* the FileType event that loaded the plugin, so the
		-- buffer that triggered it needs starting explicitly.
		if vim.bo.filetype == "java" then
			start()
		end
	end,
}
