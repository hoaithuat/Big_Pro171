clear all
clc
clear
basemva = 100;
accuracy = 0.0001; accel = 1.8; maxiter =100 ;
%Bus Bus  Voltage Angle        ---Load----  -------Generator-----   Static Mvar
%         1   2     3    4       5     6      7     8    9     10        11   
%        No  code Mag.  Degree  kW    kvar   kW   kvar Qmin   Qmax     +Qc/-Ql
busdata=[1   1    1.0   0.0     0.0   0.0    0.0  0.0   0      0         0
         2   0    1.0   0.0     0     0      0     0    0      0         0
         3   2    1.0   0.0     3.2   0.9    100   0    20     70         0
         4   0    1.0   0.0     82    25      0    0    0      0         0
         5   0    1.0   0.0     62    16     0.0  0.0   0      0         0
         6   2    1.0   0.0     0     0      40    0    10     50        0];
        %                                        Line code
%         Bus bus   R         X        1/2 B     = 1 for lines
%         nl  nr  p.u.        p.u.     p.u.      > 1 or < 1 tr. tap at bus nl
linedata=[1   2   0.005       0.005     0          1
          2   3   0.004       0.003     0          1
          2   4   0.002       0.002     0          1
          2   5   0.01        0.025     0          1
          5   6   0.003       0.04      0          1];    %khoang cach moi node la 35m
          
lfybus
lfnewton_2
busout
lineflow
