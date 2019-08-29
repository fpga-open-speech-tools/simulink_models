function hdlblkmask_multiplyAccumulate_cb1(blk)
%

%   Copyright 2018 The MathWorks, Inc.

    
%disp('cb1')
    vi = get_param(blk,'MaskVisibilities');
    en = get_param(blk,'MaskEnables');
    op = get_param(blk,'opMode');
    
    mo = get_param(blk,'MaskObject');
    tc1 = mo.getDialogControl('biastxt1'); tc2 = mo.getDialogControl('biastxt2'); tc3 = mo.getDialogControl('biastxt3');
    grp = mo.getDialogControl('ports_container');
%     accControl = get_param(gcb,'accControl');
    switch op
        case 'Vector'
            en(2:14) = {'on';'on';'off';'off';'off';'off';'off';'on';'off';'off';'on';'off';'off'};
            vi(2:14) = {'on';'on';'off';'off';'off';'off';'off';'on';'off';'off';'on';'off';'off'};
            
            en(15:18) = {'off';'off';'off';'off'};
            vi(15:18) = {'off';'off';'off';'off'};
            
            tc1.Visible = 'on';
            tc2.Visible = 'off';
            tc3.Visible = 'off';
            grp.Visible = 'off';
            
            set_param(blk,'MaskVisibilities',vi);
            set_param(blk,'MaskEnables',en);

        case 'Streaming - using Start and End ports'
                en(2:14) = {'off';'off';'on';'on';'off';'off';'off';'off';'on';'off';'off';'on';'off'};
                vi(2:14) = {'off';'off';'on';'on';'off';'off';'off';'off';'on';'off';'off';'on';'off'};
                en(15:18) = {'on';'on';'on';'off'};
                vi(15:18) = {'on';'on';'on';'off'};
            
                
                tc1.Visible = 'off';
                tc2.Visible = 'on';
                tc3.Visible = 'off';
                grp.Visible = 'on';
                
                set_param(blk,'MaskVisibilities',vi)
                set_param(blk,'MaskEnables',en)
        case 'Streaming - using Number of Samples'
                en(2:14) = {'off';'off';'off';'off';'on';'on';'on';'off';'off';'on';'off';'off';'on'};
                vi(2:14) = {'off';'off';'off';'off';'on';'on';'on';'off';'off';'on';'off';'off';'on'};
                en(15:18) = {'on';'off';'off';'on'};
                vi(15:18) = {'on';'off';'off';'on'};
                
                tc1.Visible = 'off';
                tc2.Visible = 'off';
                tc3.Visible = 'on';
                grp.Visible = 'on';
                
                set_param(blk,'MaskVisibilities',vi);
                set_param(blk,'MaskEnables',en);

                        
    end
end


