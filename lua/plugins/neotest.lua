return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "zidhuss/neotest-minitest",
    },
    opts = {
      adapters = {
        ["neotest-minitest"] = {
          test_cmd = function()
            return vim.tbl_flatten({
              "bin/rails",
              "test",
            })
          end,
        },
      },
    },
  },
}
