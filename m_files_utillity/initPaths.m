function [root, model, fList, seg] = initPaths(princInvestigator, spkName)

root = 'e:\projects\project_refactoring\';
    
model = [root 'data\db_final\' princInvestigator '_' spkName '\model\'];
fList = [root 'data\db_final\' princInvestigator '_' spkName '\'];
seg = [root 'data\db_final\' princInvestigator '_' spkName '\2d\'];


