% compare two mat-files

clear all

spkString1 = 'cs';
spkString2 = 'cx';

path1 = ['d:/projects/project_refactoring/possum/data/models_obsolete/' spkString1 '/'];
path2 = ['d:/projects/project_refactoring/possum/data/models_obsolete/' spkString2 '/'];

fnString1 = ['data_palais_repos_' spkString1 '.mat'];
fnString2 = ['data_palais_repos_' spkString2 '.mat'];

fn1 = [path1 fnString1];
fn2 = [path2 fnString2];


visdiff(fn1, fn2)