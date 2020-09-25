open_system('gm_NL_After_OHC_Function');
cs.HiliteType = 'user1';
cs.ForegroundColor = 'black';
cs.BackgroundColor = 'blue';
set_param(0, 'HiliteAncestorsData', cs);
hilite_system('gm_NL_After_OHC_Function/NL After OHC Function Singles/Exp', 'user1');
annotate_port('gm_NL_After_OHC_Function/NL After OHC Function Singles/Exp', 0, 1, 'cp : 4.379 ns');
