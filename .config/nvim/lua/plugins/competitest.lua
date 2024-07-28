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
        kotlin      = { exec = "kotlinc", args = { "$(FNAME)", "-include-runtime", "-d", "$(FNOEXT).jar" } },
        some_lang = { exec = 'some_compiler', args = { '$(FNAME)' } },
      },
      run_command = {
        c         = { exec = "./$(FNOEXT)" },
        cpp       = { exec = './$(FNOEXT)' },
        rust      = { exec = "./$(FNOEXT)" },
        python    = { exec = "python3", args = { "$(FNAME)" } },
        java      = { exec = "java", args = { "$(FNOEXT)" } },
        kotlin      = { exec = "java", args = { "-jar", "$(FNOEXT).jar" } },
        some_lang = { exec = 'some_interpreter', args = { '$(FNAME)' } },
      },
    })
  end,
}
