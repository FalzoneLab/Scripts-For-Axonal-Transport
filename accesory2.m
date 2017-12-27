% Complementary Script to obtain runlengths

x=x';           % generates X transposed
dt=1;           % exposure time
p1=1:length(x); % p1-->length of trajectory (in frames)
ts=x';p=p1;     % generates non transposed X (ts) and a new variable that contains the length of the trajectory(p)

limder=0.2;                 % límit to consider 0 (parameter that can be modified)
grado=3;                    % smoothing of the curve
net=newgrnn(p,ts',grado);   % 

pp=[1:1:length(p1)];    %
y=sim(net,pp);          %

% figure; hold on
% plot(p,ts,pp,y);
% figure;
deriv=diff(y); % calculates the derivative for each point in the smoothed trajectory
% plot(deriv,'o')

r1(1)=1;    %  
rr=1;       %  
cc=2;       % counter for break points

%r1(cc)=find(abs(deriv)<0.01, 1 );%r1(cc)=min(find(abs(deriv)<0.01));
rr=find(abs(deriv)<limder, 1 );     
 
if isempty(rr)==0
r1(cc)=rr;
 
while r1(cc)<length(deriv)
  cc=cc+1;
  %rr=min(find(abs(deriv(r1(cc-1):end))>0.01));
  rr=find(abs(deriv(r1(cc-1):end))>limder, 1 );
  if isempty(rr), break, end
  r1(cc)=r1(cc-1)+rr;
  cc=cc+1;
  %  rr=min(find(abs(deriv(r1(cc-1):end))<0.01));
  rr=find(abs(deriv(r1(cc-1):end))<limder, 1 );
  if isempty(rr), break, end
  r1(cc)=r1(cc-1)+rr;
end
    r1(cc)=length(y);
else
    r1(cc)=length(y);
end
plot(p,ts,pp,y); hold on
for i=1:length(r1)
     plot(r1(i),y(r1(i)),'*r')          % plots red dots
end

clear v
for i=1:length(r1)-1;
    v(i,1)=(y(r1(i+1))-y(r1(i)))/(dt*(r1(i+1)-r1(i))); % velocity
    v(i,2)=dt*(r1(i+1)-r1(i));                         % time 
end

