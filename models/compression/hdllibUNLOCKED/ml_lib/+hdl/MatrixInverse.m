classdef MatrixInverse < matlab.System & matlab.system.mixin.Propagates ...
           & matlab.system.mixin.Nondirect & matlab.system.mixin.CustomIcon     
       % Compute the streaming matrix inverse of symmetric positive definite matrix
       % using Cholesky decomposition algorithm.
       % Cholesky decomposition can be done in three stages which are Lower
       % Triangular matrix computation(L), Inverse of Lower Triangular matrix
       % computation using Forward Substitution method(Linv),multiplication of
       % transpose of Linv and Linv
       %              Ainv = transpose(Linv) * Linv
       %
       % Creation of system object for MatrixInverse class
       % M = hdl.MatrixInverse('RowSize',4,'ColumnSize',4,'LatencyStrategyType', 'ZERO')
       %
       % Here RowSize and ColumnSize should be equal and
       % LatencyStrategyType will be either of 'ZERO','MAX','MIN'
       %
       % step method syntax:
       % [dataOut,validOut,ready] = step(M,dataIn,validIn,outEnable)
       %
       % Here input signals are dataIn,validIn, outEnable and
       % output signals are dataOut,validOut,ready. Whenever the
       % ready signal is enabled then only load the input data(dataIn) with validIn into the module
       % After completion of matrix inverse, output data(dataOut) is streamed
       % with validOut when the outEnable signal is enabled.
       %
       % Public, non-tunable properties
       %#codegen

       %   Copyright 2017-2018 The MathWorks, Inc.
    properties(Nontunable)
        %Matrix row size
        RowSize = 4;
        %Matrix column size 
        ColumnSize = 4;        
        %Latency strategy
        LatencyStrategyType = 'ZERO';        
    end
    
    properties(DiscreteState)
        % Discrete state properties-hdl.MatrixInverse
        numRow
        numCol
        invRAM
        accDiagValue
        matInvMem
        inReady
        invDone
        lowerTriangValid
        fwdSubValid
        matMultValid
        outRdy
        regBufLowerTriang
        regPrev
        regBufFwdSub
        regBufMult
        readDataMultBuf
        
        %holding System object output
        countHold
        holdValid
        flagRdyLast
        flagRdyFirst
        countHoldParameter
        pdataOut 
        pvalidOut
        pready
        readDataBuf
        nondiagDataOutLwrTriang
        reciprocalData
        reciprocalValid
        dataOutLowerTriang
        dataOutValidLowerTriang
        isDiagValidInLwrTriang
        isNonDiagValidInLwrTriang
        isNonDiagValidOutLwrTriang
        diagDataOutLwrTriang
        diagValidOutLwrTriang
        
        % Forward substitution
        readDataFwdSubBuf
        nonDiagFwdSubData
        dataOutFwdSub
        dataOutValidFwdSub
        accumDataFwdSub
        diagDataFwdSub
        diagValidFwdSub
        
        % Matrix multiplication
        matMultData
        dataOutMult
        dataOutValidMult
        dotMultBuf
        countOffset1
        countOffset2
        numStages
        endVal
        dataOut
        validOut        
    end
    
        
    properties (Constant, Hidden)        
        LatencyStrategyTypeSet = matlab.system.StringSet({...
            'ZERO',...
            'MIN',...
            'MAX'});         
    end
    
    methods
        % Constructor
        function obj = MatrixInverse(varargin)
            % Support name-value pair arguments when constructing object
            setProperties(obj,nargin,varargin{:});
        end
    end
    
    methods(Access = protected)        
        
        function num = getNumInputsImpl(~)
            % getNumInputsImpl
            % number of inputs accepted
               num = 3; 
        end % getNumInputsImpl

        function num = getNumOutputsImpl(~)
            % getNumOutputsImpl
            % number of outputs
                num  = 3;
        end % getNumOutputsImpl

        function varargout = getInputNamesImpl(obj)

            varargout = cell(1, getNumInputs(obj));
            varargout{1} = 'dataIn';
            varargout{2} = 'validIn';
            varargout{3} = 'outEnable';
        end % getInputNamesImpl

        function varargout = getOutputNamesImpl(obj)

            varargout = cell(1, getNumOutputs(obj));
            varargout{1} ='dataOut';
            varargout{2} ='validOut';
            varargout{3} = 'ready';

        end % getOutputNamesImpl        
    end
    
    

    methods(Access = protected)
        %% Setup implementation function for initializing properties
        function setupImpl(obj,varargin)
           % Initialization the properties of LowerTriangularMatrix computation 
           obj.matInvMem                          = single(zeros(obj.RowSize,obj.ColumnSize));
           obj.nondiagDataOutLwrTriang            = single(0);  
           obj.numCol                             = uint8(1);
           obj.numRow                             = uint8(1);
           obj.isDiagValidInLwrTriang             = cast(0,'like',varargin{2});
           obj.isNonDiagValidInLwrTriang          = cast(0,'like',varargin{2});
           obj.isNonDiagValidOutLwrTriang         = cast(0,'like',varargin{2});
           obj.diagDataOutLwrTriang               = single(0);
           obj.diagValidOutLwrTriang              = cast(0,'like',varargin{2});
           obj.reciprocalData                     = single(0);
           obj.reciprocalValid                    = cast(0,'like',varargin{2});
           obj.invRAM                             = single(zeros(1,obj.RowSize,'like',obj.reciprocalData));
           obj.accDiagValue                       = single(0);
           obj.readDataBuf                        = single(zeros(1,obj.ColumnSize));
           obj.lowerTriangValid                   = cast(0,'like',varargin{2});
           obj.inReady                            = cast(0,'like',varargin{2});
           if obj.ColumnSize > 2
             obj.regBufLowerTriang                = single(zeros(1,obj.ColumnSize-2));
           else
             obj.regBufLowerTriang                = single(zeros(1,1));  
           end 
           obj.regPrev                            = single(zeros(1,1));
           obj.dataOutLowerTriang                 = single(zeros(1,1));
           obj.dataOutValidLowerTriang            = cast(0,'like',varargin{2});
           
           %  Initialization of Forward substitution(Linv) properties 
           obj.fwdSubValid                        = cast(0,'like',varargin{2});   
           obj.readDataFwdSubBuf                  = single(zeros(1,obj.ColumnSize));
           obj.nonDiagFwdSubData                  = single(0);
           obj.diagDataFwdSub                     = single(0);
           obj.diagValidFwdSub                    = cast(0,'like',varargin{2});
           obj.accumDataFwdSub                    = single(zeros(1,1)); 
           obj.dataOutFwdSub                      = single(zeros(1,1));
           obj.dataOutValidFwdSub                 = cast(0,'like',varargin{2});
           if obj.ColumnSize > 1
             obj.regBufFwdSub                     = single(zeros(1,obj.ColumnSize-1));
           else
             obj.regBufFwdSub                     = single(zeros(1,1));    
           end
           
           % Initialization of MatrixMultiplication(Linv'*Linv) properties
           obj.matMultValid                       = cast(0,'like',varargin{2});
           obj.matMultData                        = single(0);
           obj.readDataMultBuf                    = single(zeros(1,obj.ColumnSize));
           obj.outRdy                             = cast(0,'like',varargin{2});
           obj.invDone                            = cast(1,'like',varargin{2});
           obj.pready                             = cast(0,'like',varargin{2});
           obj.pvalidOut                          = cast(0,'like',varargin{2});
           obj.validOut                           = cast(0,'like',varargin{2});

           obj.pdataOut                           = cast(0,'like',varargin{1});
           obj.dataOut                            = cast(0,'like',varargin{1});  

           obj.countOffset1                       = uint8(2);
           obj.countOffset2                       = uint8(1);
           obj.dataOutMult                        = single(zeros(1,1));
           obj.dataOutValidMult                   = cast(0,'like',varargin{2});
           obj.regBufMult                         = single(zeros(1,obj.ColumnSize));   
           obj.dotMultBuf                         = single(zeros(1,obj.ColumnSize));
           % Deciding numStages for tree type addition            
           obj.numStages                          = ceil(log2(obj.ColumnSize));
           % Fixing endVal for tree type addition based on ColumnSize 
           if(bitand(obj.ColumnSize,1) == 1)
             obj.endVal                           = uint8(obj.ColumnSize-2);
           else
             obj.endVal                           = uint8(obj.ColumnSize-1);  
           end
           
           obj.countHold                          = uint16(0);
           obj.holdValid                          = cast(0,'like',varargin{2});
           obj.flagRdyLast                        = cast(0, 'like', varargin{2});
           obj.flagRdyFirst                       = cast(0, 'like', varargin{2});           
        end
        %% outputImpl function for deciding output ports
        function varargout = outputImpl(obj, varargin)
            
            varargout{1}  = obj.pdataOut;           
            varargout{2}  = obj.pvalidOut;
            varargout{3}  = obj.pready;
        end
        %% updateImpl function(top module)
        function updateImpl(obj,varargin)    
            
            dataIn   = varargin{1};
            validIn  = varargin{2};
            outEnb   = varargin{3};
       
            % Control for ready signal which is disabled after complete
            % matrix is stored 
            if obj.invDone
               obj.inReady = cast(1,'like',validIn);
            elseif((obj.numRow==obj.RowSize)&&(obj.numCol==obj.ColumnSize) && obj.inReady && validIn)
               obj.flagRdyFirst = cast(1, 'like', validIn);
               obj.inReady      = cast(0,'like',validIn);
            elseif obj.lowerTriangValid
               obj.flagRdyFirst = cast(0, 'like', validIn);  
            end  
           
            obj.pready     = obj.inReady;           
            % Control for invDone signal which is disabled when ready
            % signal is enabled
            if obj.inReady
               obj.invDone = cast(0,'like',validIn); 
            elseif(obj.flagRdyLast)
               obj.invDone     = cast(1,'like',validIn);
               obj.flagRdyLast = cast(0, 'like', validIn); 
            elseif((obj.numRow==obj.RowSize)&&(obj.numCol==obj.ColumnSize) && obj.outRdy)
               obj.flagRdyLast = cast(1, 'like', validIn);           
            end    
            

            % Input matrix is loaded when validIn,obj.inReady,dataAvail
            % signals are enabled
            if((validIn && obj.inReady) || obj.flagRdyFirst) 
               hdl.MatrixInverse.InputMatrixStoring(obj,dataIn,validIn);
            % Computing the lower triangular matrix(L) when lowerTriangValid
            % signal is enabled
            elseif(obj.lowerTriangValid)
               hdl.MatrixInverse.LowerTriangularComputation(obj);
            % Computing inverse of lower triangular matrix(Linv) using
            % forward substitution method when obj.fwdSubValid is enabled
            elseif(obj.fwdSubValid)
               hdl.MatrixInverse.ForwardSubstitution(obj);
            % Multiplication of transpose(Linv) with Linv when
            % obj.matMultValid is enabled
            elseif(obj.matMultValid)
               hdl.MatrixInverse.LowerTriangMatrixMult(obj);
            % Output matrix(Ainv) will be streamed when processing is
            % completed whenever obj.outRdy,outEnb signals are enabled
            elseif(obj.outRdy && outEnb)
               hdl.MatrixInverse.OutputStreaming(obj,outEnb);  
            end
            % Assigning obj.dataOut,obj.validOut signals which are
            % computed in OutputStreaming module to
            % obj.pdataOut,obj.pvalidOut signals respectively
            if(obj.outRdy && outEnb)
              obj.pdataOut   = cast(obj.dataOut,'like',obj.dataOut);
              obj.pvalidOut  = cast(obj.validOut,'like',obj.validOut);
            else
              obj.pdataOut   = single(0);
              obj.pvalidOut  = cast(0,'like',obj.outRdy);  
            end    
                                      
           %counter to keep track of column number(numCol) and row number(numRow) 
           
           % Counter for numRow and numCol when validIn,obj.inReady,dataAvail
           % signals are enabled(Input matrix storing)
           if((validIn && obj.inReady) || obj.flagRdyFirst)
                if((obj.numRow==obj.RowSize)&&(obj.numCol==obj.ColumnSize))
                       obj.numRow                  = cast(1,'like',obj.numRow);
                       obj.numCol                  = cast(1,'like',obj.numCol);   
                       obj.lowerTriangValid        = cast(1,'like',validIn);
                       
                       % Added run time check for throwing error message for 
                       % non-symmetric positive definite matrices
                       eigVal = eig(obj.matInvMem);
                       symPosDefinete = issymmetric(obj.matInvMem) && isempty(eigVal(eigVal <=0));    
                       assert(symPosDefinete,...
                        'Matrix Inverse using cholesky decomposition supports only symmetric positive definite matrices');
                elseif(obj.numCol==obj.ColumnSize)
                       obj.numRow = cast(obj.numRow+1,'like',obj.numRow);
                       obj.numCol = cast(1,'like',obj.numCol);
                else
                       obj.numRow = obj.numRow;
                       obj.numCol = cast(obj.numCol+1,'like',obj.numCol);  
                end
           % Counter for numRow,numCol when LowerTriangularMatrix computation 
           % is performed
           elseif(obj.lowerTriangValid)
                   if((obj.numRow==obj.RowSize)&&(obj.numCol== obj.ColumnSize))
                       obj.numRow            = cast(1,'like',obj.numRow);
                       obj.numCol            = cast(1,'like',obj.numCol);   
                       % obj.lowerTriangValid is disabled and obj.fwdSubValid
                       % is enabled after completion of Lower Triangular matrix 
                       % computation
                       obj.lowerTriangValid  = cast(0,'like',validIn);
                       obj.fwdSubValid       = cast(1,'like',validIn);  
                   elseif(obj.numCol== obj.numRow)
                       obj.numRow = cast(obj.numRow+1,'like',obj.numRow);
                       obj.numCol = cast(1,'like',obj.numCol);
                   else
                       obj.numRow = obj.numRow;
                       obj.numCol = cast(obj.numCol+1,'like',obj.numCol);  
                   end   
           % Counter for numRow and numCol when ForwardSubstitution  
           % module is enabled     
           elseif(obj.fwdSubValid)
                   if((obj.numRow==obj.RowSize)&&(obj.numCol==1))
                       obj.numRow       = cast(1,'like',obj.numRow);
                       obj.numCol       = cast(1,'like',obj.numCol);   
                       % fwdSubValid is disabled and obj.matMultValid is enabled
                       % after completion of Forward substitution module
                       obj.fwdSubValid  = cast(0,'like',validIn);
                       obj.matMultValid   = cast(1,'like',validIn);  
                   elseif(obj.numCol==1)
                       obj.numRow = cast(obj.numRow+1,'like',obj.numRow);
                       obj.numCol = cast(obj.numRow,'like',obj.numCol);
                   else
                       obj.numRow = obj.numRow;
                       obj.numCol = cast(obj.numCol-1,'like',obj.numCol);  
                   end
           % Counter for numRow and numCol when LowerTriangularMatMult((Linv)'*Linv) 
           % module is enabled     
           elseif(obj.matMultValid)
                   if((obj.numRow==obj.RowSize)&&(obj.numCol==obj.ColumnSize) && obj.matMultValid)
                       obj.numRow          = cast(1,'like',obj.numRow);
                       obj.numCol          = cast(1,'like',obj.numCol);                  
                       % obj.matMultValid is disabled and obj.outRdy signal 
                       % is enabled a when matrix multiplication(transpose(Linv)*Linv) 
                       % is completed
                       obj.holdValid       = cast(1, 'like', obj.holdValid);
                       obj.matMultValid    = cast(0,'like',obj.matMultValid);
                   elseif(obj.numCol==obj.ColumnSize && obj.matMultValid)
                       obj.numRow          = cast(obj.numRow+1,'like',obj.numRow);
                       obj.numCol          = cast(obj.numRow,'like',obj.numCol);              
                   elseif(obj.matMultValid)
                       obj.numRow          = obj.numRow;
                       obj.numCol          = cast(obj.numCol+1,'like',obj.numCol); 
                   end
           elseif(obj.holdValid)
                obj.countHold = cast(obj.countHold+1, 'like', obj.countHold);
                if(obj.countHold == obj.getLatency)   % Zero Latency 82 -4X4
                   obj.holdValid       = cast(0, 'like', obj.holdValid);
                   obj.outRdy          = cast(1,'like',obj.outRdy);
                   obj.countHold       = cast(0, 'like', obj.countHold);
                end    
           % Counter for numRow,numCol when OutputStreaming module is enabled 
           % when obj.outRdy,outEnb signals are high
           elseif(obj.outRdy && outEnb)
                   if((obj.numRow==obj.RowSize)&&(obj.numCol==obj.ColumnSize))
                       obj.numRow    = cast(1,'like',obj.numRow);
                       obj.numCol    = cast(1,'like',obj.numCol);   
                       % obj.outRdy signal is disabled when OutputStreaming
                       % module is completed
                       obj.outRdy                  = cast(0,'like',obj.outRdy);   
                   elseif(obj.numCol==obj.ColumnSize)
                       obj.numRow = cast(obj.numRow+1,'like',obj.numRow);
                       obj.numCol = cast(1,'like',obj.numCol);
                   else
                       obj.numRow = obj.numRow;
                       obj.numCol = cast(obj.numCol+1,'like',obj.numCol);  
                   end              
           end
        end

        function resetImpl(~)
            % Initialize / reset discrete-state properties
        end

        %% Backup/restore functions
        function s = saveObjectImpl(obj)
            % Set properties in structure s to values in object obj

            % Set public properties and states
            s = saveObjectImpl@matlab.System(obj);

            % Set private and protected properties
            %s.myproperty = obj.myproperty;
        end

        function loadObjectImpl(obj,s,wasLocked)
            % Set properties in object obj to values in structure s

            % Set private and protected properties
            % obj.myproperty = s.myproperty; 

            % Set public properties and states
            loadObjectImpl@matlab.System(obj,s,wasLocked);
        end

        %% Simulink functions
        function ds = getDiscreteStateImpl(~)
            % Return structure of properties with DiscreteState attribute
            ds = struct([]);
        end

        function flag = isInputSizeLockedImpl(~,~)
            % Return true if input size is not allowed to change while
            % system is running
            flag = true;
        end
        
        function validatePropertiesImpl(obj)
            
            % Matrices sizes must be less than or equal to 64
            if(~(obj.RowSize <= 64))
                error('Matrix size must be less than or equal to 64');
            end
            % Matrices sizes must be less than or equal to 64
            if(~(obj.ColumnSize <= 64))
                error('Matrix size must be less than or equal to 64');
            end
            % RowSize must be equals to ColumnSize
            if(~(obj.RowSize == obj.ColumnSize))
                error('Matrix RowSize must be equals to matrix ColumnSize');
            end
            
        end

        function [out,out1,out2] = getOutputSizeImpl(obj)
            % Return size for each output port
            out = propagatedInputSize(obj,1);
            out1 = [1 1];
            out2 = [1 1];
            % Example: inherit size from first input port
            % out = propagatedInputSize(obj,1);
        end

        function [out,out1,out2] = getOutputDataTypeImpl(obj)
            % Return data type for each output port
            out  = propagatedInputDataType(obj,1);
            out1 = propagatedInputDataType(obj,2);
            out2 = propagatedInputDataType(obj,2);
        end

        function [out,out1,out2] = isOutputComplexImpl(~)
            % Return true for each output port with complex data
            out  = false;
            out1 = false;
            out2 = false;
            % Example: inherit complexity from first input port
            % out = propagatedInputComplexity(obj,1);
        end

        function [out,out1,out2] = isOutputFixedSizeImpl(~)
            % Return true for each output port with fixed size
            out  = true;
            out1 = true;
            out2 = true;
            % Example: inherit fixed-size status from first input port
            % out = propagatedInputFixedSize(obj,1);
        end
        


        function icon = getIconImpl(obj)
            % Return text as string or cell array of strings for the System
            % block icon
             icon = sprintf('MatrixInverse\n processingLatency: %d',obj.getLatency + ((3*obj.RowSize*(obj.RowSize+1)))/2);
        end
 
        function latency = getLatency(obj)
            
            if(strcmpi(obj.LatencyStrategyType, 'MAX'))
                addLatency   = 11;
                mulLatency   = 8;
                sqrtLatency  = 28;
                recipLatency = 31;
            elseif(strcmpi(obj.LatencyStrategyType, 'MIN'))
                addLatency   = 6;
                mulLatency   = 6;
                sqrtLatency  = 16;
                recipLatency = 16;
            else
                addLatency   = 0;
                mulLatency   = 0;
                sqrtLatency  = 0;
                recipLatency = 0;
            end
            latency = ((2*mulLatency + 3*addLatency+3)*(obj.RowSize*obj.RowSize)+...
                (4*mulLatency+7*addLatency+2*sqrtLatency+2*recipLatency+27)*(obj.RowSize)+...
                -(2*mulLatency+2*addLatency-2) + 2*addLatency*ceil(log2(obj.ColumnSize)))/2;
        end
    end
    %% Function for displaying input/output and optional ports 
    methods (Static, Access = protected)
        function header = getHeaderImpl
            header = matlab.system.display.Header('hdl.MatrixInverse',...
                'Title','Matrix Inverse [Stream]');
        end         
        
        function groups = getPropertyGroupsImpl
           parametersGroup = matlab.system.display.Section(...
             'Title','Parameters',...
             'PropertyList',{'RowSize','ColumnSize', 'LatencyStrategyType'});           
         
           groups = parametersGroup;
        end
        
        function flag = showSimulateUsingImpl
            flag = false;
        end    
    end
    %% This method contains matrix inverse sub modules
    methods (Static, Access=private)
        
        % Input matrix storing
        function InputMatrixStoring(obj,dataIn,validIn)
            if((validIn && obj.inReady) || obj.flagRdyFirst)
                obj.matInvMem(obj.numRow,obj.numCol)  = cast(dataIn,'like',dataIn);                             
            end
        end
        
        % Lower triangular matrix computation(L)
        function  LowerTriangularComputation(obj)
    
            % Lower Triangular Matrix computation
            % diagonal elements computation in LT matrix
            % isDiagValidInLwrTriang property is enabled when Row index is equals to
            % Column index
            if(obj.numRow==obj.numCol && obj.lowerTriangValid)
               obj.isDiagValidInLwrTriang = cast(1,'like',obj.lowerTriangValid);
            else
               obj.isDiagValidInLwrTriang = cast(0,'like',obj.lowerTriangValid);
            end
            % compute square root of diagonal element when numRow and
            % numCol are equals to 1 otherwise compute square root of
            % subtracted data between dataIn and accumulation of squares of
            % Non diagonal elements
            if(obj.isDiagValidInLwrTriang==true)
                if(obj.numCol==1)
                   obj.diagDataOutLwrTriang             = cast((sqrt(abs(obj.matInvMem(obj.numRow,obj.numCol)))),'like',obj.diagDataOutLwrTriang);
                else
                   obj.diagDataOutLwrTriang             = cast((sqrt(abs(obj.matInvMem(obj.numRow,obj.numCol)-(obj.accDiagValue)))),'like',obj.diagDataOutLwrTriang);
                   obj.matInvMem(obj.numRow,obj.numCol) = cast(obj.diagDataOutLwrTriang,'like',obj.diagDataOutLwrTriang); 
                end
                obj.diagValidOutLwrTriang               = cast(1,'like',obj.lowerTriangValid);
            else
                obj.diagDataOutLwrTriang                = cast(0,'like',obj.diagDataOutLwrTriang);
                obj.diagValidOutLwrTriang               = cast(0,'like',obj.lowerTriangValid);
            end 
            % compute inverse(reciprocal(1/x)) of diagonal element
            if(obj.isDiagValidInLwrTriang==true)
                
                if(obj.diagDataOutLwrTriang == 0)
                 obj.reciprocalData                      = cast(0,'like',obj.diagDataOutLwrTriang); 
                else
                 obj.reciprocalData                      = cast((1/obj.diagDataOutLwrTriang),'like',obj.diagDataOutLwrTriang); 
                end
                obj.reciprocalValid                      = cast(1,'like',obj.lowerTriangValid);
            else
                obj.reciprocalData                      = cast(0,'like',obj.diagDataOutLwrTriang);
                obj.reciprocalValid                     = cast(0,'like',obj.lowerTriangValid);
            end 
            % storing of reciprocal of diagonal elements into Register buffer
            if(obj.reciprocalValid==true)
                obj.invRAM(obj.numCol)                  = cast(obj.reciprocalData,'like',obj.reciprocalData);
            end 
            
            % Non-Diagonal elements computation signal isNonDiagValidInLwrTriang when
            % numRow is greater than numCol
            if(obj.numCol<obj.numRow && obj.lowerTriangValid)
               obj.isNonDiagValidInLwrTriang = cast(1,'like',obj.lowerTriangValid);
            else
               obj.isNonDiagValidInLwrTriang = cast(0,'like',obj.lowerTriangValid);
            end

            % Reading previous non diagonal elements from LT memory for computation of
            % current non diagonal element and store the read data values
            % into read data buffer(readDataBuf)
            for i = obj.numCol:obj.numRow-1
                if (obj.numRow >=3 && obj.numCol>=2) && obj.lowerTriangValid
                      obj.readDataBuf(i)      = cast(obj.matInvMem(i,obj.numCol-1),'like',obj.matInvMem(i,obj.numCol-1));
                else
                      obj.readDataBuf      = obj.readDataBuf;
                end
            end
          
            %Finding the individual non diagonal elements multiplications
            %and accumulations(intermediate results),then updating into register buffer
            %respectively for each element in a Row up to diagonal element    

            % Multiplication and accumulation
            if(obj.numCol<obj.numRow && obj.lowerTriangValid)
             for k = obj.numCol:obj.numRow-1 
                if (obj.numRow >= 3 && obj.numCol >= 2)
                     obj.regBufLowerTriang(k-1)                  =  cast(obj.regBufLowerTriang(k-1)   + obj.regPrev * obj.readDataBuf(k),'like',obj.regBufLowerTriang(k-1)); 
                elseif obj.numCol == 1
                     obj.regBufLowerTriang(1:obj.ColumnSize-2)   =  cast(0,'like',obj.regBufLowerTriang(1));                   
                else
                     obj.regBufLowerTriang(k)                    =  obj.regBufLowerTriang(k);
                end    
             end
            end

            % Updating regPrev value by multiplying dataIn with dataInv value
            % when obj.numCol is equals to 1 otherwise RegBuf(obj.numCol-1) value
            % from dataIn and multiplying with dataInv value. This
            % obj.regPrev value will be non diagonal element data in lower
            % triangular matrix
            if(obj.numCol<obj.numRow && obj.lowerTriangValid)
             if obj.numCol == 1 
                obj.regPrev  = cast(obj.matInvMem(obj.numRow,obj.numCol) * obj.invRAM(obj.numCol),'like',obj.regPrev);
             elseif obj.numCol < obj.ColumnSize
                obj.regPrev  = cast((obj.matInvMem(obj.numRow,obj.numCol)-obj.regBufLowerTriang(obj.numCol-1)) * obj.invRAM(obj.numCol),'like',obj.regPrev);
             end
            end
            % Storing non diagonal data into memory 
            if(obj.isNonDiagValidInLwrTriang==true && obj.lowerTriangValid)
               obj.matInvMem(obj.numRow,obj.numCol) = cast(obj.regPrev,'like',obj.regPrev);
               obj.isNonDiagValidOutLwrTriang       = cast(1,'like',obj.lowerTriangValid);
            else
               obj.isNonDiagValidOutLwrTriang       = cast(0,'like',obj.lowerTriangValid);
            end
            
            % Accumulation of squares of NonDiagonal elements to calculate diagonal elements
            if((obj.isNonDiagValidOutLwrTriang == true) && obj.lowerTriangValid)
               obj.accDiagValue = obj.accDiagValue + (obj.regPrev*obj.regPrev);
            elseif(obj.numCol == obj.numRow)
               obj.accDiagValue = single(0);
            else
               obj.accDiagValue = obj.accDiagValue;
            end
        end
        
        % Computation of inverse of Lower triangular matrix(Linv) using
        % Forward Substitution method
        function  ForwardSubstitution(obj)
            
            % Diagonal elements computation in Linv
           
            % Assigning the diagonal elements in Linv will be equals to
            % reciprocal of diagonal elements in L matrix(which are stored
            % in invRAM register buffer)
            if  obj.fwdSubValid && (obj.numRow == obj.numCol)
               obj.diagDataFwdSub                     = obj.invRAM(obj.numCol);
               obj.matInvMem(obj.numRow,obj.numCol)   = obj.diagDataFwdSub; 
               obj.diagValidFwdSub                    = cast(1,'like',obj.fwdSubValid);
            elseif obj.fwdSubValid
               obj.diagDataFwdSub                     = obj.diagDataFwdSub;
               obj.diagValidFwdSub                    = cast(0,'like',obj.fwdSubValid);
            end
           
            % Reading previous non diagonal elements of Linv from  memory 
            % and stored into read data buffer(readDataFwdSubBuf) for computation of current non diagonal element when fwdSubValid
            % property is enabled
            for l = obj.numCol:-1:1
              if obj.numRow > obj.numCol && obj.fwdSubValid 
                 obj.readDataFwdSubBuf(l)          = cast(obj.matInvMem(l,obj.numCol),'like',obj.matInvMem(l,obj.numCol));
              elseif obj.fwdSubValid
                 obj.readDataFwdSubBuf          = obj.readDataFwdSubBuf;
              end
            end        
            
            %Finding the individual non diagonal elements multiplications
            %and accumulations(intermediate results),then updating into register buffer
            %respectively for each element in a Row up to diagonal element    

            % Multiplication and accumulation
            if  obj.fwdSubValid && (obj.numRow > obj.numCol)
             for k = obj.numCol:-1:1 
                if (obj.numRow > obj.numCol) && obj.fwdSubValid
                     if k == obj.numCol
                       obj.regBufFwdSub(k)       =  cast(obj.regBufFwdSub(k)   + obj.matInvMem(obj.numRow,obj.numCol) * obj.readDataFwdSubBuf(k),'like',obj.regBufFwdSub(k));                    
                       obj.accumDataFwdSub       =  cast(obj.regBufFwdSub(k),'like',obj.regBufFwdSub(k));
                       obj.regBufFwdSub(k)       =  cast(0,'like',obj.regBufFwdSub(k));
                     else
                       obj.regBufFwdSub(k)       =  cast(obj.regBufFwdSub(k)   + obj.matInvMem(obj.numRow,obj.numCol) * obj.readDataFwdSubBuf(k),'like',obj.regBufFwdSub(k));    
                     end
                else
                     obj.regBufFwdSub         = obj.regBufFwdSub;
                end    
             end
            end
            % Updating obj.nonDiagFwdSubData by multiplying reciprocal of 
            % diagonal element data of L(obj.invRAM(obj.numRow)) with obj.accumDatawdSub
            if obj.numRow > obj.numCol && obj.fwdSubValid
                if obj.invRAM(obj.numRow) == 0 || obj.accumDataFwdSub == 0
                    obj.nonDiagFwdSubData         = cast(0,'like',obj.dataOutFwdSub);
                else
                    obj.nonDiagFwdSubData         = cast(-obj.invRAM(obj.numRow) * obj.accumDataFwdSub,'like',obj.dataOutFwdSub);
                end
                obj.matInvMem(obj.numRow,obj.numCol)     =  cast(obj.nonDiagFwdSubData,'like',obj.nonDiagFwdSubData);
                obj.matInvMem(obj.numCol,obj.numRow)     =  cast(obj.nonDiagFwdSubData,'like',obj.nonDiagFwdSubData);    
                
            else
                obj.nonDiagFwdSubData         = cast(0,'like',obj.dataOutFwdSub);
            end
        end
        
        % Matrix multiplication of transpose of Linv(Linv') and Linv
        function LowerTriangMatrixMult(obj)
            
            % Reading every column elements(numCol to Rowsize) from memory 
            % and store these elements into register buffer(readDataMultBuf)
            for p = obj.numCol:obj.RowSize
                if(obj.matMultValid)
                  obj.readDataMultBuf(p) = cast(obj.matInvMem(p,obj.numCol),'like',obj.readDataMultBuf(p));
                else  
                  obj.readDataMultBuf = obj.readDataMultBuf;
                end
                % Replacing the readDataMultBuf's index(from 1 to numCol-1) with zero's 
                if (obj.matMultValid && obj.numCol>1)
                  obj.readDataMultBuf(1:obj.numCol-1) = cast(0,'like',obj.readDataMultBuf(1));  
                end    
            end
            
            % Updating RegBuf with readDataBuf when RowIndex is equals to
            % ColumnIndex
            if obj.numCol == obj.numRow && obj.matMultValid
                obj.regBufMult(1:end)             = cast(obj.readDataMultBuf(1:end),'like',obj.regBufMult(1));
            elseif obj.matMultValid
                obj.regBufMult(1:end)             = obj.regBufMult(1:end);
            end
            
            % Performing element wise multiplication between RegBuf and readDataBuf using
            % dot product(.*) operator
            if obj.matMultValid && obj.numCol >= obj.numRow
                obj.dotMultBuf               = cast(obj.regBufMult(1:end) .* obj.readDataMultBuf(1:end),'like',obj.dotMultBuf);     
                % Perform addition of all the elements in dotMultBuf by
                % adding two at a time(tree structure) depending upon
                % number of pipeline stages(obj.numStages)
                for i =1:obj.numStages
                 for j = 1:obj.countOffset1:obj.endVal
                   if((j+obj.countOffset2)<=obj.ColumnSize)
                     obj.dotMultBuf(j) = obj.dotMultBuf(j) + obj.dotMultBuf(j+obj.countOffset2);
                   end
                 end    
                 obj.countOffset1 = cast(obj.countOffset1 * 2,'like',obj.countOffset1);
                 obj.countOffset2 = cast(obj.countOffset2 * 2,'like',obj.countOffset2);
                end
                obj.countOffset1             = cast(2,'like',obj.countOffset1);
                obj.countOffset2             = cast(1,'like',obj.countOffset2);
                % Storing added result into matinvMem
                obj.matInvMem(obj.numRow,obj.numCol) = cast(obj.dotMultBuf(1),'like',obj.dotMultBuf(1));
                obj.matInvMem(obj.numCol,obj.numRow) = cast(obj.dotMultBuf(1),'like',obj.dotMultBuf(1));
            end
        end
        
        % Streaming output matrix(Ainv) after processing is done
        function  OutputStreaming(obj,outEnb)
            % After completion of last stage of Matrix Inverse(Matrix
            % multiplication of Linv' and Linv) dataOut is streaming out with validOut 
            % when outEnb and obj.outReady signals are enabled
            if(obj.outRdy && outEnb)
                obj.dataOut   = cast(obj.matInvMem(obj.numRow,obj.numCol),'like',obj.matInvMem(obj.numRow,obj.numCol));
                obj.validOut  = cast(1,'like',obj.outRdy);
            else
                obj.dataOut   = single(0);
                obj.validOut  = cast(0,'like',obj.outRdy);
            end
        end
    end
end

% LocalWords:  Linv Ainv Enb Rdy pdata pvalid myproperty Lwr Buf Prev Datawd
% LocalWords:  Rowsize Buf's matinv
