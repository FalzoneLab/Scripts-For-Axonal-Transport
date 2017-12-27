% Separates trajectories in Confined Motion (confined), Normal Diffusion
% (diffusive) and Active Transport (active)

ca=1;           % counter for active
cc=1;           % counter for confined
cd=1;           % counter for diffusive
ndata=input('Number of trackings:  ');      % asks for number of data
for i=1:ndata                               % loops through all data
    eval(['m=m2d_',int2str(i),';'])         % creates temporal variable m
    m=m(:,2);                               %
    %if m(1)<1                          % Criterion for discarding particles: MSD(tau=1)>1pixel^2 
    M=(m(1:10)-m(1))/(m(10)-m(1));
    if (max(M)<2 & M(3)<0.15)           % Criterion to consider active: M(tau=3)<0.15
        active(ca,1)=i;
        figure(1); plot(M, 'b'); hold on; title('activo')
        ca=ca+1;
    end
    if (max(M)<2 & M(6)>0.6)            % Criterion to consider confined: M(tau=6)>0.6
    confined(cc,1)=i;
    figure(2);plot(M,'r'); hold on; title('confinado')
    cc=cc+1;
    end
    if (max(M)<2 & M(6)<0.6 & M(3)>0.15) %Criteria to consider diffusive: in the middle of the other conditions
    diffusive(cd,1)=i;
    figure(3);  plot(M,'k'); hold on; title('normal')
    cd=cd+1;
    end
end
%end


% %*******************Analizing diffusive********************
% kd=1;
% kdd=1;
% for i=1:length(diffusive)
%     eval(['mx=m2d_',int2str(diffusive(i)),';'])
%     m=mx(:,2);
%     M=(m(1:10)-m(1))/(m(10)-m(1));
%     
%      [p,S]=polyfit([1:10]',M,1);
%      [mm,delta]=polyval(p,[1:10]',S);
%      data_d(kd,:)=[i mean(delta)];
%      kd=kd+1;
%      if mean(delta)<0.05                                % lineality criterion
%          [p,S]=polyfit(mx(1:10,1),mx(1:10,2),1);
%          [mmx,delta]=polyval(p,mx(1:10,1),S);
%          figure(4);plot(mx(1:10,1),mx(1:10,2),'-',mx(1:10,1),mmx,'r'); hold on
%          data_dd(kdd)=i;
%          kdd=kdd+1;
%      end
% end
% % figure(5); hist(data_d(:,2),30); xlabel('error medio de la regresion lineal'); 


% %*******************Analizo TA************
% ka=1;
% for i=1:length(active)
%     eval(['mx=m2d_',int2str(active(i)),';'])
%     m=mx(:,2);
%     M=(m(1:10)-m(1))/(m(10)-m(1));
%     
%      [p,S]=polyfit([1:10]',M,2);
%      [mm,delta]=polyval(p,[1:10]',S);
%      data_a(ka,:)=[i mean(delta)];
%      ka=ka+1;
%      if mean(delta)<0.1
%          [p,S]=polyfit(mx(1:10,1),mx(1:10,2),2);
%          [mmx,delta]=polyval(p,mx(1:10,1),S);
%          figure(4);plot(mx(1:10,1),mx(1:10,2),'-',mx(1:10,1),mmx,'r'); hold on
%      end
% end

if exist('confined')==0
    confined=[];
end
if exist('diffusive')==0
    diffusive=[];
end
if exist('active')==0
    active=[];
end
    
clearvars -except x* m2d_* ndata active confined diffusive      % eliminates temporal and auxiliar variables

str=['There is/are ', num2str(length(confined)), ' confined trajectory/ies.'];
disp(str);
if isempty(confined)==0
    str=['They are the trajectories: ', num2str(confined')];
    disp(str);
end
str=['There is/are ', num2str(length(diffusive)), ' diffusive trajectory/ies.'];
disp(str);
if isempty(diffusive)==0
    str=['They are the trajectories: ', num2str(diffusive')];
    disp(str);
end
str=['There is/are ', num2str(length(active)), ' active trajectory/ies.'];
disp(str);
if isempty(active)==0
    str=['They are the trajectories: ', num2str(active')];
    disp(str);
end

clear str