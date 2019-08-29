classdef (StrictDefaults)RAM < matlab.System & matlab.system.mixin.Nondirect...
        & matlab.system.mixin.CustomIcon
    % hdl.RAM Use RAM to read from and write to memory locations.
    %
    %   H = hdl.RAM creates a single port RAM System object. This object
    %   allows you to read from or write to a memory location in the
    %   RAM. The output data port corresponds to the read/write address
    %   passed in.
    %
    %   H = hdl.RAM('RAMType', 'Single port', 'WriteOutputValue',
    %   'Old data', 'RAMInitialValue', [0:31]) creates a single port RAM
    %   System object. This object allows you to read from or write to a
    %   memory location in the RAM. The RAM is initialized with the data [0:31].
    %   The output data port corresponds to the read/write address passed
    %   in. During a write operation, the old data at the write address is
    %   sent out as the output.
    %
    %   H = hdl.RAM('RAMType', 'Simple dual port') creates a simple
    %   dual port RAM System object. This object allows you to read from
    %   and write to different memory locations in the RAM. The output data
    %   port corresponds to the read address. If a read operation is
    %   performed at the same address as the write operation, old data at
    %   that address is read out as the output.
    %
    %   H = hdl.RAM('RAMType', 'Dual port', 'WriteOutputValue', 'New data')
    %   creates a dual port RAM System object. This object
    %   allows you to read from and write to different memory locations in
    %   the RAM. There are two output ports, a write output data port and a
    %   read output data port. The write output data port sends out the new
    %   data at the write address. The read output data port sends out the
    %   old data at the read address.
    %
    %   The type of input data to the step method determines RAM module
    %   instantiation:
    %       'scalar' - single RAM module instantiation
    %       'vector' - RAM banks instantiation. The number of RAM banks
    %       is inferred from the number of elements in the input vector.
    %       Either all inputs to the step method must have consistent
    %       sizes, or the first input (write data) must be a vector while all other
    %       inputs are scalars.
    %   The input can also be complex.
    %
    %   The size of the RAM is determined based on the size of the address.
    %   The size of each RAM bank, in the case of vector input, is
    %   determined based on the size of the address element in the address
    %   input vector. If the data type of the address is single or double,
    %   the size of the RAM is set to 2^16 locations; RAM size in general
    %   defaults to 16 bits, which covers most use cases. RAM size can
    %   significantly affect your simulations, and if you don't need 32
    %   bits, always specify the address bus by the correct fi-type, up to
    %   32 bits.
    %
    %   The output data is delayed by one step.
    %
    %   Step method syntax:
    %
    %   For a Single port RAM:
    %       DATAOUT = step(H, WRITEDATA, ...
    %                         READWRITEADDRESS, ...
    %                         WRITEENABLE)
    %   allows you to read the value in memory location READWRITEADDRESS
    %   when WRITEENABLE is false, or write the value WRITEDATA into
    %   the memory location READWRITEADDRESS when WRITEENABLE is
    %   true. DATAOUT is the new or old data at the READWRITEADDRESS
    %   when WRITEENABLE is true, or the data at READWRITEADDRESS
    %   when WRITEENABLE is false.
    %
    %   For a simple dual port RAM:
    %       READDATAOUT = step(H, WRITEDATA,
    %                             WRITEADDRESS, ...
    %                             WRITEENABLE, ...
    %                             READADDRESS)
    %   allows you to write the value WRITEDATA into memory location
    %   WRITEADDRESS when WRITEENABLE is true. READDATAOUT is the
    %   old data at the address location READADDRESS.
    %
    %   For a dual port RAM:
    %       [WRITEDATAOUT, READDATAOUT] = step(H, WRITEDATA, ...
    %                                             WRITEADDRESS, ...
    %                                             WRITEENABLE, ...
    %                                             READADDRESS)
    %   allows you to write the value WRITEDATA into the memory location
    %   WRITEADDRESS when WRITEENABLE is true. WRITEDATAOUT is the
    %   new or old data at memory location WRITEADDRESS. READDATAOUT
    %   is the old data at the address location READADDRESS.
    %
    %   System objects may be called directly like a function instead of
    %   using the step method. For example, y = step(obj, x) and y = obj(x)
    %   are equivalent.
    %
    %
    %   hdl.RAM Input Requirements:
    %
    %   WRITEDATA must be scalar, can be double, single, integer, or
    %   a fixed-point (fi) object, and can be real or complex.
    %
    %   WRITEENABLE must be a scalar value.
    %
    %   WRITEADDRESS and READADDRESS must be scalar, real and unsigned, and
    %   can be double, single, integer, or a fixed-point (fi) object.
    %
    %
    %   hdl.RAM methods:
    %
    %   step     - Read from or write input value to a memory location (see
    %              above)
    %   release  - Allow property value and input characteristics
    %              changes
    %   clone    - Create hdl.RAM object with same property values
    %   isLocked - Locked status (logical)
    %
    %
    %   hdl.RAM properties:
    %
    %   RAMType          - Specify the type of RAM to be created
    %                      'Single port'       (default) 
    %                                          creates a single port RAM, 
    %                                          with 3 inputs, Write Data,
    %                                          Write address, Write enable 
    %                                          and 1 output, Read/Write 
    %                                          Data
    %                      'Simple dual port'  creates a simple dual port 
    %                                          RAM, with 4 inputs, 
    %                                          Write Data, 
    %                                          Read/Write address, 
    %                                          Write enable, Read address,
    %                                          and 1 output, Read Data
    %                      'Dual port'         creates a dual port RAM, 
    %                                          with 4 inputs, Write Data, 
    %                                          Read/Write address, 
    %                                          Write enable, Read address, 
    %                                          and 2 outputs, Write Data, 
    %                                          Read Data
    %   WriteOutputValue - Specify the behavior for the Write output port
    %                      for the Single port and Dual port RAMs
    %                      'New data' (default)  sends out new data at the 
    %                                            address to the output
    %                      'Old data'            sends out old data at the 
    %                                            address to the output
    %   RAMInitialValue  - Supply initial values for the RAM
    %                        0 (default) initializes every location to 0
    %                        A scalar initial value will initialize each
    %                        RAM location to the value. A one dimensional 
    %                        array of values with the same number of 
    %                        elements as the RAM will initialize the RAM 
    %                        with the contents of the array.
    %
    %   % Example:
    %   % Write to a Single port RAM and read the newly written value out
    %   % Output data is delayed one step with respect to input data
    %   hRAM = hdl.RAM('RAMType', 'Single port', ...
    %                 'WriteOutputValue', 'New data');
    %
    %   % Pre-allocate memory
    %   dataLength    = 100;
    %   [dataIn, dataOut] = deal(zeros(1,dataLength));
    %   for ii = 1:dataLength
    %     dataIn(ii)  = randi([0 63],1,1,'uint8');
    %     addressIn   = uint8(ii-1);
    %     writeEnable = true;
    %     dataOut(ii) = hRAM(dataIn(ii), addressIn, writeEnable);
    %   end
    %

    %   Copyright 2011-2017 The MathWorks, Inc.

    %#codegen
    %#ok<*EMCLS>

    properties (Nontunable)
        % RAMType Specify the type of RAM
        %   Specify the RAM type to be one of 'Single port' |
        %   'Simple dual port' | 'Dual port'
        %   The default is 'Single port'
        RAMType = 'Single port';
        % WriteOutputValue Specify the output data for a write operation
        %   Specify WriteOutputValue to be one of 'New data' | 'Old data'
        %   When the WriteOutputValue is set to 'New data', during a write
        %   operation, the new data sent in to be written appears at the
        %   write output port.
        %   When the WriteOutputValue is set to 'Old data', during a write
        %   operation, the old data at the write address appears at the
        %   write output port.
        %   This property applies when you set the RAMType to 'Single port'
        %   or 'Dual port'.
        %   The default is 'New data'.
        WriteOutputValue = 'New data';
        % RAMInitialValue Specify the RAM initial value
        RAMInitialValue = 0;
    end

    % Enumerations provide faster matching than corresponding string properties
    % and we update them during setupImpl()
    properties (Nontunable,Hidden)
        % make these internal values index into the corresponding public
        % properties
        EnumRAMType = 1;
        EnumWriteOutputValue = 1;
        NumBanks = 0; % intentionally invalid

        % Flag to unionize read, write addresses if both are fixed-point but
        % have different numerictype. NOTE: this is applicable only for 'Simple
        % dual port' and 'Dual port' RAMTypes only, and it never changes from 1.
        UnionizeAddresses = 1;
        
        RamSize = 1;
        RamBankSize = 1;
        NumAddressBits = 1;
    end

    properties (Constant, Hidden)
        % RAMType property
        RAMTypeSet = matlab.system.StringSet({...
            'Single port',...
            'Simple dual port',...
            'Dual port'});

        % WriteOutputValue property
        WriteOutputValueSet = matlab.system.StringSet({...
            'New data',...
            'Old data'});
    end

    properties (Access=private)
        % Remove discrete state property in lieu of simulation speedup
        % requests.

        % pRAM RAM memory.
        % Stores data that is sent in to be written
        pRAM

        % pOutData Delayed output data.
        % Stores output for read/write output port in the next step.
        % This simulates the one clock delay in RAM data access.
        pOutData

        % pOutWriteData Delayed output write data.
        % Stores output for write output port in the next step. This
        % simulates the one clock delay in RAM data access.
        pOutWriteData

        % pOutReadData Delayed output read data.
        % Stores output for read output port in the next step. This
        % simulates the one clock delay in RAM data access.
        pOutReadData
    end



    methods
        function obj = RAM(varargin)
            
        %if nargin > 0
        %        [varargin{:}] = convertStringsToChars(varargin{:});
        %end
            
            % RAMType and WriteOutputValue can also be specified without
            % the pv-pair interface
            setProperties(obj, nargin, varargin{:}, ...
                'RAMType', 'WriteOutputValue', 'RAMInitialValue');
        end % hdl.RAM


        function set.RAMType(obj, val)
            obj.RAMType = val;

            if strcmpi(val,'Single port')
                obj.EnumRAMType = 1; %#ok<MCSUP>
            elseif strcmpi(val,'Simple dual port')
                obj.EnumRAMType = 2; %#ok<MCSUP>
            else
                obj.EnumRAMType = 3; %#ok<MCSUP>
            end % switch-case (RAMType)
        end

        function set.WriteOutputValue(obj, val)
            obj.WriteOutputValue = val;
            if strcmpi(val, 'New data')
                obj.EnumWriteOutputValue = 1; %#ok<MCSUP>
            else
                obj.EnumWriteOutputValue = 2; %#ok<MCSUP>
            end
        end
    end

    
    
    methods(Access = protected) %Impls
        function num = getNumInputsImpl(obj)
            % getNumInputsImpl
            % number of inputs accepted
            switch(obj.EnumRAMType)
                case 1
                    num = 3;
                case 2
                    num = 4;
                case 3
                    num = 4;
            end % switch-case (EnumRAMType)
        end % getNumInputsImpl

        function num = getNumOutputsImpl(obj)
            % getNumOutputsImpl
            % number of outputs
            switch(obj.EnumRAMType)
                case 1
                    num = 1;
                case 2
                    num = 1;
                case 3
                    num = 2;
            end % switch-case (EnumRAMType)
        end % getNumOutputsImpl

        function icon = getIconImpl(obj)
            switch(obj.EnumRAMType)
                case 1
                    icon = sprintf('Single Port\nRAM');
                case 2
                    icon = sprintf('Simple\nDual Port\nRAM');
                case 3
                    icon = sprintf('Dual Port\nRAM');
            end % switch-case (EnumRAMType)
        end

        function varargout = getInputNamesImpl(obj)

            varargout = cell(1, getNumInputs(obj));
            varargout{1} = 'din';
            varargout{3} = 'wr_en';
            switch(obj.EnumRAMType)
                case 1
                    varargout{2} = 'addr';
                otherwise % Simple dual port or dual port
                    varargout{2} = 'wr_addr';
                    varargout{4} = 'rd_addr';
            end % switch-case (EnumRAMType)
        end % getInputNamesImpl

        function varargout = getOutputNamesImpl(obj)

            varargout = cell(1, getNumOutputs(obj));
            switch(obj.EnumRAMType)
                case 1
                    varargout{1} = 'dout';
                case 2
                    varargout{1} = 'rd_dout';
                otherwise % Simple dual port or dual port
                    varargout{1} = 'wr_dout';
                    varargout{2} = 'rd_dout';
            end % switch-case (EnumRAMType)
        end % getOutputNamesImpl

        function flag = isInactivePropertyImpl(obj, prop)
            % isInactivePropertyImpl
            % Output is true if the property passed in is inactive
            % Only one inactive case: WriteOutputValue when RAMType is
            % Simple dual port
            flag = obj.EnumRAMType == 2 && strcmp(prop, 'WriteOutputValue');
        end % isInactivePropertyImpl

        function validateInputsImpl(obj, data_in, addr, wr_en, varargin)
            % validateInputsImpl
            % Input validation
            % All inputs should be scalar
            % Data can be single, double, uint, int or fi
            % Addresses should be unsigned and between 2 and 32 bits (inclusive)
            % Read and write addresses should have the same data type
            hdl.RAM.validateRAMWriteData(data_in);
            hdl.RAM.validateRAMWriteEnable(wr_en);

            switch(obj.EnumRAMType)
                case 1
                    % Validate read/write address
                    hdl.RAM.validateRAMAddress(addr, 'RAM read/write address', 2);
                    % validate number of RAM banks inferred from inputs
                    hdl.RAM.validateRAMNumBanks(data_in, addr, wr_en, addr);
                otherwise % Simple dual port and Dual port RAMs
                    % validate read and write addresses
                    hdl.RAM.validateRAMAddress(addr, 'RAM write address', 2);
                    hdl.RAM.validateRAMAddress(varargin{1}, 'RAM read address', 4);

                    % Read and write addresses should be the same size
                    hdl.RAM.validateWriteReadAddresses(addr, varargin{1},...
                        obj.UnionizeAddresses);
                    % validate number of RAM banks inferred from inputs
                    hdl.RAM.validateRAMNumBanks(data_in, addr, wr_en, varargin{1});
            end
       end % validateInputsImpl

        function setupImpl(obj, data_in, addr, ~, varargin)
            % setupImpl
            % initialize RAM and delayed read/write data (with 0s or the ramIV).
            % The method inputs are the RAM object, followed by its inputs.
            % Simple Dual and Dual port RAMs have a 2nd address port, which is
            % provided in varargin{1}. The unused parameter in the argument list
            % is the write_enable signal.

            % if ambiguous/double types are passed in, provide a default
            % value and return.
            sizeCheckOnly = hdl.RAM.getSizeCheckStatus;
            if sizeCheckOnly
                [obj.pOutData, obj.pOutWriteData, ...
                    obj.pOutReadData, obj.pRAM] = deal(zeros(size(data_in)));
            else % valid data types and sizes are being passed in
                % get the number of locations in the RAM
                switch(obj.EnumRAMType)
                    case 1 % Single port RAM
                        obj.setRAMSize(addr, data_in);
                    otherwise % Simple dual port and Dual port RAMs
                        % Ensure that the multiple address ports have the
                        % identical type.
                        if isfi(addr) && isfi(varargin{1}) && obj.UnionizeAddresses
                            unionType = fixed.aggregateType(addr, varargin{1});
                            obj.setRAMSize(fi(zeros(size(addr)), unionType), data_in);
                        else
                            obj.setRAMSize(addr, data_in);
                        end
                end

                % Create a zero value of the correct type for a single element
                % of the RAM storage. This will be used to define the type of
                % the RAM storage.
                if isfloat(data_in) || isinteger(data_in)
                    resetDataValue = cast(0, 'like', data_in);
                else % fi
                    dataNumerictype = get(data_in, 'numerictype');
                    if isfimathlocal(data_in)
                        dataFiMath = get(data_in, 'fimath');
                        resetDataValue = fi(0, 'numerictype', dataNumerictype, ...
                            'fimath', dataFiMath);
                    else
                        resetDataValue = fi(0, 'numerictype', dataNumerictype);
                    end
                end
                icV = obj.RAMInitialValue;

                % Check for complexity; if complex input, initial value should
                % be complex too.
                if ~isreal(data_in)
                    resetVal = complex(resetDataValue);
                    icVal = complex(icV);
                else
                    resetVal = resetDataValue;
                    icVal = icV;
                end
                
                % Error checking on icVal
                if ~isempty(icVal)
                    coder.internal.errorIf(~isnumeric(icVal), ...
                        'hdlmllib:hdlmllib:RAMIVMustBeNumeric')
                    sz = size(icVal);
                    coder.internal.errorIf((ndims(icVal) > 2 ||...
                        (sz(1) > 1 && sz(2) > 1)),...
                        'hdlmllib:hdlmllib:RAMIVMatrixUnsupported') %#ok<ISMAT>
                end

                % For each of the 3 output signals, initialize them with one
                % value of the correct data type and complexity, expanded to the
                % appropriate vector size based off the input data's size/shape.
                if isempty(icVal)
                    [obj.pOutData, obj.pOutWriteData, obj.pOutReadData] = ...
                        deal(repmat(resetVal, size(data_in)));
                        obj.pRAM = repmat(resetVal, obj.RamSize, 1);
                elseif isscalar(icVal)
                    % If there's a IV, use it for the initial value. Use the
                    % same type as already determined for the resetVal above.
                    resetVal = cast(icVal, 'like', resetVal);
                    % If the IV is empty, stick with the default 0.
                    [obj.pOutData, obj.pOutWriteData, obj.pOutReadData] = ...
                        deal(repmat(resetVal, size(data_in)));
                % Assign the RAM matrix with the one value of the correct data
                % type and complexity, expanded to the total number of RAM
                % locations, including any multiple banks inferred from the
                % input data size.
                obj.pRAM = deal(repmat(resetVal, obj.RamSize, 1));
                else
                    coder.internal.errorIf(numel(icVal) ~= obj.RamBankSize, ...
                        'hdlmllib:hdlmllib:UnsupportedIVSize',...
                        obj.NumBanks, obj.RamBankSize, numel(icVal));
                    
                    resetVal = cast(icVal(1), 'like', resetVal);
                    [obj.pOutData, obj.pOutWriteData, obj.pOutReadData] = ...
                        deal(repmat(resetVal, size(data_in)));
                    % Use the full user-specified IV
                    if isrow(icVal)
                        % Note the almost invisible transpose (.') on icVal
                        obj.pRAM = repmat(cast(icVal.', 'like', resetVal),...
                            obj.NumBanks, 1);
                    else
                        obj.pRAM = repmat(cast(icVal, 'like', resetVal),...
                            obj.NumBanks, 1);
                    end
                end
            end
        end % setupImpl

        function varargout = outputImpl(obj, data_in, varargin)
            sizeCheckOnly = hdl.RAM.getSizeCheckStatus;

            if sizeCheckOnly % size check mode, send dummy output
                for ii = 1:nargout
                    varargout{ii} = zeros(size(data_in));
                end
            else
                switch obj.EnumRAMType
                    case 1 %'Single port'
                        % Output: Read Data from the previous step
                        varargout{1} = obj.pOutData;

                    case 2 %'Simple dual port'
                        % Output: Read Data from the previous step
                        varargout{1} = obj.pOutReadData;

                    case 3 %'Dual port'
                        % Output: Write and Read Data from the previous step
                        varargout{1} = obj.pOutWriteData;
                        varargout{2} = obj.pOutReadData;
                end
            end
        end

        % Gain speedup by avoiding to validate data types and sizes are being
        % passed in process inputs, send output(s) validation is carried for
        % once in the setupImpl()
        function updateImpl(obj, data_in, addr, wr_en, varargin)
            % stepImpl
            % process inputs, send output, update state
            switch obj.EnumRAMType
                case 1 %'Single port'
                    % check if scalar expansion is needed for RAM inference
                    % with vector data
                    if isscalar(wr_en) && ~isscalar(data_in)
                        din_sz = size(data_in);
                        readWriteAddress = repmat(addr, din_sz);
                        writeEn = repmat(wr_en, din_sz);
                    else
                        readWriteAddress = addr;
                        writeEn = wr_en;
                    end

                    % Adjust for 0-based input port to 1-based MATLAB array
                    rwAddr = double(obj.getAddressInput(readWriteAddress))+1;

                    for n = 1:obj.NumBanks
                        if writeEn(n) % Write the input data into the RAM
                            if obj.EnumWriteOutputValue == 1
                                % Write the input data and send the new data to
                                % the write output at the next step
                                obj.pRAM(rwAddr(n)) = data_in(n);
                                obj.pOutData(n) = data_in(n);
                            else
                                % Read the RAM data to send out at the next step,
                                % then write the input data
                                obj.pOutData(n) = obj.pRAM(rwAddr(n));
                                obj.pRAM(rwAddr(n)) = data_in(n);
                            end
                        else % Read data from input address
                            obj.pOutData(n) = obj.pRAM(rwAddr(n));
                        end
                    end
                case 2 %'Simple dual port'
                    addr2 = varargin{1};

                    % check if scalar expansion is needed for RAM inference
                    % with vector data
                    if isscalar(wr_en) && ~isscalar(data_in)
                        din_sz = size(data_in);
                        writeAddress = repmat(addr, din_sz);
                        readAddress = repmat(addr2, din_sz);
                        writeEnable = repmat(wr_en, din_sz);
                    else
                        writeAddress = addr;
                        readAddress = addr2;
                        writeEnable = wr_en;
                    end

                    [wAddr, rAddr] = ...
                        obj.getDualPortRAMAddressInput(writeAddress, readAddress);
                    rAddr = double(rAddr) + 1;
                    wAddr = double(wAddr) + 1;
                    % Read the data out from the RAM for the next time step.
                    obj.pOutReadData = reshape(obj.pRAM(rAddr),size(obj.pOutReadData));
                    for n = 1:obj.NumBanks
                        % write the data passed in to the RAM
                        if writeEnable(n)
                            obj.pRAM(wAddr(n)) = data_in(n);
                        end
                    end
                case 3 %'Dual port'
                    addr2 = varargin{1};

                    % check if scalar expansion is needed for RAM inference
                    % with vector data
                    if isscalar(wr_en) && ~isscalar(data_in)
                        din_sz = size(data_in);
                        writeAddress = repmat(addr, din_sz);
                        readAddress = repmat(addr2, din_sz);
                        writeEnable = repmat(wr_en, din_sz);
                    else
                        writeAddress = addr;
                        readAddress = addr2;
                        writeEnable = wr_en;
                    end

                    % 1. Read the read output port data out from the RAM
                    % 2. Write the data passed in to the RAM
                    % 3. Read the write port data out from the RAM
                    % 2 & 3 are swapped if WriteOutputValue is 'Old data'
                    [wAddr, rAddr] = ...
                        obj.getDualPortRAMAddressInput(writeAddress, readAddress);
                    rAddr = double(rAddr) + 1;
                    wAddr = double(wAddr) + 1;
                    obj.pOutReadData = reshape(obj.pRAM(rAddr), size(obj.pOutReadData));

                    for n = 1:obj.NumBanks
                        if obj.EnumWriteOutputValue == 1
                            if writeEnable(n)
                                obj.pRAM(wAddr(n)) = data_in(n);
                            end
                            obj.pOutWriteData(n) = obj.pRAM(wAddr(n));
                        else % Old data, read first
                            obj.pOutWriteData(n) = obj.pRAM(wAddr(n));
                            if writeEnable(n)
                                obj.pRAM(wAddr(n)) = data_in(n);
                            end
                        end
                    end
            end
        end % stepImpl

        function resetImpl(obj) %#ok<MANU>
            % Hardware RAMs are not resettable; do nothing on reset.
        end

        function modes = getExecutionSemanticsImpl(obj) %#ok<MANU>
            % supported semantics
            modes = {'Classic', 'Synchronous'};
        end % getExecutionSemanticsImpl

        function s = saveObjectImpl(obj)
            % saveObjectImpl
            % save states & properties into output structure
            % Save the public properties
            s = saveObjectImpl@matlab.System(obj);
            if obj.isLocked
                s.pRAM = obj.pRAM;
                s.pOutData = obj.pOutData;
                s.pOutWriteData = obj.pOutWriteData;
                s.pOutReadData = obj.pOutReadData;
            end
        end % saveObjectImpl

        function loadObjectImpl(obj, s, ~)
            % loadObjectImpl
            % load states & properties from input structure
            fn = fieldnames(s);
            obj.setObjPropertiesFromStructure(s, fn);
        end
        
        function setObjPropertiesFromStructure(obj, s, fn)
            % setObjPropertiesFromStructure
            % for the fieldnames passed in (fn), copy over the settings
            % from s to the object
            for ii = 1:numel(fn)
                obj.(fn{ii}) = s.(fn{ii});
            end
        end % loadObjectImpl

        function supported = supportsMultipleInstanceImpl(~)
            % Support in For Each Subsystem
            supported = true;
        end
    end % protected methods (Impls)



    methods(Access = protected) %non-Impls        
        function setRAMSize(obj, address, data)
            % Get RAM size (all banks)
            % Call in setupImpl
            obj.NumBanks = length(data);

            obj.RamBankSize = hdl.RAM.calculateRAMBankSize(address(1));

            % Total number of addresses in the RAM
            obj.RamSize = obj.NumBanks*obj.RamBankSize;
            % Total number of address bits needed to represent all addresses.
            obj.NumAddressBits = ceil(log2(obj.RamSize));
            
            data1 = data(1);
            if isfi(data1)
                dataBytes = data1.WordLength;
            elseif isa(data1, 'single') || isa(data1, 'int32') || isa(data1, 'uint32')
                dataBytes = 4;
            elseif isa(data1, 'double')
                dataBytes = 8;
            elseif isa(data1, 'int16') || isa(data1, 'uint16')
                dataBytes = 2;
            elseif isa(data1, 'int8') || isa(data1, 'uint8') || isa(data1, 'boolean')
                dataBytes = 1;
            end
            bitsForData = log2(dataBytes);
            % The total number of bits to byte-address the RAM contents is the
            % sum of:
            %  1) The number of address bits in the RAM, which includes the RAM
            %  banking
            %  2) The number of address bits needed to *byte* address a RAM
            %  word. This is computed above in bitsForData.
            totalBits = obj.NumAddressBits + bitsForData;
            coder.internal.errorIf(totalBits > 31, 'hdlmllib:hdlmllib:RAMTooLarge');        
        end % setRAMSize        
        
        function addressOut = getAddressInput(obj, addressIn)
            % Banked RAM is stored as a single RAM, with each bank sequentially
            % ordered. For each RAM bank, add offset corresponding to its number
            % to get the absolute address within RAM array. Send it as is, if fi
            % or integer, else if double/single, convert to uint16 and send out.

            addressOut = fi(zeros(size(addressIn)),numerictype(0,obj.NumAddressBits,0));
            for bank = 1:length(addressIn)
                relAddress = double(addressIn(bank)) + obj.RamBankSize*(bank-1);
                addressOut(bank) = fi(relAddress, 0, obj.NumAddressBits, 0);
            end
        end % getAddressInput

        function [writeAddress, readAddress] = ...
                getDualPortRAMAddressInput(obj, wAddrIn, rAddrIn)

            wAddr = obj.getAddressInput( wAddrIn );
            rAddr = obj.getAddressInput( rAddrIn );

            if obj.UnionizeAddresses
                [writeAddress, readAddress] = hdl.RAM.UnionWriteReadFiAddr(wAddr, rAddr);
            else
                readAddress = rAddr;
                writeAddress = wAddr;
            end
        end % getDualPortRAMAddressInput
    end % protected methods (non-Impls)

    
    
    methods(Static, Access=private)

        function validateRAMNumBanks(writeData,writeAddress,writeEnable,readAddress)
            % Number of RAM banks is inferred from the number of elements in
            % each input vector/scalar. Therefore, each input has to have
            % the same number of elements.
            narginchk(4, 4);

            % only scalar or vector inputs are supported
            if isscalar(writeData) && isscalar(writeAddress) && ...
                    isscalar(writeEnable) && isscalar(readAddress)
                return
            end
            isInputNonScalarVector = ~isvector(writeData) || ~isvector(writeAddress) || ...
                ~isvector(writeEnable) || ~isvector(readAddress);

            coder.internal.errorIf(isInputNonScalarVector, ...
                'hdlmllib:hdlmllib:RAMNonScalarVector');

            % Each input have to have same dimension corresponding to the
            % number of RAM banks
            writeDataSize = size(writeData);
            writeAddressSize = size(writeAddress);
            writeEnableSize = size(writeEnable);
            readAddressSize = size(readAddress);

            % Verify all sizes are same
            isSpecifiedNumBanksSame = isequal(writeDataSize, writeAddressSize) && ...
                isequal(writeDataSize, writeEnableSize) && ...
                isequal(writeDataSize, readAddressSize);
            % Verify usage is valid for vector mode
            isVectorMode = ~isscalar(writeData) && ...
                isscalar(readAddress) && ...
                isscalar(writeAddress) && ...
                isscalar(writeEnable);

            coder.internal.errorIf(~(isSpecifiedNumBanksSame || isVectorMode), ...
                'hdlmllib:hdlmllib:RAMNumBanksNotSame');
        end % validateRAMNumBanks

        function validateRAMWriteData(writeData)
            for nn = 1:length(writeData)
                % Write data must be scalar, fixed point or numeric
                validateattributes(writeData(nn), {'numeric', 'embedded.fi'}, ...
                    {'scalar'},...
                    'hdl.RAM', 'RAM write data', 1);
            end
        end % validateRAMWriteData

        function validateRAMWriteEnable(writeEnable)
            for nn = 1:length(writeEnable)
                % wrEn input must be logical or numeric, real, and scalar
                validateattributes(writeEnable(nn), {'numeric','logical'},...
                    {'real','scalar'}, 'hdl.RAM', 'RAM write enable', 3);
            end
        end % validateRAMWriteEnable

        function validateRAMBankAddress(address, addressString, addressIndex)
            % Validate RAM address
            % should be real (not complex), scalar
            % HDL validation: between 2 and 32 bits (unless single or double)
            % unsigned fi, uint8, or uint32

            % size validation - check for real, scalar value
            % unsigned integer, unsigned embedded.fi, single or double
            validateattributes(address, ...
                {'single', 'double', 'uint8', 'uint16','embedded.fi'}, ...
                {'scalar', 'real'}, ...
                'hdl.RAM', addressString, addressIndex);

            % This check is implemented only if the types are not ambiguous
            % and need to be checked
            sizeCheckOnly = hdl.RAM.getSizeCheckStatus;
            if ~sizeCheckOnly && isfi(address)
                % if embedded.fi, unsigned, between 1 and 31 bit (inclusive)
                s = get(address, 'Signedness');
                wl = get(address, 'WordLength');
                fl = get(address, 'FractionLength');
                invalidAddress = (strcmpi(s, 'Signed')) ||...
                    (wl < 1 || wl > 31) || (fl ~= 0);
                coder.internal.errorIf(invalidAddress,...
                    'hdlmllib:hdlmllib:RAMAddress', addressIndex, addressString);
            end
        end % validateRAMBankAddress

        function validateRAMAddress(address, addressString, addressIndex)
            % Validate each RAM bank address
            % should be real (not complex), scalar
            % HDL validation: between 1 and 31 bits (unless single or double)
            % unsigned fi, uint8/16
            for nn = 1:length(address)
                hdl.RAM.validateRAMBankAddress(address(nn), addressString, addressIndex);
            end
        end % validateRAMAddress

        function validateWriteReadAddresses(writeAddress, readAddress, ~)
            % check that the read and write address are the same size
            % checking just the number of bits, assuming fraction length
            % and signedness are checked elsewhere

            % this check is implemented only if the types are not ambiguous
            % and need to be checked
            sizeCheckOnly = hdl.RAM.getSizeCheckStatus;
            if ~sizeCheckOnly
                readNumBanks = length(readAddress);
                writeNumBanks = length(writeAddress);

                readAddressSize = hdl.RAM.calculateRAMBankSize(readAddress(1)) * readNumBanks;
                writeAddressSize = hdl.RAM.calculateRAMBankSize(writeAddress(1)) * writeNumBanks;

                % true if read/write addresses are different sizes
                readWriteDifferentSize = ...
                    (readAddressSize ~= writeAddressSize);

                coder.internal.errorIf(readWriteDifferentSize, ...
                    'hdlmllib:hdlmllib:ReadWriteAddressNotSame');
            end % ~sizeCheckOnly
        end % validateWriteReadAddresses

        function sizeCheckOnly = getSizeCheckStatus
            % return true if we are in check sizes only mode
            % in this case, a lot of validation is disabled and dummy
            % outputs are returned
            sizeCheckOnly = (~isempty(coder.target) && eml_ambiguous_types);
        end
        % getSizeCheckStatus

        % Unionize read, write addresses if both are fixed-point but have
        % different numerictype. Do not unionize if only performing a size
        % check.
        function [wAddr, rAddr] = UnionWriteReadFiAddr(writeAddress, readAddress)
            sizeCheckOnly = hdl.RAM.getSizeCheckStatus;
            if ~sizeCheckOnly
                if isfi(readAddress) && isfi(writeAddress) && ...
                        ~isequal(numerictype(readAddress), numerictype(writeAddress))
                    unionType = fixed.aggregateType(readAddress, writeAddress);
                    rAddr = fi(readAddress, unionType, fimath(readAddress));
                    wAddr = fi(writeAddress, unionType, fimath(writeAddress));
                else
                    rAddr = readAddress;
                    wAddr = writeAddress;
                end
            else
                rAddr = readAddress;
                wAddr = writeAddress;
            end
        end
        %UnionWriteReadFiAddr

        function ramBankSize = calculateRAMBankSize(address)
            % Get RAM bank size
            % address is unsigned integer, fi, double or single
            % check if address is integer
            if isinteger(address)
                switch class(address)
                    case 'uint8'
                        numBankAddressBits = 8;
                    case 'uint16'
                        numBankAddressBits = 16;
                    case 'uint32'
                        numBankAddressBits = 32;
                    otherwise % case 'uint16'
                        numBankAddressBits = 16;
                end
            elseif isfi(address) % fi
                numBankAddressBits = get(address, 'WordLength');
            else % double, single
                numBankAddressBits = 16;
            end
            ramBankSize = 2^(numBankAddressBits);
        end % getRAMBankSize

    end % static private methods
    
    methods (Static, Access=protected)
    function isVisible = showSimulateUsingImpl
        % Do not show 'simulate using' option on mask. This must be set to
        % 'false' before submission if changed to 'true' for debugging purposes.
        isVisible = false;
    end
end

end % hdl.RAM

% LocalWords:  RAMIV
