function [ erg ] = searchXML( s, name )
%search - recursive search in s, returns an array containing all nodes with
%the given name
%   
    
    erg = [];
    
    if strcmp(s.Name,name)
        erg = s;
        return;
    end
    
    if size(s.Children,2)==0
        erg = [];
        return;
    end
    
    for i=1:size(s.Children,2)
        [t] = searchXML(s.Children(i), name);     
        if size(t) > 0
            erg=[erg,t];
        end
    end

end

