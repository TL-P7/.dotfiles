return {
  "frabjous/knap",
  ft = "tex",
  config = function()
    local gknapsettings = {
      mdtohtml = "pandoc -f markdown --standalone -o %outputfile%",
      mdtohtmlbufferasstdin = true
    }
    vim.g.knap_settings = gknapsettings
  end
}
