% RUNLENGTHS SCRIPT

clearvars -except x*;                % clears unnecesary variables
ndata=input('Number of trackings:  ');      % it asks for number of trajectories
cont=1;                              % counter for rows of "runs" matrix

for jj=1:ndata;                             % loops through all data
    clearvars -except x* v* jj cont runs;   % clears all unnecesary variables
    eval(['x=x',int2str(jj),';']);  % temporal variable x
    accesory2;                      % executes script to obtain runlengths
    runs(cont:cont+i-1,1)=v(:,1);   % VELOCITY OF RUN
    runs(cont:cont+i-1,2)=v(:,2);   % FRAMES OF RUN
    runs(cont:cont+i-1,4)=jj;       % run's trajectory of origin
    runs(cont:cont+i-1,5)=r1(1:end-1)'; % run's point of origin
    cont=cont+i;                    % adds the ammount of runlenghts obtained to the counter
    eval(['v',int2str(jj),'=v;'])   % creates variable v(i) that contains the runlenghts of trajectory x(i)
end
sizeruns=size(runs);                % variable that meassures the length of runs

for h=1:sizeruns(1);                % through size:    
    runs(h,3)=runs(h,1)*runs(h,2);  % creates columna DISTANCES (3rd)
    if runs(h,2)==0                 % if detects a run of 0 frames of duration:
        runs(h,:)=[0 0 0 0 0];      % puts 0 in that row
    elseif abs(runs(h,1))<0.05;     % CRITERION OF DISCARD FOR SMALL VELOCITIES
        pauses(h,:)=runs(h,:);      % it incorporates it to pauses     
    elseif abs(runs(h,3))<1;        % CRITERION OF DISCARD FOR SMALL DISTANCES     
        pauses(h,:)=runs(h,:);      % it incorporates it to pauses
    else
        pauses(h,:)=[0 0 0 0 0];    % if it doesn't discards, puts a 0 in pauses
    end
end

trueruns=runs-pauses;           % new matrix of runs without pauses
nextruns=trueruns;              % new matrix with short runs integrated to the next ones
truepauses=pauses;              % new matrix that will contain pauses unified
sizepausa=size(truepauses)-1;   % 
contrev=1;

for h=1:sizepausa(1);                                          % UNIFYING PAUSES
    if (truepauses(h,4)~=0) && (truepauses(h+1,4)==truepauses(h,4));          % if 2 consecutive pauses are not 0
       truepauses(h+1,2)=truepauses(h+1,2)+truepauses(h,2);    % adds frames
       truepauses(h+1,3)=truepauses(h+1,3)+truepauses(h,3);    % adds distaces
       truepauses(h+1,1)=truepauses(h+1,3)/truepauses(h+1,2);  % calculates velocity
       truepauses(h+1,5)=truepauses(h,5); 
       truepauses(h,:)=[0 0 0 0 0];                            % clears row
    end
end

for h=1:sizepausa(1);                               % puts back very short pauses
    if (truepauses(h,4)~=0) && (truepauses(h,2)<5); % if there's a pause and it's less than 5 frames
        nextruns(h,:)=runs(h,:);                    % it incorporates it in nextruns from runs
        truepauses(h,:)=[0 0 0 0 0];                % clears row from truepauses          
    end
end

for h=1:sizepausa(1);                                   % UNIFYING RUNS
    if (nextruns(h,4)~=0) && (nextruns(h+1,4)==(nextruns(h,4))) && sign(nextruns(h+1,1))==sign(nextruns(h,1))          % if 2 consecutive nextruns are not 0 and of same sign
       nextruns(h+1,2)=nextruns(h+1,2)+nextruns(h,2);   % adds frames
       nextruns(h+1,3)=nextruns(h+1,3)+nextruns(h,3);   % adds distaces
       nextruns(h+1,1)=nextruns(h+1,3)/nextruns(h+1,2); % calculates velocity
       nextruns(h+1,5)=nextruns(h,5);
       nextruns(h,:)=[0 0 0 0 0];                       % clears row
    end
end

for h=1:sizeruns(1)-1;                                         % DISCARDS FOR SHORT TIME       
    if nextruns(h,2)<4 && (nextruns(h+1,4)==nextruns(h,4))     %||nextruns(h,2)==2||nextruns(h,2)==3;
        nextruns(h+1,2)=nextruns(h+1,2)+nextruns(h,2);         % adds frames
        nextruns(h+1,3)=nextruns(h+1,3)+nextruns(h,3);         % adds distaces
        nextruns(h+1,1)=nextruns(h+1,3)/nextruns(h+1,2);       % calculates total velocity
        nextruns(h,:)=[0 0 0 0 0];                             % clears row
    end
end

for h=1:sizepausa(1);                                          % 2nd UNIFYING PAUSES
    if (truepauses(h,4)~=0) && (truepauses(h+1,4)==truepauses(h,4));          % if 2 consecutive pauses are not 0:
       truepauses(h+1,2)=truepauses(h+1,2)+truepauses(h,2);    % adds frames
       truepauses(h+1,3)=truepauses(h+1,3)+truepauses(h,3);    % adds distaces
       truepauses(h+1,1)=truepauses(h+1,3)/truepauses(h+1,2);  % calculates velocity
       truepauses(h+1,5)=truepauses(h,5); 
       truepauses(h,:)=[0 0 0 0 0];                            % clears row
    end
end

contpauses=1;                                       % counter for pauses
contruns=1;                                         % counter for runs

for h=1:sizeruns(1);                                % ELIMINATES EMPTY ROWS
    if truepauses(h,4)~=0;                          % if row have something (pauses)
        nextpauses(contpauses,:)=truepauses(h,:);   % transfers it to new matrix
        contpauses=contpauses+1;                    % adds 1 to counter
    end
    if nextruns(h,2)~=0;                            % if row have something (runs)
        finalruns(contruns,:)=nextruns(h,:);        % it transfers it to new matrix
        contruns=contruns+1;                        % adds 1 to counter
    end
end

sizefinal=size(finalruns);

for h=1:sizefinal(1)-1;
    if (finalruns(h,4)~=0) && (finalruns(h+1,4)==(finalruns(h,4))) && sign(finalruns(h,1))~=sign(finalruns(h+1,1))          % if 2 consecutive nextruns are not 0 and of same sign:
       reversion(contrev,1)=finalruns(h,4);              % reversion's particle of origin
       reversion(contrev,2)=finalruns(h+1,5);            % reversion's point of origin
       reversion(contrev,3)=sign(finalruns(h,1));        % sign of trajectory h (previous to reversion)
       reversion(contrev,4)=sign(finalruns(h+1,1));      % sign of trajectory h+1 (subsequent to reversion)
       contrev=contrev+1;                                % adds 1 to counter
    end
end

contant=1;                      % anterograde's counter
contret=1;                      % retrograde's counter
for h=1:sizefinal(1);                       % SEPARATES IN ANTEROGRADE AND RETROGRADE
    if finalruns(h,1)>0;                    % anterograde velocities
        velante(contant,:)=finalruns(h,:);  % it transfers them to new matrix
        contant=contant+1;                  % adds 1 to anterograde's counter
    else                                    % retrograde velocities
        velretro(contret,:)=finalruns(h,:); % it transfers them to new matrix
        contret=contret+1;                  % adds 1 to retrograde's counter
    end
end

%plot(finalruns(:,5),x(finalruns(:,5)),'*r',finalruns(1:end,5)+finalruns(1:end,2),x(finalruns(1:end,5)+finalruns(1:end,2)),'ok')

clear x;
clearvars -except x* finalruns nextpauses nextruns pauses runs truepauses trueruns vel* reversion contrev;   %borra variables innecesarias
shg

fname=input('save data as:    ','s');     % asks filename for data
save(fname,'velante','velretro','reversion','nextpauses')                           % saves anterograde, retrograde, pause and reversion data
