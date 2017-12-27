%--------------------------------------------------------
% Calculates segmental velocoties
%------------------------------------------------------------
% It is considered that cell body is always to the left, so positive
% velocities correspond to anterograde transport and negative velocities to
% retrograde. 
%--------------------------------------------------------
% Parameters to modify:
% npoints: define number of points that constitu each segment to analyze
% tole: tolerance for R squared of regression
% dt=temporal step
%--------------------------------------------------
% INPUT: 
% *.mat file with x(t) of active trajectories correctly enumerated (x1,x2,...)
%---------------------------------------------------
% OUTPUT:
% vk: vector with anterograde velocities filtered according to criterion Rsq > tole
% vd: vector with retrograde velocities filtered according to criterion Rsq > tole

tole=0.75;          % tolerance for R squared

ndata=input('Number of trackings:  ');      % it asks for number of trackings
dt=input('Exposure time used while imaging or duration of frames(in seconds), type 1 to use frames:  '); % exposure time (duration of frames)/temporal step
pixsize=input('Pixel size (in um), type 1 to use pixels:  ');     % pixel size in um
npoints=input('Length of segments:  ');     % length of segment - 1 (for 20 frames use 19)
cmenos=1;   % counter of velocities
cmas=1;     % 

if size(x1,2)>size(x1,1)
    for l=1:ndata
        eval(['x',int2str(l),'=transpose(x',int2str(l),');']);
    end
end  
    
for k=1:ndata                               % loops through all the data
    eval(['x=x',int2str(k),';'])            % creates temporal variable
    t=[0:dt:dt*(length(x)-1)];              % 
%     clear dd tau;
%     Ants_MSD;
%     m2d(:,1)=tau;
%     m2d(:,2)=dd;
    
    for i=1:npoints:length(x)-npoints       
        tf=t(i:i+npoints);
        xf=x(i:i+npoints);
        clear recta f res Serr Stot R_sq vt vx vy
        recta=polyfit(tf',xf,1); %recta(1)=velocidad 
        f = polyval(recta,tf);
       % figure (1); hold on; plot(tf,f,'r')     
        res=xf-f';
        Serr=sum(res.^2);
        Stot=sum((xf-mean(xf)).^2);
        Rsq=1-Serr/Stot;                
         
        if (Rsq>tole)   
       %     figure (1); hold on; plot(tf,f,'g')
            if recta(1)>0
            vk(cmas)=(recta(1));
            cmas=cmas+1;
            else
            vd(cmenos)=(recta(1));
            cmenos=cmenos+1;    
            end
        end
    end 
end

fname=input('save velocities as:    ','s');     % asks filename for velocities
save(fname,'vd','vk')                           % saves them

% DISTRIBUTION GRAPH

%  bin_k=3.49*std((vk))/length(vk)^(1/3);
%  bin_d=3.49*std((vd))/length(vd)^(1/3);
%  vbin_k=0:bin_k:max(vk);
%  vbin_d=0:bin_d:max(abs(vd));
  
%  clear aa bb
%  [aa bb]=hist(abs(vd),vbin_d);
%  figure(3); plot(bb,aa/max(aa)); xlabel('velocidad retrograda');
%  hold on;
%  clear aa bb;
%  [aa bb]=hist(abs(vk),vbin_k);
%  figure(2); plot(bb,aa/max(aa),'r'); xlabel('velocidad anterograda');
  
