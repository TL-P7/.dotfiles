return {
  'xeluxee/competitest.nvim',
  dependencies = 'MunifTanjim/nui.nvim',
  ft = { 'cpp' },
  config = function()
    require('competitest').setup({
      compile_command = {
        cpp       = { exec = 'g++', args = { '$(FNAME)', '-std=c++17', '-O2', '-Wall', '-o', '$(FNOEXT)' } },
        some_lang = { exec = 'some_compiler', args = { '$(FNAME)' } },
      },
      run_command = {
        cpp       = { exec = './$(FNOEXT)' },
        some_lang = { exec = 'some_interpreter', args = { '$(FNAME)' } },
      },
    })
  end,
}
