function [root, model, mri] = initPaths(princInvest, spkName)
    
    root = 'd:/projects/project_POSSUM/possum/';
    
    model = [root 'data/db_examples/' princInvest '_' spkName '/speakerModel/'];
    mri = [root 'data/db_examples/' princInvest '_' spkName '/speakerImaging/'];

end
