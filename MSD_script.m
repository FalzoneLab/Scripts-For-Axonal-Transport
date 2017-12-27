% --------------------------------------------------------
% Calculates Mean Square Displacement (MSD)
% --------------------------------------------------
% INPUT: 
% *.mat file with x(t) of each trajectory correctly enumerated (x1,x2,...)
% ---------------------------------------------------
% OUTPUT:
% m2d_i: matrix containing tau (time interval) and msd of trajectory i

clc; %close all                          % close all graphics and cleans command window
ndata=input('Number of trackings:  ');   % it asks for number of trackings
dt=input('Exposure time used while imaging or duration of frames(in seconds): '); % exposure time (duration of frames)
pixsize=input('Pixel size (in um): ');   % pixel size in um
for k=1:ndata                               % loops for all tracks
    eval(['x=x',int2str(k),';']);       % creates x from x(k)
    t=[0:dt:dt*(length(x)-1)];          % creates timescale
    N=length(x);                        % total length of trajectory
    clear  m2d a ddx tau                % clears temporal variables
    NN=floor(N/10);                     % it takes the first 10% of the data
    i=1;                                % creates a counter "i" for tau sizes (begins as 1 tau)
    for n=1:N                           % index for time lag (tau); goes through the trajectory total length
        clear a                         % clears temporal variable a
        a=x(n+1:N)-x(1:N-n);            % calculates the displacement in tau
        ddx(i)=mean(a.^2);              % calculates mean of the square of the displacement (transforming the unit to píxel^2)
        tau(i)=n*dt;                    % transformates unit of tau to segundos (multiplying pixels (n) by frame duration(dt))
        i=i+1;                          % amplifies tau size in 1 dt
    end                                 % 
    m2d(:,1)=tau;                       % saves time lag (tau) in first column from m2d
    m2d(:,2)=ddx*pixsize;               % saves Mean Square Displacement or MSD (ddx) in 2da column of m2d (in um)
    eval(['m2d_',int2str(k),'=m2d;'])   % saves m2d_(k) --> MSD of the track as a new variable
end                                     % 
        
clearvars -except x* m2d_* ndata
fname=input('save MSD data as:    ','s');                % ask filename for MSD data
save(fname);                                    % saves entire workspace
