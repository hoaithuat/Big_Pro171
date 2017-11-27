clear all
clc
clear
basemva = 100;
accuracy = 0.00001; accel = 1.8; maxiter = 100 ;
%                   PHAN NHAP SO LIEU NUT VA THONG SO DUONG DAY
%        IEEE 30-BUS TEST SYSTEM (American Electric Power)
%        Bus Bus  Voltage Angle   ---Load----  -------Generator-----   Static Mvar
%         1   2     3    4       5     6      7     8    9     10        11   
%        No  code Mag.  Degree  kW    kvar   kW   kvar Qmin   Qmax     +Qc/-Ql
busdata=[1   1    1.0   0.0     0.0   0.0    0.0  0.0   0      0         0
         2   2    1.0   0.0     50   37.5    20    0    0      40        0
         3   2    1.0   0.0     0     0      10   0.0   0      10        0
         4   0    1.0   0.0     30    0       0    0    0      0         0];
    %                                        Line code
%         Bus bus   R         X        1/2 B     = 1 for lines
%         nl  nr  p.u.        p.u.     p.u.      > 1 or < 1 tr. tap at bus nl
linedata=[1   2   0.02        0.04      0          1
          2   3   0.01        0.03      0          1
          3   4   0.0125      0.025     0          1];
          lfybus
lfnewton_2 
busout
lineflow