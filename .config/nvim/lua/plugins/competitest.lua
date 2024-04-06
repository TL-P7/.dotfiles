return {
  'xeluxee/competitest.nvim',
  dependencies = 'MunifTanjim/nui.nvim',
  ft = { 'c', 'cpp', 'python' },
  config = function()
    require('competitest').setup({
      compile_command = {
        c         = { exec = "gcc", args = { "-Wall", "$(FNAME)", "-o", "$(FNOEXT)" } },
        cpp       = { exec = 'g++', args = { '$(FNAME)', '-std=c++17', '-O2', '-Wall', '-o', '$(FNOEXT)' } },
        rust      = { exec = "rustc", args = { "$(FNAME)" } },
        java      = { exec = "javac", args = { "$(FNAME)" } },
        some_lang = { exec = 'some_compiler', args = { '$(FNAME)' } },
      },
      run_command = {
        c         = { exec = "./$(FNOEXT)" },
        cpp       = { exec = './$(FNOEXT)' },
        rust      = { exec = "./$(FNOEXT)" },
        python    = { exec = "python3", args = { "$(FNAME)" } },
        java      = { exec = "java", args = { "$(FNOEXT)" } },
        some_lang = { exec = 'some_interpreter', args = { '$(FNAME)' } },
      },
    })
  end,
}
