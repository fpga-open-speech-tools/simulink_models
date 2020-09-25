open_system('IHC_NL_Logarithmic_Function');
open_system('gm_IHC_NL_Logarithmic_Function');
cs.HiliteType = 'user2';
cs.ForegroundColor = 'black';
cs.BackgroundColor = 'gray';
set_param(0, 'HiliteAncestorsData', cs);
hilite_system('gm_IHC_NL_Logarithmic_Function/IHC NL Logarithmic Function Singles/Compare To Zero_relop/Compare To Zero_relop', 'user2');
annotate_port('gm_IHC_NL_Logarithmic_Function/IHC NL Logarithmic Function Singles/Compare To Zero_relop/Compare To Zero_relop', 1, 1, 'Block not characterized for this configuration');
