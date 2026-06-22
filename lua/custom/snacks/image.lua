return {
  'folke/snacks.nvim',
  opts = {
    -- IMPORTANT: If images are not loading:
    -- 1. Run `:checkhealth snacks` to verify ImageMagick is installed
    -- 2. If using Tmux, add `set -gq allow-passthrough on` to your ~/.tmux.conf
    -- 3. Ensure you are using a supported terminal (Kitty, Ghostty, or WezTerm)
    image = {
      enabled = true,
      doc = {
        inline = false,
        float = true,
        max_width = 80,
        max_height = 50,
      },
    },
  },
}
