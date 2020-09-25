open_system('gm_OHC_NL_Boltzman_Function');
cs.HiliteType = 'user1';
cs.ForegroundColor = 'black';
cs.BackgroundColor = 'blue';
set_param(0, 'HiliteAncestorsData', cs);
hilite_system('gm_OHC_NL_Boltzman_Function/OHC NL Boltzman Function/Math Function', 'user1');
annotate_port('gm_OHC_NL_Boltzman_Function/OHC NL Boltzman Function/Math Function', 0, 1, 'cp : 4.379 ns');
