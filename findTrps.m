%%% 
% This function is called by the countTraps script and is the routine which
% identifies dipoles and returns the number of dipoles, the dipole
% locations and the mean number of dipoles per column.

function [traps N trpsPerCol]=findTrps(dataImg,window,thresh)

%  Select the relevant half of the image based on the boundaries defined in
%  'window'.
subImg=dataImg(window(1,1):window(1,2),window(2,1):window(2,2));

% Median filter the windowed frame to establish the level of illumination
% and eliminate dipoles. Normalize image with this filtered frame.
subImgFilt=medfilt1(subImg,5);
subImgNorm=subImg-subImgFilt;

% Initialize.
counter=0;
ncol=0;
trpsPerCol=[];

% Main function loop over each image column.
for n=1:size(subImgNorm,2)
    % Extract a column.
    col=subImgNorm(:,n);
    % Calculate the noise in the column.
    sigma=std(double(col));
    trpsInCol=0;
    for m=1:length(col)-1
        % If two consecutive pixels pass the dipole criterion.
        if ( (abs(col(m))>(thresh*sigma)) && (abs(col(m+1))>(thresh*sigma)) && ((col(m)*col(m+1))<0) )
            trpsInCol=trpsInCol+1;
            counter=counter+1;

            % Record the trap location
            traps(counter,1)=sub2ind(size(dataImg),m+window(1,1)-1, n+window(2,1)-1);

            % Record the median signal around the trap.
            traps(counter,2)=mean(subImgFilt(:,n),1);

            % Record the dipole orientation.
            if col(m)>=col(m+1)
                traps(counter,3)=1;
            end
            traps(counter,4)=abs(col(m)-col(m+1))/2;
        end
    end
    ncol=ncol+1;
    % Record total number of traps in current column.
    trpsPerCol(ncol,1)=trpsInCol;
    % Record mean signal in the current column.
    trpsPerCol(ncol,2)=median(subImgFilt(:,n));
end

% Record the number of traps in each signal bin for the current frame.
[N edges]=histcounts(subImgFilt,10.^(linspace(1,4.65,101)));
end
