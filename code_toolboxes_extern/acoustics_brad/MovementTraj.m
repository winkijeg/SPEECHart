function mc = MovementTraj(Nv,Av)
%Author: Brad Story
%


mc = Av(1)*ones(Nv(1),1);

for i=2:length(Nv)
    
    mc = [mc; jerkinterpN(Av(i-1),Av(i),Nv(i)-Nv(i-1))];
    
end;