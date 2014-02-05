function [root, model, mri] = initPaths(princInvest, spkName)
    
    root = 'e:/projects/project_refactoring/opossum/';
    
    model = [root 'data/db_examples/' princInvest '_' spkName '/speakerModel/'];
    mri = [root 'data/db_examples/' princInvest '_' spkName '/speakerImaging/'];

end
