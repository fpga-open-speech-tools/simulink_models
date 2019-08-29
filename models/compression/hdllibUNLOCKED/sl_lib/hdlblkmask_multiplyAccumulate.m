%

%   Copyright 2016-2018 The MathWorks, Inc.

function hdlblkmask_multiplyAccumulate(blk)
    opMode = get_param(blk,'opMode');

    %names for sub-blocks inside the masked top block
    VectorMAC_name = 'vectorMAC';
    streamingMAC_without_counter_name = 'streamingMAC_without_counter';
    streamingMAC_with_counter_name = 'streamingMAC_with_counter';
    
    isVectorMACcommented = strcmp('on',get_param([blk,'/',VectorMAC_name],'commented'));
    isstreamingMAC_without_countercommented = strcmp('on',get_param([blk,'/',streamingMAC_without_counter_name],'commented'));
    isstreamingMAC_with_countercommented = strcmp('on',get_param([blk,'/',streamingMAC_with_counter_name],'commented'));
    
    initValueSetting = get_param(blk,'initValueSetting'); %for vector mode
    initValueSetting2 = get_param(blk,'initValueSetting2');%for Streaming - using Start and End ports
    initValueSetting3 = get_param(blk,'initValueSetting3');% for Streaming - using Number of Samples
    
    validOut = strcmp(get_param(blk,'validOut'),'on');
    endInandOut = strcmp(get_param(blk,'endInandOut'),'on');
    startOut = strcmp(get_param(blk,'startOut'),'on');
    countOut = strcmp(get_param(blk,'countOut'),'on');
    
    switch opMode
        case 'Vector'
                if isVectorMACcommented
                    if ~isstreamingMAC_without_countercommented  
                        
                        %disconnect without_counter block ports and comment
                        toggle_ports1(blk,'del',streamingMAC_without_counter_name);
                        set_param([blk,'/',streamingMAC_without_counter_name],'commented','on');
                        %uncomment vector block and connect
                        set_param([blk,'/',VectorMAC_name],'commented','off');
                        add_line(blk,'a/1',[VectorMAC_name,'/1']);
                        add_line(blk,'b/1',[VectorMAC_name,'/2']);

                        add_line(blk,[VectorMAC_name,'/1'],'dataOut/1');
                    else
                        %disconnect with_counter block ports and comment
                        toggle_ports2(blk,'del',streamingMAC_with_counter_name);
                        set_param([blk,'/',streamingMAC_with_counter_name],'commented','on');
                        %uncomment vector block and connect
                        set_param([blk,'/',VectorMAC_name],'commented','off');
                        add_line(blk,'a/1',[VectorMAC_name,'/1']);
                        add_line(blk,'b/1',[VectorMAC_name,'/2']);
                        add_line(blk,[VectorMAC_name,'/1'],'dataOut/1');
                    end
                end
                initValInputExists = getSimulinkBlockHandle([blk,'/c']) ~= -1;
                
                %grow port for bias(initvalue)
                if strcmp(initValueSetting,'Input port')
                    if ~initValInputExists
                        add_block('hdlsllib/Sources/In1',[blk,'/c']) ;
                        add_line(blk,'c/1',[VectorMAC_name,'/3']);
                    end
                else
                    if initValInputExists
                        line = get_param(getSimulinkBlockHandle([blk,'/c']),'LineHandles');
                        delete_line(line.Outport);                    
                        delete_block([blk,'/c']) ;
                    end
                end
                
        case 'Streaming - using Start and End ports'
               if ~isVectorMACcommented
                   delete_line(blk,'a/1',[VectorMAC_name,'/1']);
                   delete_line(blk,'b/1',[VectorMAC_name,'/2']);
                   delete_line(blk,[VectorMAC_name,'/1'],'dataOut/1');
                   set_param([blk,'/',VectorMAC_name],'commented','on');
                   %uncomment without_counter block and connect
                   set_param([blk,'/',streamingMAC_without_counter_name],'commented','off');
                   toggle_ports1(blk,'add',streamingMAC_without_counter_name);
               elseif ~isstreamingMAC_with_countercommented
                   toggle_ports2(blk,'del',streamingMAC_with_counter_name);
                    set_param([blk,'/',streamingMAC_with_counter_name],'commented','on');
                    %uncomment without_counter block and connect
                    set_param([blk,'/',streamingMAC_without_counter_name],'commented','off');
                    toggle_ports1(blk,'add',streamingMAC_without_counter_name);

               end
                %grow port for bias(initvalue2)
                initValInputExists = getSimulinkBlockHandle([blk,'/c']) ~= -1;
                if strcmp(initValueSetting2,'Input port')
                    if ~initValInputExists
                        add_block('hdlsllib/Sources/In1',[blk,'/c']) ;
                        add_line(blk,'c/1',[streamingMAC_without_counter_name,'/6']);
                    end
                else
                    if initValInputExists
                        line = get_param(getSimulinkBlockHandle([blk,'/c']),'LineHandles');
                        delete_line(line.Outport);                    
                        delete_block([blk,'/c']) ;
                    end
                end
                %grow ports based on checkboxes
                EndInPortexists = (getSimulinkBlockHandle([blk,'/endIn']) ~= -1) && ~strcmp(get_param(getSimulinkBlockHandle([blk,'/endIn']),'blocktype'),'Ground');
                if endInandOut
                    if ~EndInPortexists
                    replace([blk,'/endIn'],'hdlsllib/Sources/In1');
                    end
                else
                    if EndInPortexists
                    replace([blk,'/endIn'],'hdlsllib/Sources/Ground');
                    end
                end
                
                validOutPortexists = (getSimulinkBlockHandle([blk,'/validOut']) ~= -1) && ~strcmp(get_param(getSimulinkBlockHandle([blk,'/validOut']),'blocktype'),'Terminator');
                if validOut
                    if ~validOutPortexists
                    replace([blk,'/validOut'],'hdlsllib/Sinks/Out1');
                    end
                else
                    if validOutPortexists
                    replace([blk,'/validOut'],'hdlsllib/Sinks/Terminator');
                    end
                end
                
                endOutPortexists = (getSimulinkBlockHandle([blk,'/endOut']) ~= -1) && ~strcmp(get_param(getSimulinkBlockHandle([blk,'/endOut']),'blocktype'),'Terminator');
                if endInandOut
                    if ~endOutPortexists
                    replace([blk,'/endOut'],'hdlsllib/Sinks/Out1');
                    end
                else
                    if endOutPortexists
                    replace([blk,'/endOut'],'hdlsllib/Sinks/Terminator');
                    end
                end
                
                startOutPortexists = (getSimulinkBlockHandle([blk,'/startOut']) ~= -1) && ~strcmp(get_param(getSimulinkBlockHandle([blk,'/startOut']),'blocktype'),'Terminator');
                if startOut
                    if ~startOutPortexists
                    replace([blk,'/startOut'],'hdlsllib/Sinks/Out1');
                    end
                else
                    if startOutPortexists
                    replace([blk,'/startOut'],'hdlsllib/Sinks/Terminator');
                    end
                end
                renumber(blk);
                
        case 'Streaming - using Number of Samples'
           if ~isVectorMACcommented
               delete_line(blk,'a/1',[VectorMAC_name,'/1']);
               delete_line(blk,'b/1',[VectorMAC_name,'/2']);
               delete_line(blk,[VectorMAC_name,'/1'],'dataOut/1');
               set_param([blk,'/',VectorMAC_name],'commented','on');
               %uncomment with_counter block and connect
               set_param([blk,'/',streamingMAC_with_counter_name],'commented','off');
               toggle_ports2(blk,'add',streamingMAC_with_counter_name);
           elseif ~isstreamingMAC_without_countercommented
                toggle_ports1(blk,'del',streamingMAC_without_counter_name);
                set_param([blk,'/',streamingMAC_without_counter_name],'commented','on');
                %uncomment with_counter block and connect
                set_param([blk,'/',streamingMAC_with_counter_name],'commented','off');
                toggle_ports2(blk,'add',streamingMAC_with_counter_name);

               
           end
            %grow port for bias(initvalue)
            initValInputExists = getSimulinkBlockHandle([blk,'/c']) ~= -1;
            if strcmp(initValueSetting3,'Input port')
                if ~initValInputExists
                    add_block('hdlsllib/Sources/In1',[blk,'/c']) ;
                    add_line(blk,'c/1',[streamingMAC_with_counter_name,'/4']);
                end
            else
                if initValInputExists
                    line = get_param(getSimulinkBlockHandle([blk,'/c']),'LineHandles');
                    delete_line(line.Outport);                    
                    delete_block([blk,'/c']) ;
                end
            end
            
            %grow ports based on checkboxes
            validOutPortexists = (getSimulinkBlockHandle([blk,'/validOut']) ~= -1) && ~strcmp(get_param(getSimulinkBlockHandle([blk,'/validOut']),'blocktype'),'Terminator');
            if validOut
                if ~validOutPortexists
                replace([blk,'/validOut'],'hdlsllib/Sinks/Out1');
                end
            else
                if validOutPortexists
                replace([blk,'/validOut'],'hdlsllib/Sinks/Terminator');
                end
            end
            
            countOutPortexists = (getSimulinkBlockHandle([blk,'/countOut']) ~= -1) && ~strcmp(get_param(getSimulinkBlockHandle([blk,'/countOut']),'blocktype'),'Terminator');
            if countOut
                if ~countOutPortexists
                replace([blk,'/countOut'],'hdlsllib/Sinks/Out1');
                end
            else
                if countOutPortexists
                replace([blk,'/countOut'],'hdlsllib/Sinks/Terminator');
                end
            end
            renumber(blk);
            
    end
    
    
    %error out if resettable subsytem is being used with Streaming mode
    if ~strcmp('Vector',opMode)
        find_if_resettable_subsystem_used(blk);
    end

end

function toggle_ports1(blk,add_or_delete,streamingMAC_without_counter_name)
   
    switch add_or_delete
        case 'add'
            %input ports
            add_line(blk,'a/1',[streamingMAC_without_counter_name,'/1']);
            add_line(blk,'b/1',[streamingMAC_without_counter_name,'/2']);

            add_block('hdlsllib/Sources/In1',[blk,'/startIn']) ;
            add_line(blk,'startIn/1',[streamingMAC_without_counter_name,'/3']);
            
            add_block('hdlsllib/Sources/In1',[blk,'/endIn']) ;
            add_line(blk,'endIn/1',[streamingMAC_without_counter_name,'/4']);            
            
            
            add_block('hdlsllib/Sources/In1',[blk,'/validIn']) ;
            add_line(blk,'validIn/1',[streamingMAC_without_counter_name,'/5']);

            %output ports
            add_line(blk,[streamingMAC_without_counter_name,'/1'],'dataOut/1');
            add_block('hdlsllib/Sinks/Out1',[blk,'/startOut'] );
            add_line(blk,[streamingMAC_without_counter_name,'/2'],'startOut/1');
            add_block('hdlsllib/Sinks/Out1',[blk,'/endOut'] );
            add_line(blk,[streamingMAC_without_counter_name,'/3'],'endOut/1');          
            add_block('hdlsllib/Sinks/Out1',[blk,'/validOut'] );
            add_line(blk,[streamingMAC_without_counter_name,'/4'],'validOut/1');
            
        case 'del'
            %input ports
            delete_line(blk,'a/1',[streamingMAC_without_counter_name,'/1']);
            delete_line(blk,'b/1',[streamingMAC_without_counter_name,'/2']);

            delete_line(blk,'startIn/1',[streamingMAC_without_counter_name,'/3']);
            delete_block([blk,'/startIn']) ;        
            delete_line(blk,'endIn/1',[streamingMAC_without_counter_name,'/4']); 
            delete_block([blk,'/endIn']) ;        
            delete_line(blk,'validIn/1',[streamingMAC_without_counter_name,'/5']);
            delete_block([blk,'/validIn']) ;

            %output ports
            delete_line(blk,[streamingMAC_without_counter_name,'/1'],'dataOut/1');        
            delete_line(blk,[streamingMAC_without_counter_name,'/2'],'startOut/1');
            delete_block([blk,'/startOut'] );        
            delete_line(blk,[streamingMAC_without_counter_name,'/3'],'endOut/1');
            delete_block([blk,'/endOut'] );        
            delete_line(blk,[streamingMAC_without_counter_name,'/4'],'validOut/1');
            delete_block([blk,'/validOut'] );

    end
        
end

function toggle_ports2(blk,add_or_delete,streamingMAC_with_counter_name)
    
    switch add_or_delete
        case 'add'
            %input ports
            
            add_line(blk,'a/1',[streamingMAC_with_counter_name,'/1']);
            add_line(blk,'b/1',[streamingMAC_with_counter_name,'/2']);

            add_block('hdlsllib/Sources/In1',[blk,'/validIn']) ;
            add_line(blk,'validIn/1',[streamingMAC_with_counter_name,'/3']);

            %output ports
            add_line(blk,[streamingMAC_with_counter_name,'/1'],'dataOut/1');
            add_block('hdlsllib/Sinks/Out1',[blk,'/endOut'] );
            add_line(blk,[streamingMAC_with_counter_name,'/2'],'endOut/1');
            add_block('hdlsllib/Sinks/Out1',[blk,'/countOut'] );
            add_line(blk,[streamingMAC_with_counter_name,'/3'],'countOut/1');       
            add_block('hdlsllib/Sinks/Out1',[blk,'/validOut'] );        
            add_line(blk,[streamingMAC_with_counter_name,'/4'],'validOut/1');

        case 'del'
            %input ports
            delete_line(blk,'a/1',[streamingMAC_with_counter_name,'/1']);
            delete_line(blk,'b/1',[streamingMAC_with_counter_name,'/2']);
            delete_line(blk,'validIn/1',[streamingMAC_with_counter_name,'/3']);
            delete_block([blk,'/validIn']) ;

            %output ports
            delete_line(blk,[streamingMAC_with_counter_name,'/1'],'dataOut/1');        
            delete_line(blk,[streamingMAC_with_counter_name,'/2'],'endOut/1');
            delete_block([blk,'/endOut'] );       
            delete_line(blk,[streamingMAC_with_counter_name,'/3'],'countOut/1');
            delete_block([blk,'/countOut'] );    
            delete_line(blk,[streamingMAC_with_counter_name,'/4'],'validOut/1');
            delete_block([blk,'/validOut'] );
    end
end         


function replace(oldblock,newblock)
    pos = get_param(oldblock,'Position');
    delete_block(oldblock);    
    add_block(newblock,oldblock,'Position',pos);
end

function renumber(blk)
    pname = 'c';
    new_number = '3';
    h_Inports=find_system(blk,'FindAll','On','SearchDepth',1,'LookUnderMasks','on','BlockType','Inport');
    port_idx = find(strcmp(get_param(h_Inports(:),'name'),pname));
    if(~isempty(port_idx))
        set_param(h_Inports(port_idx),'port',new_number);
    end
    h_Inports=find_system(blk,'FindAll','On','SearchDepth',1,'LookUnderMasks','on','BlockType','Inport');
    port_idx = find(strcmp(get_param(h_Inports(:),'name'),'validIn'));
    if(~isempty(port_idx))
        set_param(h_Inports(port_idx),'port',num2str(length(h_Inports)));
    end
end

function find_if_resettable_subsystem_used(blk)
    parent_blk = get_param(blk,'parent');
    while ~isempty(parent_blk)
        op = Simulink.FindOptions('SearchDepth',2);
        stateControlBlock = Simulink.findBlocksOfType(parent_blk,'StateControl',op);
        ResetBlock = Simulink.findBlocksOfType(parent_blk,'ResetPort',op);
        if  ~isempty(stateControlBlock) && ~isempty(ResetBlock)
            error(message('hdlcoder:validate:MultiplyAccumulateResettableSubsystem'));
        end
        parent_blk = get_param(parent_blk,'parent');
    end
end
