function options = CAMset(varargin)
%CAMSET Create/alter CAM OPTIONS structure.
%   OPTIONS = CAMSET('NAME1',VALUE1,'NAME2',VALUE2,...) creates an integrator
%   options structure OPTIONS in which the named properties have the
%   specified values. Any unspecified properties have default values. It is
%   sufficient to type only the leading characters that uniquely identify the
%   property. Case is ignored for property names. 
%   
%   OPTIONS = CAMSET(OLDOPTS,'NAME1',VALUE1,...) alters an existing options
%   structure OLDOPTS.
%   
%   OPTIONS = CAMSET(OLDOPTS,NEWOPTS) combines an existing options structure
%   OLDOPTS with a new options structure NEWOPTS. Any new properties
%   overwrite corresponding old properties. 
%   
%   CAMSET with no input arguments displays all property names and their
%   possible values.

% Print out possible values of properties.
if (nargin == 0) && (nargout == 0)
  fprintf('          AbsTol:    [ positive scalar or vector {1e-6} ]\n');
  fprintf('          CutterDia: [ positive scalar ]\n');
  fprintf('          Finish:    [ Waterline, ParallelX, ParallelY, Cross ]\n');
  fprintf('          ClearArea: [ 0|1 ]\n');
  fprintf('          ZSpacing:  [ positive scalar ]\n');
  fprintf('          MagicZ:    [ 0|1 ]\n');
  fprintf('          verbose:   [ 0|1 ]\n');
  fprintf('          conventional:   [ 0|1 ]\n');
  fprintf('          ZTravel:   [ 0|1 ]\n');
  fprintf('\n');
  return;
end

Names = [
    'AbsTol          '  
    'CutterDia       '  
    'Finish          '  
    'ClearArea       '  
    'ZSpacing        '  
    'MagicZ          '  
    'verbose         '  
    'conventional    '  
    'ZTravel         '  
    ];
m = size(Names,1);
names = lower(Names);

% Combine all leading options structures o1, o2, ... in odeset(o1,o2,...).
options = [];
for j = 1:m
  options.(deblank(Names(j,:))) = [];
end
i = 1;
while i <= nargin
  arg = varargin{i};
  if ischar(arg)                         % arg is an option name
    break;
  end
  if ~isempty(arg)                      % [] is a valid options argument
    if ~isa(arg,'struct')
      error(message('MATLAB:odeset:NoPropNameOrStruct', i));
    end
    for j = 1:m
      if any(strcmp(fieldnames(arg),deblank(Names(j,:))))
        val = arg.(deblank(Names(j,:)));
      else
        val = [];
      end
      if ~isempty(val)
        options.(deblank(Names(j,:))) = val;
      end
    end
  end
  i = i + 1;
end

% A finite state machine to parse name-value pairs.
if rem(nargin-i+1,2) ~= 0
  error(message('MATLAB:odeset:ArgNameValueMismatch'));
end
expectval = 0;                          % start expecting a name, not a value
while i <= nargin
  arg = varargin{i};
    
  if ~expectval
    if ~ischar(arg)
      error(message('MATLAB:odeset:NoPropName', i));
    end
    
    lowArg = lower(arg);
    j = strmatch(lowArg,names);
    if isempty(j)                       % if no matches
      error(message('MATLAB:odeset:InvalidPropName', arg));
    elseif length(j) > 1                % if more than one match
      % Check for any exact matches (in case any names are subsets of others)
      k = strmatch(lowArg,names,'exact');
      if length(k) == 1
        j = k;
      else
            matches = deblank(Names(j(1),:));
        for k = j(2:length(j))'
                matches = [matches ', ' deblank(Names(k,:))]; %#ok<AGROW>
        end
            error(message('MATLAB:odeset:AmbiguousPropName',arg,matches));
      end
    end
    expectval = 1;                      % we expect a value next
    
  else
    options.(deblank(Names(j,:))) = arg;
    expectval = 0;
      
  end
  i = i + 1;
end

if expectval
  error(message('MATLAB:odeset:NoValueForProp', arg));
end
