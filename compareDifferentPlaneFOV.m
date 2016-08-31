function compareDifferentPlaneFOV (fovData, targetID)
    

    fields = fieldnames(fovData);
    fov = cell(numel(fields), 2);

    for i = 1:numel(fields)
        tempFOV = fovData.(fields{i});
        index = [tempFOV{:, 1}] == targetID;
        fov{i, 1} = fields{i};
        fov{i, 2} = tempFOV{index, 2};

    end

    analyseFullFOV(fov, [], 'nocv')
end