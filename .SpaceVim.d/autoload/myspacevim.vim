function! myspacevim#before() abort
  call SpaceVim#logger#info('myspacevim#before called')
  let g:ale_fixers = {}
  let g:ale_fixers['javascript'] = ['prettier']
  let g:ale_fixers['typescript'] = ['prettier']
  let g:ale_fix_on_save = 1
  let g:ale_javascript_prettier_options = '--stdin --single-quote --trailing-comma es5 --print-width 125'
  let g:ale_typescript_prettier_options = '--stdin --single-quote --trailing-comma es5 --print-width 125'

  let g:spacevim_project_rooter_automatically = 0
  call add(g:spacevim_project_rooter_patterns, 'package.json')
endf
