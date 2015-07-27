%
% demonstrate tasks related to an utterance plan
%

clear *

% calling the constructor with a string creates a valid UtterancePlan
myUtterancePlan = UtterancePlan('xxx');

% set / manipulate timing information by using set-methods 
myUtterancePlan.durHold = [0.120 0.120 0.120];

% set / manipulate muscle activation by using set-methods 
myUtterancePlan.deltaLambdaGGP = [10, -20, 10];
myUtterancePlan.deltaLambdaGGA = [-20, 10, -20];
myUtterancePlan.jawRotation = [9, 0, -9];


% plot deltaLambda traces over time, for instance GGP
myUtterancePlan.plot('deltaLambdaGGP', 'k-')
% plot deltaLambda traces over time, for instance GGA with different color
myUtterancePlan.plot('deltaLambdaGGA', 'b-')
% plot jaw rotation over time
myUtterancePlan.plot('jawRotation', 'r-')

