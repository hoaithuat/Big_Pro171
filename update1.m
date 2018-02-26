% Cap nhat cac thong so 
for k=1:nbus
    n=busdata(k,1);
    kb(n)=busdata(k,2); Vm(n)=busdata(k,3); delta(n)=busdata(k,4);
    Pd(n)=busdata(k,5); Qd(n)=busdata(k,6); Pg(n)=busdata(k,7); Qg(n) = busdata(k,8);
    Qmin(n)=busdata(k,9); Qmax(n)=busdata(k,10);
    Qsh(n)=busdata(k,11);
    delta(n) = pi/180*delta(n);% change to radian
    V(n) = Vm(n)*(cos(delta(n)) + j*sin(delta(n)));
    P(n)=(Pg(n)-Pd(n))/basemva;          %chuyen ve don vi tuong doi
    Q(n)=(Qg(n)-Qd(n)+ Qsh(n))/basemva;  %dvtd
    S(n) = P(n) + j*Q(n);                %dvtd
end
    %dieu chinh loai nut, tinh so nut nguon khong thay doi và nut nguon thay
    %doi
    ng=0; ns=0;
for k=1:nbus
    if kb(k) == 1, ns = ns+1; else, end
    if kb(k) == 2
    ng = ng+1; else, end
    ngs(k) = ng;
    nss(k) = ns;
end
            
%ket thuc tinh cac loia nut%
    m=2*nbus-ng-2*ns;