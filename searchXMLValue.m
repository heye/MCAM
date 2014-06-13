function [ erg ] = searchXMLValue( s, name, val )
%searchValue(s, name, val) - recursive search in s, returns array of nodes with given
%attribute name and value
%   
    
    erg = [];


    for i=1:length(s.Attributes)
        if strcmp(s.Attributes(i).Value, val) && strcmp(s.Attributes(i).Name, name)
            erg=s;
            return;
        end
    end
    
    if size(s.Children,2)==0
        erg = [];
        return;
    end
    
    for i=1:size(s.Children,2)

        [t] = searchXMLValue(s.Children(i), name, val);     
        if size(t) > 0
            erg=[erg,t];
        end
    end

end

