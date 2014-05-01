function initSequence (TSObj, seq)
% INITSEQUENCE Initialize the sequence property
dim=size(seq);
TSObj.SEQUENCE = char(zeros(dim(2),10));
for i=1:dim(2)
    TSObj.SEQUENCE(i,1)=seq(i);
    TSObj.SEQUENCE(i,2)=' ';
    TSObj.SEQUENCE(i,3)=' ';
    TSObj.SEQUENCE(i,4)=' ';
    TSObj.SEQUENCE(i,5)=' ';
    TSObj.SEQUENCE(i,6)=' ';
    TSObj.SEQUENCE(i,7)=' ';
    TSObj.SEQUENCE(i,8)=' ';
    TSObj.SEQUENCE(i,9)=' ';
    TSObj.SEQUENCE(i,10)=' ';
end
for i=1:dim(2)
    if TSObj.SEQUENCE(i,1)=='r';
        TSObj.SEQUENCE(i,2)='e';
        TSObj.SEQUENCE(i,3)='p';
        TSObj.SEQUENCE(i,4)='o';
        TSObj.SEQUENCE(i,5)='s';
        TSObj.SEQUENCE(i,6)=' ';
        TSObj.SEQUENCE(i,7)=' ';
        TSObj.SEQUENCE(i,8)=' ';
        TSObj.SEQUENCE(i,9)=' ';
        TSObj.SEQUENCE(i,10)=' ';
    end
end
%TSObj.SEQUENCE
