function struct=cs_cell2struct(acell)
% cell 2 struct
%
    filenum = size(acell,1);
    x.name='***';
    struct=repmat(x,[filenum,1]);
    for i=1:1:filenum
        struct(i).name = acell{i}; 
    end

end


