local set = vim.keymap.set

set('i', 'jk', '<Esc>')

set('', '<C-h>', '<C-w>h')
set('', '<C-j>', '<C-w>j')
set('', '<C-k>', '<C-w>k')
set('', '<C-l>', '<C-w>l')

set('n', '<leader>q', ':q<CR>')
set('n', '<leader>a', ':w<CR>')
set('n', '<leader>x', ':x<CR>')
set('n', '<leader>h', ':noh<CR>')

set('n', '<C-s>', ':BufferPick<CR>', { silent = true })
set('n', '<A-<>', ':BufferMovePrevious<CR>', { silent = true })
set('n', '<A->>', ':BufferMoveNext<CR>', { silent = true })
set('n', '<A-1>', ':BufferGoto 1<CR>', { silent = true })
set('n', '<A-2>', ':BufferGoto 2<CR>', { silent = true })
set('n', '<A-3>', ':BufferGoto 3<CR>', { silent = true })
set('n', '<A-4>', ':BufferGoto 4<CR>', { silent = true })
set('n', '<A-5>', ':BufferGoto 5<CR>', { silent = true })
set('n', '<A-6>', ':BufferGoto 6<CR>', { silent = true })
set('n', '<A-7>', ':BufferGoto 7<CR>', { silent = true })
set('n', '<A-8>', ':BufferGoto 8<CR>', { silent = true })
set('n', '<A-9>', ':BufferGoto 9<CR>', { silent = true })
set('n', '<A-c>', ':BufferClose<CR>', { silent = true })
