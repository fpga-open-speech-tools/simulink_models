classdef MatrixMultiply < matlab.System & matlab.system.mixin.Propagates ...
        & matlab.system.mixin.Nondirect & matlab.system.mixin.CustomIcon
    % Computes the Matrix Multiplication of two streaming matrices
    %
    %   obj = MatrixMultiply creates a Matrix product operation system object with
    %   matrices A = (64*64), B = (64*64) and number of dot products = 1..
    %
    %   Supported dimensions = (1*1) to (64*64) for both A and B.
    %   Number of Dot products available = {1,2,4,8,16,32 and 64}.
    %   Dot product size <= aColumnSize condition should be satisfied.
    
    %   obj = MatrixMultiply(aRow,aCol,bCol,'dotproductSize','latencyStrategy','MajorOrder') creates a Matrix product
    %   operation system object with the object properties inputted by user.
    %
    %   The input parameters to the system object are numeric; the number
    %   of dot products to the object is entered as a string while creating
    %   object using step() function and also latency strategy and matrix majority (provided as a drop down option in
    %   simulink model).
    %   Default input data format is row major order
    %   obj = MatrixMultiply(4,4,4,'2','ZERO','Row');
    %   for column major input data order 
    %   obj = MatrixMultiply(4,4,4,'2','ZERO','Column');
    %  

    %#codegen
    
    %   Copyright 2017-2018 The MathWorks, Inc.
    
    properties(Nontunable)
        
        % Matrix A row size
        aRowSize        = 4;
        % Matrix A column size
        aColumnSize     = 4;
        % Matrix B column size
        bColumnSize     = 4;
        % Dot product size
        dotProductSize  = '2';

    end
    properties
        %Latency strategy
        latencyStrategy = 'MAX';
    end 
    properties(Nontunable)
        % Major Order
        MajorOrder  = 'Row';
    end
    
    % Property to convert dot product from string to integer format
    properties(Access = private,Nontunable)
        dotProductSizeP; % Used in estimating the number of stages to calculate C
        dp; % Used to issue an error during validation of dot product selection
        % To use a single variable, combine the section of code of 'dp' usage into
        % the same method where 'dotProductSizeP' is used
    end
    
    
    % Configurable dot product sizes
    properties(Constant, Hidden)
        dotProductSizeSet = matlab.system.StringSet({'1','2','4','8','16','32','64'});
    end
    properties(Constant, Hidden)
        MajorOrderSet = matlab.system.StringSet({'Row','Column'});
    end    
    % Configurable latencyStrategy
    properties(Constant, Hidden)
        latencyStrategySet = matlab.system.StringSet({'ZERO','MIN','MAX'});
    end
 
    properties(DiscreteState)
        % Number of Rows and columns for matrices A,B and product matrix C
        aRowCounter;
        aColumnCounter;
        bRowCounter;
        bColumnCounter;
        cRowCounter;
        cColumnCounter;
        aReadyP;                    % When high, triggers accepting input Matrix A
        bReadyP;                    % When high, triggers accepting input Matrix B
        cDataP;                     % Output port emitting product matrix C
        cValidP;                    % Output valid flag for cDataP
        cReadyP;                    % When set to high, output of Product matrix C is emitted.
        cRowDone;                   % Flag to indicate completion of one row of C matrix
        aRowStoreDone;              % Flag to indicate completion of loading one row of A matrix
        bMatrixStoreDone;           % Flag to indicate completion of loading of entire B matrix
        aMatrixStoreDone;           % Flag to indicate completion of loading of entire A matrix
        cTotalNumIter;              % Number of stages needed to calculate one element of C
        numRightShift;
        numPipeLineStages;          % Number of pipeline stages to perform the dot product accumulation
        numElemInLastIter;
        aArray;                     % Array storing Sub columns of A
        bArray;                     % Array storing row of B
        % Variables related to accumulation of calculated dot product
        sumOfDotProd;               % Stage wise Accumulator variable
        matProdOut;                 % End stage calculated dot product output
        matProdOutVal;              % Output valid for dot product output
        processEnable;              % Flag to enable or initiate dot product calculation
        processIterCount;           % counter to keep track of number of stages during dot product calculation
        accumReg;
        cMatrixDone;                % Flag indicates that entire C matrix computation is done
        holdValid;
        countHold;
        holdDataValid;
        countHoldData;
        countbReady;
        flagLast;
        readCounter;               % counter to hold the data reading from memory for dp not equal to column in max mode
        aRow;
        bCol;
    end
    
    % Pre-computed constants
    properties(Access = private)
        aMemoryArray;               % Memory to store one row of A
        bMemoryArray;               % Memory to store complete B matrix
        dotProdArray;               % Array to store all dot products in each stage
    end
    
    methods
        % Constructor
        function obj = MatrixMultiply(varargin)
            % Support name-value pair arguments when constructing object
            setProperties(obj,nargin,varargin{:},...
                'aRowSize','aColumnSize','bColumnSize','dotProductSize','latencyStrategy','MajorOrder');
        end % End of constructor
        function set.latencyStrategy(obj, val)
            obj.latencyStrategy = val;
        end
        
    end % End of method
methods(Access = public)
        % 4 design delays  difference for system object and model with no feedback
        % 3 design delays difference for system object and model for feedback path
        % 10(1 design delay added) clock cycle data is held for max mode reading in accumulation
        % 5 (1 design delay added )clock cycle data is held for min mode accumulation
        % actual design delay 9 for dot product size not equal to column
        % size and 5 when dot product size equal to column size.
        % relative latency is used to measure the latency difference
        % between system object and model so that the data has to be hold
        % to occur at the same time steps
        % processingLatency is the latency for processing of each row of
        % matrix .This is measured as soon as the bReady and aReady are
        % De-asserted to start calculation of each row of matrix c
        function [relativeLatency,processingLatency] = getLatency(obj)
            if(strcmpi(obj.latencyStrategy,'MAX'))
                addLatency = 11;
                mulLatency = 8;
                % 1 design delay is added so need only addLatency-1 for balancing feedback path
                if (obj.aColumnSize == coder.const(str2double(obj.dotProductSize)))
                    accumFeedbackLatency = 0;
                    designLatency = 5;
                else
                    accumFeedbackLatency = (addLatency -1);
                    designLatency = 9;
                end
                
            elseif (strcmpi(obj.latencyStrategy,'MIN'))
                addLatency = 6;
                mulLatency = 6;
                % 1 design delay is added so need only addLatency-1 for balancing feedback path
                if (obj.aColumnSize == coder.const(str2double(obj.dotProductSize)))
                    accumFeedbackLatency = 0;
                    designLatency = 5;
                else
                    accumFeedbackLatency = (addLatency -1);
                    designLatency = 9;
                end
            else
                addLatency =0;
                mulLatency = 0;
                accumFeedbackLatency = 0;
                designLatency = 5;
            end
            if (obj.aColumnSize == coder.const(str2double(obj.dotProductSize)))
                relativeLatency = 4;
                iterations = 0;
            else
                relativeLatency = 7;
                iterations = ceil(obj.aColumnSize/coder.const(str2double(obj.dotProductSize)));
            end
            stages = ceil(log2(coder.const(str2double(obj.dotProductSize))));
            relativeLatency = (relativeLatency + mulLatency + ((ceil(log2(coder.const(str2double(obj.dotProductSize)))))*addLatency)+ accumFeedbackLatency);
            pipelineStageLatency = mulLatency + ((stages)*addLatency);
            if (obj.aColumnSize == coder.const(str2double(obj.dotProductSize)))
                processingLatency =  designLatency + accumFeedbackLatency + pipelineStageLatency + iterations * addLatency  + (obj.aColumnSize -1);
            else
                processingLatency =  designLatency + accumFeedbackLatency + pipelineStageLatency + iterations * addLatency +((obj.aColumnSize -1)* (addLatency + 1) * iterations) ;
            end
        end
        
    end
    
    methods(Access = protected)
        % If the input data format is either row major or column major one of the matrix should be stored 
        % Use the matrix B related functions or arrays for storing the
        % complete matrix 
        % if the data input is row major order then use matrix B and B
        % arrays to store the Incoming actual Matrix B( The matrix B from
        % if the data input is column major order then swap signals of
        % Matrix A Signals and Matrix B signals, why because we need to store the complete Matrix A column major Input Matrix
        % In the column major order The actual matrix A (column major format is stored in array
        % B AND The actual matrix of B is stored in row a ARRAY memory
        
        % Set up function / initialization
        function setupImpl(obj,aDataIn,aValidIn,bDataIn,bValidIn,~)
            % if the column major data format is true then swap matrix
            % parameters
            if(strcmpi(obj.MajorOrder,'Column'))
                obj.aRow         = cast(obj.bColumnSize,'like',obj.bColumnSize);
                obj.bCol         = cast(obj.aRowSize,'like',obj.aRowSize);
            else
                obj.aRow         = cast(obj.aRowSize,'like',obj.aRowSize);
                obj.bCol         = cast(obj.bColumnSize,'like',obj.bColumnSize);
            end
            % Convert the selected dp value from string to numeric
            coder.extrinsic('str2double');
            obj.dotProductSizeP = coder.const(str2double(obj.dotProductSize));
            obj.numPipeLineStages = ceil(log2(obj.dotProductSizeP));
            obj.numRightShift     = obj.numPipeLineStages;
            % Initially all the matrices are set to 1st element index (1,1)
            obj.aRowCounter       = uint8(1);
            obj.aColumnCounter    = uint8(1);
            obj.bRowCounter       = uint8(1);
            obj.bColumnCounter    = uint8(1);
            obj.cRowCounter       = uint8(1);
            obj.cColumnCounter    = uint8(1);
            
            % To initiate Matrix product, assume one row of C is calculated
            obj.cRowDone            = cast(false,'like',aValidIn);
            obj.aRowStoreDone       = cast(false,'like',aValidIn);
            obj.bMatrixStoreDone    = cast(false,'like',aValidIn);
            obj.aMatrixStoreDone    = cast(false,'like',aValidIn);
            
            % Estimate the last stage product elements when A column is not
            % a power of 2
            obj.numElemInLastIter	= cast((obj.aColumnSize - ((bitsra(uint8(obj.aColumnSize),obj.numRightShift)) * obj.dotProductSizeP)),'like',obj.aColumnCounter);
            obj.cTotalNumIter       = cast(bitsra(uint8(obj.aColumnSize),obj.numRightShift),'like',obj.aRowCounter);
            
            % When aColumnSize is not a multiple of Dot product, an extra
            % stage is needed to calculate the output element of C
            if(obj.numElemInLastIter == 0)
                obj.cTotalNumIter       = obj.cTotalNumIter;
            else
                obj.cTotalNumIter       = cast(obj.cTotalNumIter + 1,'like',obj.cTotalNumIter);
            end
            
            obj.cMatrixDone             = cast(false,'like',aValidIn);
            
            % Initialize memory arrays with zeros
            obj.aArray                  = zeros(1,obj.dotProductSizeP);
            obj.bArray                  = zeros(1,obj.dotProductSizeP);
            
            % Initialize the accumulation and product related variables to
            % zero
            obj.sumOfDotProd            = cast(0,'like',aDataIn);
            obj.matProdOut              = cast(0,'like',aDataIn);
            obj.matProdOutVal           = cast(false,'like',aValidIn);
            obj.processEnable           = cast(false,'like',aValidIn);
            obj.processIterCount        = uint8(1);
            
            % Initialize output and output valid signals
            obj.cDataP                  = cast(0,'like',aDataIn);
            obj.cValidP                 = cast(false,'like',aValidIn);
            obj.cReadyP                 = cast(false,'like',aValidIn);
            
            % If the input matrices are row or column matrix, initialize
            % aMemory accordingly. If the input matrices are not row/column
            % matrices, initialize the aMemoryArray depending on the matrix
            % configuration selected

            if(strcmpi(obj.MajorOrder,'Column'))
                if(obj.aColumnSize == 1)
                    % Input A is a Column matrix
                    obj.aMemoryArray        = cell(obj.bColumnSize,1);
                    for j = 1 : obj.bColumnSize
                        obj.aMemoryArray{j,1}   = zeros(1,1,'like',aDataIn);
                    end
                else
                    obj.aMemoryArray        = cell(1,1);
                    obj.aMemoryArray{1,1}   = zeros(1,obj.aColumnSize,'like',aDataIn);
                end  
            else
                if(obj.aColumnSize == 1)
                    % Input A is a Column matrix
                    obj.aMemoryArray        = cell(obj.aRowSize,1);
                    for j = 1 : obj.aRowSize
                        obj.aMemoryArray{j,1}   = zeros(1,1,'like',aDataIn);
                    end
                else
                    obj.aMemoryArray        = cell(1,1);
                    obj.aMemoryArray{1,1}   = zeros(1,obj.aColumnSize,'like',aDataIn);
                end
            end
            %{
                Initialize B memory locations with 0 depending on the matrix
                product configuration chosen. Similar to A, first check if
                the input matrices are row/column matrices.
                Initialization changes for row/column matrix inputs
            %}
            if(strcmpi(obj.MajorOrder,'Column'))
                if(obj.aColumnSize == 1)
                    % Input B is a Row matrix
                    obj.bMemoryArray        = cell(1,1);
                    obj.bMemoryArray{1,1}   = zeros(1,obj.aRowSize,'like',aDataIn);
                elseif(obj.aRowSize == 1)
                    % Input B is a column matrix
                    obj.bMemoryArray        = cell(obj.aColumnSize,1);
                    for j = 1 : obj.aColumnSize
                        obj.bMemoryArray{j,1}   = zeros(1,1,'like',aDataIn);
                    end
                else
                    obj.bMemoryArray    = cell(obj.aColumnSize,1);
                    for j = 1:obj.aColumnSize
                        obj.bMemoryArray{j,1} = zeros(1,obj.aRowSize,'like',bDataIn);
                    end
                end
            else
                if(obj.aColumnSize == 1)
                    % Input B is a Row matrix
                    obj.bMemoryArray        = cell(1,1);
                    obj.bMemoryArray{1,1}   = zeros(1,obj.bColumnSize,'like',aDataIn);
                elseif(obj.bColumnSize == 1)
                    % Input B is a column matrix
                    obj.bMemoryArray        = cell(obj.aColumnSize,1);
                    for j = 1 : obj.aColumnSize
                        obj.bMemoryArray{j,1}   = zeros(1,1,'like',aDataIn);
                    end
                else
                    obj.bMemoryArray    = cell(obj.aColumnSize,1);
                    for j = 1:obj.aColumnSize
                        obj.bMemoryArray{j,1} = zeros(1,obj.bColumnSize,'like',bDataIn);
                    end
                end
            end
            obj.dotProdArray        = single(zeros(1,obj.dotProductSizeP));
            obj.accumReg            = cast(0,'like',aDataIn);
            % Trigger ready signals to accept input matrices A and B
            obj.aReadyP             = cast(true,'like',aValidIn);
            obj.bReadyP             = cast(true,'like',bValidIn);
            obj.holdValid = cast(false, 'like', aValidIn);
            obj.countHold = uint8(0);
            obj.holdDataValid = cast(false, 'like', aValidIn);
            obj.countHoldData = 0;
            obj.countbReady = uint8(0);
            obj.flagLast = cast(false, 'like', aValidIn);
            obj.readCounter = uint8(0);
        end % End of setupImpl
    end % End of method
    
    
    methods(Access = protected)
        function updateImpl(obj,varargin)
            % swap matrix A port signals and matrix B ports signals if the
            % column major format is enabled
            % Tap input data into internal storage variables
            if(strcmpi(obj.MajorOrder,'Column'))
                aData    = varargin{3};
                aValid   = varargin{4};
                bData    = varargin{1};
                bValid   = varargin{2};
                cReady   = varargin{5};
            else
                aData    = varargin{1};
                aValid   = varargin{2};
                bData    = varargin{3};
                bValid   = varargin{4};
                cReady   = varargin{5};
            end
            
            obj.cReadyP = cast(cReady,'like',obj.cReadyP);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %             Write input data A into the memory          %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            hdl.MatrixMultiply.writeMatrixA(obj,aValid,aData);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %          Write the input data B into the memory         %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            hdl.MatrixMultiply.writeMatrixB(obj,bValid,bData);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %         Memory Read and Matrix product calculation      %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if(obj.processEnable && obj.cReadyP && (obj.cMatrixDone == 0))
                % Read the A and B inputs from memories
                % Reading and matrix prod operation occurs when product
                % matrix C is not yet computed i.e.obj.cMatrixDone == 0
                if((strcmpi(obj.latencyStrategy,'MAX')  && (obj.aColumnSize ~= obj.dotProductSizeP)))
                    addLatency = 11;
                    if(obj.readCounter == addLatency)
                        [data1,data2]  = hdl.MatrixMultiply.readInpFromMemory(obj);
                        % Perform the Matrix multiplication
                        [obj.matProdOut,obj.matProdOutVal] = hdl.MatrixMultiply.dotProdCalc(obj,data1,data2);
                        obj.cValidP = obj.matProdOutVal;
                        obj.readCounter = uint8(0);
                    else
                        obj.readCounter =cast(obj.readCounter +1,'like',obj.readCounter);
                        %obj.matProdOut = cast(0,'like',obj.matProdOut);
                        obj.matProdOutVal =cast(0,'like',obj.matProdOutVal);
                        obj.cValidP = obj.matProdOutVal;
                        
                    end
                    
                elseif((strcmpi(obj.latencyStrategy,'MIN')  && (obj.aColumnSize ~= obj.dotProductSizeP)))
                    addLatency = 6;
                    if(obj.readCounter == addLatency)
                        [data1,data2]  = hdl.MatrixMultiply.readInpFromMemory(obj);
                        % Perform the Matrix multiplication
                        [obj.matProdOut,obj.matProdOutVal] = hdl.MatrixMultiply.dotProdCalc(obj,data1,data2);
                        obj.cValidP = obj.matProdOutVal;
                        obj.readCounter = uint8(0);
                    else
                        obj.readCounter =cast(obj.readCounter +1,'like',obj.readCounter);
                        %obj.matProdOut = cast(0,'like',obj.matProdOut);
                        obj.matProdOutVal =cast(0,'like',obj.matProdOutVal);
                        obj.cValidP = obj.matProdOutVal;
                        
                    end                   
                else
                    [data1,data2]  = hdl.MatrixMultiply.readInpFromMemory(obj);
                    [obj.matProdOut,obj.matProdOutVal] = hdl.MatrixMultiply.dotProdCalc(obj,data1,data2);
                    obj.cValidP = obj.matProdOutVal;
                end
            else
                obj.matProdOutVal = cast(false,'like',obj.matProdOutVal);
                obj.cValidP = obj.matProdOutVal;
            end
            
            if(obj.cValidP && (obj.cColumnCounter == obj.bCol))
                obj.cRowDone = cast(true,'like',obj.cRowDone);
            elseif((obj.aColumnCounter > 1) && (obj.aColumnCounter < obj.aColumnSize))
                obj.cRowDone = cast(false,'like',obj.cRowDone);
            elseif((obj.cRowCounter > 1) && (obj.cRowCounter <= obj.aRow))
                obj.cRowDone = cast(false,'like',obj.cRowDone);
            else
                obj.cRowDone = cast(false,'like',obj.cRowDone);
            end

            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %                C matrix row/column counter              %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            hdl.MatrixMultiply.cMatRowColCounter(obj);
            
            
            %%%%%%%%%%%%% Assert/ De-assert aReadyP signal %%%%%%%%%%%%%
            
            if(obj.aRowStoreDone && obj.cRowDone && ~obj.holdValid)
                obj.holdValid = cast(true, 'like', obj.holdValid);
            elseif(obj.holdValid)
                obj.countHold = cast(obj.countHold+1, 'like', obj.countHold);
                if(obj.countHold == 3)
                    obj.aReadyP   = cast(true,'like',obj.aReadyP);
                    obj.holdValid = cast(false, 'like', obj.holdValid);
                    obj.countHold = cast(0, 'like', obj.countHold);
                end
            elseif(obj.aRowStoreDone)
                obj.aReadyP = cast(false,'like',obj.aReadyP);
            else
                obj.aReadyP = obj.aReadyP;
            end
            
            %%%%%%%%%%%%% Assert/ De-assert bReadyP signal %%%%%%%%%%%%%
            if(obj.countbReady == 2 && obj.flagLast)
                obj.bReadyP = cast(true,'like',obj.bReadyP);
                obj.flagLast = false;
                obj.countbReady = cast(0, 'like', obj.countbReady);
            elseif(obj.flagLast)
                obj.countbReady = cast(obj.countbReady+1, 'like', obj.countbReady);
            elseif(obj.bMatrixStoreDone && obj.cMatrixDone)
                obj.flagLast = true;
            elseif(obj.bMatrixStoreDone)
                obj.bReadyP = cast(false,'like',obj.bReadyP);
            else
                obj.bReadyP = obj.bReadyP;
            end
            
            % Asserting the enable signal to start DOT product operation
            % Process enable is enabled only when cReady is high, else
            % disabled
            if(obj.aReadyP || obj.bReadyP)
                obj.processEnable = cast(false, 'like', obj.processEnable);
            else  
                if(obj.cRowDone)
                    obj.processEnable = false;
                elseif(obj.aRowStoreDone && obj.bMatrixStoreDone && ~obj.holdDataValid && ~obj.processEnable && ~obj.holdValid)
                    obj.holdDataValid = true;
                elseif(obj.holdDataValid)
                    obj.countHoldData = cast(obj.countHoldData + 1, 'like', obj.countHoldData);
                    if(obj.countHoldData == obj.getLatency()) % 3 is for feedback delay in the accumulator
                        obj.processEnable = true;
                        obj.holdDataValid = false;
                        obj.countHoldData = cast(0, 'like', obj.countHoldData);
                    end
                else
                    obj.processEnable = obj.processEnable;
                end
            end
            
            
        end % End of updateImpl function
        
        function varargout = outputImpl(obj,varargin)
            % Calculate output y as a function of discrete states and
            % direct feedthrough inputs
            varargout{1} = obj.matProdOut;
            varargout{2} = obj.cValidP;
            if(strcmpi(obj.MajorOrder,'Column'))
                varargout{3} = obj.bReadyP;
                varargout{4} = obj.aReadyP;
            else
                varargout{3} = obj.aReadyP;
                varargout{4} = obj.bReadyP;
            end
            %             varargout{5} = obj.aColumnCounter;
        end % End of varargout
    end % End of method
    
    methods(Access = protected)
        function resetImpl(~)
            % Initialize / reset discrete-state properties
        end
        
        function validatePropertiesImpl(obj)
            
            coder.extrinsic('str2double');
            obj.dp = coder.const(str2double(obj.dotProductSize));
            
            % Matrices sizes must be less than or equal to 64
            if(~((obj.aRowSize > 0) && (obj.aRowSize <= 64)))
                error('Matrix size must be a non zero, positive integer value less than or equal to 64');
            end
            
            if(~((obj.bColumnSize > 0) && (obj.bColumnSize <= 64)))
                error('Matrix size must be a non zero, positive integer value less than or equal to 64');
            end
            
            if(obj.aColumnSize < 0)
                error('Matrix size must be a non zero positive integer value');
            elseif(obj.aColumnSize <= 64)
                % Matrix A column size must be greater than or equal to the
                % number of dot products
                
                if(obj.aColumnSize < cast(obj.dp,'like',obj.aColumnSize))
                    error('A matrix Column size/B matrix Row size must be greater than or equal to Dot product');
                end
            else
                error('Matrix size must be less than or equal to 64');
            end
            
        end % validatePropertiesImpl
        
        % Backup/restore functions
        function s = saveObjectImpl(obj)
            % Set properties in structure s to values in object obj
            
            % Set public properties and states
            s = saveObjectImpl@matlab.System(obj);
            
            % Set private and protected properties
            %s.myproperty = obj.myproperty;
        end
        
        function icon = getIconImpl(obj)
            [~,latency] = obj.getLatency();
            icon = sprintf('MatrixMultiplyStream\n processingLatency=%d',latency);
            %icon = sprintf('MatrixMultiplyStream');
        end
        
        function loadObjectImpl(obj,s,wasLocked)
            % Set properties in object obj to values in structure s
            
            % Set private and protected properties
            % obj.myproperty = s.myproperty;
            
            % Set public properties and states
            loadObjectImpl@matlab.System(obj,s,wasLocked);
        end
        
        % Simulink functions
        function ds = getDiscreteStateImpl(~)
            % Return structure of properties with DiscreteState attribute
            ds = struct([]);
        end
        
        function flag = isInputSizeLockedImpl(~,~)
            % Return true if input size is not allowed to change while
            % system is running
            flag = true;
        end
        
        function num = getNumInputsImpl(~)
            % Define total number of inputs for system
            num = 5;
        end
        
        function num = getNumOutputsImpl(~)
            % Define total number of outputs for system
            num = 4;
            %               num = 5;
        end
        
        function [o1,o2,o3,o4] = getOutputSizeImpl(~)
            % Return size for each output port
            o1 = [1 1];
            o2 = [1 1];
            o3 = [1 1];
            o4 = [1 1];
        end
        
        function [out1type,out2type,out3type,out4type] = getOutputDataTypeImpl(obj)
            % Return data type for each output port
            out1type = propagatedInputDataType(obj,1);
            out2type = propagatedInputDataType(obj,2);
            out3type = propagatedInputDataType(obj,2);
            out4type = propagatedInputDataType(obj,2);
            
            % Example: inherit data type from first input port
            % out = propagatedInputDataType(obj,1);
        end
        
        function [out,out2,out3,out4] = isOutputComplexImpl(~)
            % Return true for each output port with complex data
            out     = false;
            out2    = false;
            out3    = false;
            out4    = false;
        end
        
        function [out1,out2,out3,out4] = isOutputFixedSizeImpl(~)
            % Return true for each output port with fixed size
            out1    = true;
            out2    = true;
            out3    = true;
            out4    = true;
        end
        
        function varargout = getInputNamesImpl(obj)
            % Return input port names for System block
            varargout = cell(1,getNumInputs(obj));
            varargout{1} = 'aData';
            varargout{2} = 'aValid';
            varargout{3} = 'bData';
            varargout{4} = 'bValid';
            varargout{5} = 'cReady';
        end
        
        function varargout = getOutputNamesImpl(obj)
            % Return output port names for System block
            varargout = cell(1,getNumOutputs(obj));
            varargout{1} = 'cData';
            varargout{2} = 'cValid';
            varargout{3} = 'aReady';
            varargout{4} = 'bReady';
            %             varargout{5} = 'aColumnCounter';
        end
        
    end %End of methods(Access = protected)
    methods(Static, Access=protected)
        function header = getHeaderImpl
            header = matlab.system.display.Header('hdl.MatrixMultiply', ...
                'ShowSourceLink', true, ...
                'Title', 'Matrix Multiply [Stream]',...
                'Text', sprintf('Computes the Matrix Multiplication of two streaming matrices'));
        end
        function groups = getPropertyGroupsImpl
            parametersGroup = matlab.system.display.Section(...
                'Title','Parameters',...
                'PropertyList',{'aRowSize','aColumnSize','bColumnSize','dotProductSize','latencyStrategy','MajorOrder'});
            groups = parametersGroup;
        end
                function flag = showSimulateUsingImpl
                    flag = false;
                end
    end
    
    %Define all instantiated functions here
    methods(Static, Access = private)
        
        %{
            Consider  A = 3 * 9, B = 9 * 5
            Matrix A    a11 a12 ... a19 --> Row1
                        a21 a22 ... a29 --> Row2
                        a31 a32 ... a39 --> Row3

            Matrix B    b11 b12 ... b15 --> Row1
                        b21 b22 ... b25 --> Row1
                        ..  ..  ..  ..
                        ..  ..  ..  ..
                        b91 b92 ..  b95 --> Row9
             
            Row Major inputs A and B arrive as shown below
            [a11,a12,...,a19,a21,a22,...,a29,a31,a32,...,a39]
            [b11,b12,..,b15,b21,b22,..,b25,b31,b32,..,b35,.....,b91,b92,..,b95]

            Column Major inputs A and B arrive as shown below
            [a11,a21,a31,a12,a22,a32,a13,a23,a33,.............,a19,a29,a39]
            [b11,b21,b31,...,b91,b12,b22,b32,....,b92,b15,b25,b35,....b95]
        
        %}
        
        %%%%%%%  Function to write A matrix data into memories %%%%%%%
        function writeMatrixA(obj,dataValidA,dataInpA)
            
            % A matrix Row/Column counter
            % Storage details for each approach explained at the end of
            % this if else condition
            if (obj.cRowDone)
                obj.aRowCounter         = cast(1,'like',obj.aRowCounter);
                obj.aColumnCounter      = cast(1,'like',obj.aColumnCounter);
                obj.aRowStoreDone       = cast(false,'like',obj.aRowStoreDone);
                obj.aMatrixStoreDone    = cast(false,'like',obj.aMatrixStoreDone);
                
            elseif(obj.aReadyP && dataValidA)
                % Row Column tracker for A Matrix
                obj.aMemoryArray{1,1}(obj.aColumnCounter) = dataInpA;
                if((obj.aRowCounter == obj.aRow) && ...
                        (obj.aColumnCounter == obj.aColumnSize))
                    % Assert complete matrix A is loaded
                    obj.aRowCounter         = cast(1,'like',obj.aRowCounter);
                    obj.aColumnCounter      = cast(1,'like',obj.aColumnCounter);
                    obj.aRowStoreDone       = cast(true,'like',obj.aRowStoreDone);
                    obj.aMatrixStoreDone    = cast(true,'like',obj.aMatrixStoreDone);
                    
                elseif(obj.aColumnCounter == obj.aColumnSize)
                    % Assert one ROW of matrix A is loaded
                    obj.aRowCounter         = obj.aRowCounter + 1;
                    obj.aColumnCounter      = cast(1,'like',obj.aColumnCounter);
                    obj.aRowStoreDone       = cast(true,'like',obj.aRowStoreDone);
                    obj.aMatrixStoreDone    = cast(false,'like',obj.aMatrixStoreDone);
                    
                else
                    obj.aRowCounter         = obj.aRowCounter;
                    obj.aColumnCounter      = obj.aColumnCounter + 1;
                    obj.aRowStoreDone       = cast(false,'like',obj.aRowStoreDone);
                    obj.aMatrixStoreDone    = cast(false,'like',obj.aMatrixStoreDone);
                end
                
            else
                obj.aRowCounter         = obj.aRowCounter;
                obj.aColumnCounter      = obj.aColumnCounter;
                obj.aRowStoreDone       = obj.aRowStoreDone;
                obj.aMatrixStoreDone    = obj.aMatrixStoreDone;
                
            end % End of matrix A row and column counter
            
            % Store A data input into the cells
            %{
                One row of A is stored. If A = 3*9, then
                aStoreArray = cell(1,1) with each row containing 9 elements
                aStoreArray{1} = [a11 a12 ...... a19]

                
            %}
            
        end    % End of writeMatrixA function
        
        
        %%%%%%% Function to write Matrix B into Memory %%%%%%%
        function writeMatrixB(obj,dataValidB,dataInpB)
            % countResetFlag ==> cMatrixDone signal
            % Row and column counter for matrix B.
            % Store each row of B individually
            
            if(obj.cMatrixDone)
                obj.bMatrixStoreDone  = cast(false,'like',obj.bMatrixStoreDone);
                obj.bRowCounter       = cast(1,'like',obj.bRowCounter);
                obj.bColumnCounter    = cast(1,'like',obj.bColumnCounter);
                
            elseif(dataValidB && obj.bReadyP)
                obj.bMemoryArray{obj.bRowCounter,1}(obj.bColumnCounter) = dataInpB;                
                if((obj.bRowCounter == obj.aColumnSize) && (obj.bColumnCounter == obj.bCol))
                    % Assert loading of complete B matrix,reset indices
                    obj.bRowCounter       = cast(1,'like',obj.bRowCounter);
                    obj.bColumnCounter    = cast(1,'like',obj.bColumnCounter);
                    obj.bMatrixStoreDone  = cast(true,'like',obj.bMatrixStoreDone);                    
                elseif(obj.bColumnCounter == obj.bCol)
                    % Assert loading of each row of B matrix
                    obj.bRowCounter       = obj.bRowCounter + 1;
                    obj.bColumnCounter    = cast(1,'like',obj.bColumnCounter);
                    obj.bMatrixStoreDone  = cast(false,'like',obj.bMatrixStoreDone);
                else
                    obj.bRowCounter       = obj.bRowCounter;
                    obj.bColumnCounter    = obj.bColumnCounter + 1;
                    obj.bMatrixStoreDone  = cast(false,'like',obj.bMatrixStoreDone);
                end                
            else
                obj.bRowCounter         = obj.bRowCounter;
                obj.bColumnCounter      = obj.bColumnCounter;
                obj.bMatrixStoreDone    = obj.bMatrixStoreDone;                
            end % End of row/column counter for matrix B            
        end  % End of writeMatrixB function
        
        %%%%%%%  C matrix row/column counter %%%%%%%
        function cMatRowColCounter(obj)
            
            if(obj.cValidP && obj.cReadyP && ~obj.holdValid)
                if((obj.cRowCounter == obj.aRow) && (obj.cColumnCounter == obj.bCol))
                    % Completion of C matrix calculation, reset indices
                    obj.cRowCounter   	= cast(1,'like',obj.cRowCounter);
                    obj.cColumnCounter 	= cast(1,'like',obj.cColumnCounter);
                    obj.cMatrixDone    	= cast(true,'like',obj.matProdOutVal);
                    
                elseif((obj.cColumnCounter == obj.bCol))
                    % Completion of each row of C
                    obj.cRowCounter    	= obj.cRowCounter + 1;
                    obj.cColumnCounter 	= cast(1,'like',obj.cColumnCounter);
                    obj.cMatrixDone    	= cast(false,'like',obj.matProdOutVal);
                    
                else
                    obj.cRowCounter 	= obj.cRowCounter;
                    obj.cColumnCounter 	= obj.cColumnCounter + 1;
                    obj.cMatrixDone    	= cast(false,'like',obj.matProdOutVal);
                end
                
            else
                obj.cRowCounter         = obj.cRowCounter;
                obj.cColumnCounter      = obj.cColumnCounter;
                obj.cMatrixDone         = cast(false,'like',obj.matProdOutVal);
            end
            
        end % End of C matrix row/column counter
        
        
        %%%%%%% Read A and B matrix data elements %%%%%%%
        function [a,b] = readInpFromMemory(obj)
            if(obj.processEnable && obj.cReadyP)               
                if( (obj.processIterCount <= obj.cTotalNumIter))
                    for i = 1 : obj.dotProductSizeP
                        % If the number of Multipliers equals aColumnSize/BrowSize,
                        % the element index value is same for A and B matrices
                        if(obj.aColumnSize == obj.dotProductSizeP)
                            rowIndBMat = i;
                        else
                            %rowIndBMat = i + ((obj.processIterCount-1) * obj.dotProductSizeP);
                            rowIndBMat = obj.processIterCount + (obj.cTotalNumIter * (i - 1));
                        end                        
                        if(rowIndBMat <= obj.aColumnSize)
                            obj.aArray(1,i) = obj.aMemoryArray{1,1}(rowIndBMat);
                            obj.bArray(1,i) = obj.bMemoryArray{rowIndBMat,1}(obj.cColumnCounter);
                        else
                            obj.aArray(1,i) = cast(0,'like',obj.aArray);
                            obj.bArray(1,i) = cast(0,'like',obj.bArray);
                        end
                        
                    end % for loop
                end
                
            end % if else - process enable condition
            
            a   =  obj.aArray;
            b   =  obj.bArray;
            
        end % End of A and B data read
        
        
        %%%%%%% Dot product calculation and accumulation %%%%%%%
        function [resultData,resultDataVal] = dotProdCalc(obj,aIn,bIn)
            
            if(obj.processEnable && obj.cReadyP)
                % Stage wise product matrix C Calculation
                if(obj.processIterCount < obj.cTotalNumIter)
                    % for dot product 1, only one dot product is
                    % performed per iteration
                    if(obj.dotProductSizeP == 1)
                        obj.dotProdArray    = obj.dotProdArray + (aIn .* bIn); % dot prod
                        obj.accumReg        = obj.dotProdArray(1,1); % Accumulation
                    else
                        obj.dotProdArray(1,:) = aIn .* bIn;  % dot product calculation
                        
                        % Accumulation of calculated dot products
                        % If the dot prod array size is 8, number of
                        % pipeline stages is 3.
                        %
                        % Stage1 : dotprod{1} = dotprod{1} + dotprod{2}
                        %          dotprod{3} = dotprod{3} + dotprod{4}
                        %          dotprod{5} = dotprod{5} + dotprod{6}
                        %          dotprod{7} = dotprod{7} + dotprod{8}
                        %
                        % Stage2 : dotprod{1} = dotprod{1} + dotprod{3}
                        %          dotprod{5} = dotprod{5} + dotprod{7}
                        %
                        % Stage3 : dotprod{1} = dotprod{1} + dotprod{5}
                        %
                        % During the final pipeline stage, dotprod{1} has
                        % matrix product output element.
                        
                        for i = 1 : obj.numPipeLineStages
                            
                            index1 = bitsll(1,i);
                            index2 = index1 - bitsll(1,(i-1));
                            for j = 1 : index1 : obj.dotProductSizeP
                                if((j <= obj.dotProductSizeP) && ((j+index2) <= obj.dotProductSizeP))
                                    obj.dotProdArray(1,j) = obj.dotProdArray(1,j)+ obj.dotProdArray(1,(j+index2));
                                end
                            end
                        end % end of for loop
                        
                        obj.accumReg = cast((obj.accumReg + obj.dotProdArray(1,1)),'like',obj.accumReg);
                        
                    end % end of if else
                    
                    obj.sumOfDotProd       = cast(obj.accumReg,'like',obj.accumReg);
                    obj.processIterCount   = cast(obj.processIterCount + 1,'like',obj.processIterCount);
                    obj.matProdOutVal      = cast(false,'like',obj.matProdOutVal);
                    
                elseif(obj.processIterCount == obj.cTotalNumIter)
                    % Dot product calculation
                    obj.dotProdArray(1,:)	= aIn .* bIn;
                    
                    % Accumulation
                    if(obj.dotProductSizeP == 1)
                        obj.dotProdArray = obj.dotProdArray;
                        obj.accumReg = obj.accumReg + obj.dotProdArray(1,1);
                    else
                        for i = 1 : obj.numPipeLineStages
                            index1 = bitsll(1,i);
                            index2 = index1 - bitsll(1,(i-1));
                            for j = 1 : index1 : obj.dotProductSizeP
                                if((j <= obj.dotProductSizeP) && ((j+index2) <= obj.dotProductSizeP))
                                    obj.dotProdArray(1,j) = obj.dotProdArray(1,j)+ obj.dotProdArray(1,(j+index2));
                                end
                            end
                        end % end of for loop
                        obj.accumReg = obj.accumReg + obj.dotProdArray(1,1);
                    end
                    
                    % Accumulate last stage sum with the previous sum value
                    obj.sumOfDotProd          = cast(obj.accumReg,'like',obj.sumOfDotProd);
                    obj.matProdOut            = cast(obj.sumOfDotProd,'like',obj.matProdOut);
                    obj.matProdOutVal         = cast(true,'like',obj.matProdOutVal);
                    
                    % Reset the variables to initial value before next iteration
                    obj.dotProdArray          = cast(zeros(1,obj.dotProductSizeP),'like',obj.dotProdArray);
                    obj.sumOfDotProd          = cast(0,'like',obj.sumOfDotProd);
                    obj.accumReg              = cast(0,'like',obj.sumOfDotProd);
                    obj.processIterCount      = cast(1,'like',obj.cTotalNumIter);
                end
            else
                obj.matProdOutVal = cast(false,'like',obj.matProdOutVal);
            end
            
            resultData      = obj.matProdOut;
            resultDataVal   = obj.matProdOutVal;
            
        end % End of dot product calculation and accumulation function
        
    end  	% End of static method
    
end

% LocalWords:  dp Inp appr myproperty BMat dotproduct
