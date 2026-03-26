open_system('dvfs_zed_simple_backup');
open_system('gm_dvfs_zed_simple_backup');
cs.HiliteType = 'user5';
cs.ForegroundColor = 'black';
cs.BackgroundColor = 'magenta';
set_param(0, 'HiliteAncestorsData', cs);
hilite_system('gm_dvfs_zed_simple_backup/dvfs_core_hdl/LMS_predictor/multiplier', 'user5');
hilite_system('dvfs_zed_simple_backup/dvfs_core_hdl/LMS_predictor', 'user5');
