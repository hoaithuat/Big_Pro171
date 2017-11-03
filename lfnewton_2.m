    %CHINH SUA CAC YEU TO Q-P
    %CH??NG TRINH DA DC EDIT
    ns=0; ng=0; Vm=0; delta=0; yload=0; deltad=0;
    nbus = length(busdata(:,1));
    kb=[];Vm=[]; delta=[]; Pd=[]; Qd=[]; Pg=[]; Qg=[]; Qmin=[]; Qmax=[];  % Added (6-8-00)
    Pk=[]; P=[]; Qk=[]; Q=[]; S=[]; V=[]; % Added (6-8-00)
    %hieu chinh ra don vi tuong doi%
    for k=1:nbus -%
        n=busdata(k,1);
        kb(n)=busdata(k,2); Vm(n)=busdata(k,3); delta(n)=busdata(k, 4);
        Pd(n)=busdata(k,5); Qd(n)=busdata(k,6); Pg(n)=busdata(k,7); Qg(n) = busdata(k,8);
        Qmin(n)=busdata(k, 9); Qmax(n)=busdata(k, 10);
        Qsh(n)=busdata(k, 11);
        if Vm(n) <= 0
            Vm(n) = 1.0; V(n) = 1 + j*0;
        else delta(n) = pi/180*delta(n);% change to radian
            V(n) = Vm(n)*(cos(delta(n)) + j*sin(delta(n)));
            P(n)=(Pg(n)-Pd(n))/basemva;          %chuyen ve don vi tuong doi
            Q(n)=(Qg(n)-Qd(n)+ Qsh(n))/basemva;  %dvtd
            S(n) = P(n) + j*Q(n);                %dvtd
        end
    end
    %dieu chinh loai nut, tinh so nut nguon khong thay doi và nut nguon thay
    %doi
            for k=1:nbus
                if kb(k) == 1, ns = ns+1; else, end
                if kb(k) == 2
                ng = ng+1; else, end
                ngs(k) = ng;
                nss(k) = ns;
            end
%ket thuc tinh cac loia nut%
    Ym=abs(Ybus); t = angle(Ybus);
    m=2*nbus-ng-2*ns;%why?
    maxerror = 1; converge=1;
    iter = 0;
    %%%% added for parallel lines (Aug. 99)
    mline=ones(nbr,1);
    for k=1:nbr
        for mn=k+1:nbr %what is m
            if((nl(k)==nl(mn)) && (nr(k)==nr(mn)));
                mline(mn)=2;
            elseif ((nl(k)==nr(mn)) && (nr(k)==nl(mn)));
                mline(mn)=2;
            else, end
        end
    end
    %%%   end of statements for parallel lines (Aug. 99)

    % Start of iterations - bat dau vong lap
    clear A  DC   J  DX
    while maxerror >= accuracy && iter <= maxiter % Test for max. power mismatch
        % khoi tao ma tran Jacobi=========
        for ii=1:m
            for k=1:m
                A(ii,k)=0;      %Initializing Jacobian matrix
            end, end
        % ====================ket thuc khoi tao
        iter = iter+1;
        for n=1:nbus
            nn=n-nss(n);
            lm=nbus+n-ngs(n)-nss(n)-ns;
            J11=0; J22=0; J33=0; J44=0;%xoa tat ca cac phan tu duong cheo
            for ii=1:nbr
                if mline(ii)==1   % Added to include parallel lines (Aug. 99)
                    if nl(ii) == n || nr(ii) == n
                        if nl(ii) == n ,  l = nr(ii); end
                        if nr(ii) == n , l = nl(ii); end
                        J11=J11+ Vm(n)*Vm(l)*Ym(n,l)*sin(t(n,l)- delta(n) + delta(l));
                        J33=J33+ Vm(n)*Vm(l)*Ym(n,l)*cos(t(n,l)- delta(n) + delta(l));
                        if kb(n)~=1
                            J22=J22+ Vm(l)*Ym(n,l)*cos(t(n,l)- delta(n) + delta(l));
                            J44=J44+ Vm(l)*Ym(n,l)*sin(t(n,l)- delta(n) + delta(l));
                        else, end
                        if kb(n) ~= 1  && kb(l) ~=1
                            lk = nbus+l-ngs(l)-nss(l)-ns;
                            ll = l -nss(l);
                            % off diagonalelements of J1
                            A(nn, ll) =-Vm(n)*Vm(l)*Ym(n,l)*sin(t(n,l)- delta(n) + delta(l));
                            if kb(l) == 0  % off diagonal elements of J2
                                A(nn, lk) =Vm(n)*Ym(n,l)*cos(t(n,l)- delta(n) + delta(l));end
                            if kb(n) == 0  % off diagonal elements of J3
                                A(lm, ll) =-Vm(n)*Vm(l)*Ym(n,l)*cos(t(n,l)- delta(n)+delta(l)); end
                            if kb(n) == 0 && kb(l) == 0  % off diagonal elements of  J4
                                A(lm, lk) =-Vm(n)*Ym(n,l)*sin(t(n,l)- delta(n) + delta(l));end
                        else,end
                    else , end
                else, end
            end
            Pk = Vm(n)^2*Ym(n,n)*cos(t(n,n))+J33;
            Qk = -Vm(n)^2*Ym(n,n)*sin(t(n,n))-J11;
            if kb(n) == 1
                P(n)=Pk; Q(n) = Qk; end   % Swing bus P
           %============Xu li phan code tai loai nut so 2===============%
            if kb(n) == 2
                Q(n)=Qk;
                if Qmax(n) ~= 0
                    Qgc = Q(n)*basemva + Qd(n) - Qsh(n);
                    if iter <= 7
                        if iter > 2
                            if Qgc  < Qmin(n)
                                %Vm(n) = Vm(n) + 0.01
                                busdata(n,6)=busdata(n,6)+Qmin(n);%neu thay doi loai nut tai
                                %diem nay thi se khong lam thay doi cac ma tran dem laoi nut nguon ngs() va nss()%
                                busdata(n,2)=0;                   %nen khong the dun phuong phap nay%
                                busdata(n,9)=0;
                                busdata(n,10)=0;
                                kb(n)=busdata(n,2);     %cap nhat loai nut
                                
                            elseif Qgc  > Qmax(n)   % bring the generator Mvar within
                                %Vm(n) = Vm(n) - 0.01;end % the specified limits.
                                busdata(n,6)=busdata(n,6)+Qmax(n);
                                busdata(n,2)=0;
                                busdata(n,9)=0;
                                busdata(n,10)=0;
                                kb(n)=busdata(n,2);
                            end
                        else, end
                    else,end
                else,end
            end
            %=====================Ket thuc xu ly ========================%
            if kb(n) ~= 1
                A(nn,nn) = J11;  %diagonal elements of J1
                DC(nn) = P(n)-Pk;
            end
            if kb(n) == 0
                A(nn,lm) = 2*Vm(n)*Ym(n,n)*cos(t(n,n))+J22;  %diagonal elements of J2
                A(lm,nn)= J33;        %diagonal elements of J3
                A(lm,lm) =-2*Vm(n)*Ym(n,n)*sin(t(n,n))-J44;  %diagonal of elements of J4
                DC(lm) = Q(n)-Qk;
            end
        end
        DX=A\DC';
        for n=1:nbus
            nn=n-nss(n);
            lm=nbus+n-ngs(n)-nss(n)-ns;
            if kb(n) ~= 1
                delta(n) = delta(n)+DX(nn); end
            if kb(n) == 0
                Vm(n)=Vm(n)+DX(lm); end
        end
        maxerror=max(abs(DC));
        if iter == maxiter && maxerror > accuracy
            fprintf('\nWARNING: Iterative solution did not converged after ')
            fprintf('%g', iter), fprintf(' iterations.\n\n')
            fprintf('Press Enter to terminate the iterations and print the results \n')
            converge = 0; pause, else, end

    end
    if converge ~= 1
        tech= ('                      ITERATIVE SOLUTION DID NOT CONVERGE'); else,
        tech=('                   Power Flow Solution by Newton-Raphson Method');
    end
    V = Vm.*cos(delta)+j*Vm.*sin(delta);
    deltad=180/pi*delta;
    i=sqrt(-1);
    k=0;
    for n = 1:nbus
        if kb(n) == 1
            k=k+1;
            S(n)= P(n)+j*Q(n);
            Pg(n) = P(n)*basemva + Pd(n);
            Qg(n) = Q(n)*basemva + Qd(n) - Qsh(n);
            Pgg(k)=Pg(n);
            Qgg(k)=Qg(n);     %june 97
        elseif  kb(n) ==2
            k=k+1;
            S(n)=P(n)+j*Q(n);
            Qg(n) = Q(n)*basemva + Qd(n) - Qsh(n);
            Pgg(k)=Pg(n);
            Qgg(k)=Qg(n);  % June 1997
        end
        yload(n) = (Pd(n)- j*Qd(n)+j*Qsh(n))/(basemva*Vm(n)^2);
    end
    busdata(:,3)=Vm'; busdata(:,4)=deltad';
    Pgt = sum(Pg);  Qgt = sum(Qg); Pdt = sum(Pd); Qdt = sum(Qd); Qsht = sum(Qsh);

    %clear A DC DX  J11 J22 J33 J44 Qk delta lk ll lm
    %clear A DC DX  J11 J22 J33  Qk delta lk ll lm
