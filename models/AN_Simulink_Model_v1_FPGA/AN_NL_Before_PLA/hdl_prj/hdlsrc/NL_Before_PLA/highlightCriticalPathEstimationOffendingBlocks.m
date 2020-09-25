open_system('NL_Before_PLA');
open_system('gm_NL_Before_PLA');
cs.HiliteType = 'user2';
cs.ForegroundColor = 'black';
cs.BackgroundColor = 'gray';
set_param(0, 'HiliteAncestorsData', cs);
hilite_system('gm_NL_Before_PLA/NL Before PLA Singles/Compare To Zero_relop/Compare To Zero_relop', 'user2');
annotate_port('gm_NL_Before_PLA/NL Before PLA Singles/Compare To Zero_relop/Compare To Zero_relop', 1, 1, 'Block not characterized for this configuration');
