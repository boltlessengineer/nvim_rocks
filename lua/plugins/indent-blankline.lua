require("ibl").setup({
    scope = {
        enabled = false,
    },
    exclude = {
        filetypes = {
            "octo",
            "janet",
            "markdown",
            "norg",
        }
    }
})
