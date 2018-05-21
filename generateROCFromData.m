% Serves the purpose of compareValidationData without having to regenerate
% the FPF/TPF data

filenames = {'GDER','TENG', 'TENV', 'LAPV', 'LAPD', 'LAPE', 'LAPM'};
fovList = {'X20-FOV3-B','X20-FOV5-B', 'X20-FOV7-B', 'X20-FOV8-B', 'X20-FOVp2-2-B', 'X20-FOVp2-4-P'};


allArocs = zeros(6, length(filenames));
for k = 1:length(filenames)
    load(['/Users/edward/Documents/capillary-data/data/' filenames{k} '.mat']);

    for j = 1:length(fovList)
        subplot(2,3,j);
        fovString = fovList{j};
        plot(FPF(j,:), TPF(j,:));
        title(['FOV ' num2str(j)]);

        aroc(j) = -trapz(FPF(j,:), TPF(j,:));
        xlabel('False positive fraction');
       
        
        if j == 1 || j == 4
            ylabel('True positive fraction');
        end
        hold on
    end
    allArocs(:, k) = aroc;
end

subplot(2,3,3);

legend(filenames, 'Location', 'southeast')