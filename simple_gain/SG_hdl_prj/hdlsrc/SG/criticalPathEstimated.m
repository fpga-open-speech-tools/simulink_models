open_system('gm_SG');
cs.HiliteType = 'user2';
cs.ForegroundColor = 'black';
cs.BackgroundColor = 'lightblue';
set_param(0, 'HiliteAncestorsData', cs);
hilite_system('gm_SG/DataPlane/Avalon Data Processing', 'user2');
annotate_port('gm_SG/DataPlane/Avalon Data Processing', 0, 1, 'cp : 9.227 ns');
cs.HiliteType = 'user2';
cs.ForegroundColor = 'black';
cs.BackgroundColor = 'lightblue';
set_param(0, 'HiliteAncestorsData', cs);
hilite_system('gm_SG/DataPlane/Avalon Data Processing/Right Channel Processing', 'user2');
annotate_port('gm_SG/DataPlane/Avalon Data Processing/Right Channel Processing', 0, 1, 'cp : 8.636 ns');
cs.HiliteType = 'user1';
cs.ForegroundColor = 'black';
cs.BackgroundColor = 'blue';
set_param(0, 'HiliteAncestorsData', cs);
hilite_system('gm_SG/DataPlane/Avalon Data Processing/Multiport Switch', 'user1');
annotate_port('gm_SG/DataPlane/Avalon Data Processing/Multiport Switch', 0, 1, 'cp : 9.227 ns');
cs.HiliteType = 'user2';
cs.ForegroundColor = 'black';
cs.BackgroundColor = 'lightblue';
set_param(0, 'HiliteAncestorsData', cs);
hilite_system('gm_SG/DataPlane/Avalon Data Processing/Right Channel Processing/Data Type Conversion', 'user2');
annotate_port('gm_SG/DataPlane/Avalon Data Processing/Right Channel Processing/Data Type Conversion', 0, 1, 'cp : 8.636 ns');
cs.HiliteType = 'user1';
cs.ForegroundColor = 'black';
cs.BackgroundColor = 'blue';
set_param(0, 'HiliteAncestorsData', cs);
hilite_system('gm_SG/DataPlane/Avalon Data Processing/Right Channel Processing/Product', 'user1');
annotate_port('gm_SG/DataPlane/Avalon Data Processing/Right Channel Processing/Product', 0, 1, 'cp : 8.636 ns');
