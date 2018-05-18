call AddCycleGroup('global', [ 'return', 'break', 'continue' ])
call AddCycleGroup('global', [ 'next', 'previous' ])
call AddCycleGroup('global', [ 'assert', 'refute' ])
call AddCycleGroup('global', [ 'active', 'inactive' ])
call AddCycleGroup('global', [ 'first', 'last' ])
call AddCycleGroup('global', [ 'internal', 'external' ])
call AddCycleGroup('global', [ 'debit', 'credit' ])
call AddCycleGroup('global', [ 'staging', 'production' ])

call AddCycleGroup(
  \ [ 'ruby', 'eruby', 'haml', 'slim' ],
  \ [ 'return', 'break', 'continue', 'next', 'retry' ])

call AddCycleGroup(
  \ [ 'javascript', 'coffee' ],
  \ [ 'addClass', 'removeClass' ])

call AddCycleGroup('sh', [ 'if', 'elif', 'else', 'fi' ])
call AddCycleGroup('sh', [ 'do', 'then' ])
