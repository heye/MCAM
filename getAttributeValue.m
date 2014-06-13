function [ val ] = getAttributeValue( s, name )
%getAttributeValue(s,name) searches in s.Attributes, returns value to the
%given attribute name
%   

        for k=1:length(s.Attributes)
            if strcmp(s.Attributes(k).Name,name)
                val = s.Attributes(k).Value;
                return;
            end
        end

end

