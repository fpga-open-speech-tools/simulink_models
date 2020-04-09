open_system('gm_Subsystem');
cs.HiliteType = 'user1';
cs.ForegroundColor = 'black';
cs.BackgroundColor = 'blue';
set_param(0, 'HiliteAncestorsData', cs);
hilite_system('gm_Subsystem/Sum', 'user1');
annotate_port('gm_Subsystem/Sum', 0, 1, 'cp : 3.346 ns');
