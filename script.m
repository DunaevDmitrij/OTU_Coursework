%Input data

a1 = 0.346;
a2 = -1.973;
a3 = -2.813;
a4 = -0.64;

k = 0.32;

%Part 1 - make transfer function (need to count)

system = tf(1,[1 a1 a2 a3 a4]);

%Part 2 - graphics

figure('Name','LACH LFCH : main system');
bode(system);

figure('Name','Nyquist - razomknut : main system');
nyquist(system);

figure('Name','Impulse : main system');
impulse(system);

figure('Name','Step : main system');
step(system);

%Part 3 - stability check

figure('Name','Mihailov');
Re=[];Im=[];
for w=0:0.01:1.5
Njw=((w*i)^4) + a1*((w*i)^3) + a2*((w*i)^2) + a3*(w*i)+a4;
Re1=real(Njw);
Im1=imag(Njw);
Re=[Re,Re1];
Im=[Im,Im1];
end
ax = axes;
plot(Re,Im);
set(ax,'XGrid','on','YGrid','on');

%Part 4 - correcting chain

figure('Name','Nyquist for feedbacked system with P-regulator');
nyquist(feedback((k.*system),1));

%Part 5 - regulation systems

%   Poles:
%   (-1,0),(-2,0),(-2,1),(-2,-1),(-3,0),(-3,1),(-3,-1)

%Part 5.1 - for uncorrected transfer function

%Matrix from system
A=[0 0 0 0 1 0 0; 0 0 0 0 a1 1 0; 0 0 0 0 a2 a1 1; 1 0 0 0 a3 a2 a1; 0 1 0 0 a4 a3 a2; 0 0 1 0 0 a4 a3; 0 0 0 1 0 0 a4];

%Vector with constans
d=[16-a1; 110-a2; 420-a3; 959-a4; 1304; 970; 300];

%Vector with values for regulator
b=inv(A)*d

%Defining regulator
regulator = tf ( [ b(1) b(2) b(3) b(4) ] , [ 1 b(5) b(6) b(7) ] )

figure('Name','Step reaction of uncorrected stabilized system');
step(feedback((regulator*system),1));

%Part 5.2 - for corrected transfer function

%Matrix from system
A1=[0 0 0 0 1 0 0; 0 0 0 0 a1 1 0; 0 0 0 0 a2 a1 1; k 0 0 0 a3 a2 a1; 0 k 0 0 a4+k a3 a2; 0 0 k 0 0 a4+k a3; 0 0 0 k 0 0 a4+k];

%Vector with constants
d1=[16-a1; 110-a2; 420-a3; 959-(a4+k); 1304; 970; 300];

%Vector with values for regulator
b1=inv(A1)*d1

%Defining regulator
regulator1 = tf ( [ b1(1) b1(2) b1(3) b1(4) ] , [ 1 b1(5) b1(6) b1(7) ] )

figure('Name','Step reaction of corrected stabilized system');
step(feedback((regulator1*(feedback((k.*system),1))),1));

%Part 6 - graphics for new sistems from Part 5

%Part 6.1 - for uncorrected stabilized system

figure('Name','LACH LFCH : uncorrected stabilized system');
bode(feedback((regulator*system),1));

figure('Name','Nyquist - razomknut : uncorrected stabilized system');
nyquist(feedback((regulator*system),1));

figure('Name','Impulse : uncorrected stabilized system');
impulse(feedback((regulator*system),1));
%Part 6.1 - for corrected stabilized system

figure('Name','LACH LFCH : corrected stabilized system');
bode(feedback((regulator1*(feedback((k.*system),1))),1));

figure('Name','Nyquist - razomknut : corrected stabilized system');
nyquist(feedback((regulator1*(feedback((k.*system),1))),1));

figure('Name','Impulse : corrected stabilized system');
impulse(feedback((regulator1*(feedback((k.*system),1))),1));
