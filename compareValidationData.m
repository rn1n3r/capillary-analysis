clean
fovList = {'X20-FOV3-B','X20-FOV5-B', 'X20-FOV7-B', 'X20-FOV8-B', 'X20-FOVp2-2-B', 'X20-FOVp2-4-P'};
%fovList = {'X20-FOVp2-2-B'};
fmeasureFile = {'TENV-all-05-15-middle.mat', 'TENG-all-05-15-middle.mat', 'GDER-all-05-15-middle.mat', 'LAPV-all-05-15-middle.mat'};
%savefile = {'LAPE', 'LAPM', 'LAPV', 'LAPD'};
%fmeasureFile = 'TENV-all-02-13.mat';
aroc = zeros(length(fovList), 1);
figure
for k = 1:length(fmeasureFile)
    for j = 1:length(fovList)
        subplot(2,3,j);
        fovString = fovList{j};

        load(['/Users/edward/Documents/capillary-data/validate/' fovString '-results.mat'])
        load(['/Users/edward/Documents/capillary-data/data/' fmeasureFile{k}])

        varImg = imread(['../capillary-data/Processed/' fovString '/Functional-16bitImages/' fovString '-16bit442Var.tif']);
        capArea = getCapillaries(varImg);
        ids = fovData.(erase(fovString, '-'));

        meanValues = zeros(520, length(ids));
        for i = 1:length(ids)
            meanValues(:, i) = nanmean(ids{i,2},2);
        end

        meanValuesNorm = meanValues./max(meanValues(:));

        focusMask(focusMask(capArea == 1) == 0) = 9001;

        for i = 0:100
            threshmap = threshMap(ids, capArea, i/100, false, meanValuesNorm);
            %imshow(threshmap, []);
            %title(i)

            %if i == 0
            %    threshmap(:) = 1;
            %end
            TPF(j, i+1) = sum(focusMask(threshmap == 1) == 1337)/sum(focusMask(:) == 1337);
            FPF(j, i+1) = sum(focusMask(threshmap == 1) == 9001)/sum(focusMask(:) == 9001);
            %pause
        end
        
        [~, optimal_threshold(j)] = min(FPF(j,:) + 1-TPF(j,:));
        optimal_threshold(j) = optimal_threshold(j)/100 * max(meanValues(:));
        
        
        plot(FPF(j,:), TPF(j,:));
        title(fovString);

        aroc(j) = -trapz(FPF(j,:), TPF(j,:));
        xlabel(aroc(j));
        hold on
    end
    
    optimal_threshold./max(meanValues(:))
    
%save(['/Users/edward/Documents/capillary-data/data/' savefile{k} '.mat'], 'FPF', 'TPF', 'aroc')
end
