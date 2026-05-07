return {
  {
    "mfussenegger/nvim-jdtls",
    opts = function(_, opts)
      -- jdtls requires Java 21+ to run; point it at the Homebrew installation
      -- while keeping the default system Java at 17 for project compilation
      table.insert(opts.cmd, "--java-executable")
      table.insert(opts.cmd, "/opt/homebrew/opt/openjdk@21/bin/java")
    end,
  },
}
