%% Optimise the logreg function to find the parameters values
% Read file and format into table.
dataTable = readtable('purchasing_order.csv');
% Filter out data where rating is 0.
dataTable(dataTable.Rating == 0, :) = [];
% Get 2 arrays from the table columns of Rating and Return.
% We just pass in the Rating column from dataTable.
Rating = table2array(dataTable(:, 'Rating'));
% Note we want our array in terms of Pass (1) or fail (0), not 'Y' or 'N',
% so we do a simply boolean equality check against 'Y' for each element in
% the column. We check against the string "Y", as table2array returns an 
% array of cells.
Return = table2array(dataTable(:, 'Return')) == "Y";

% Create a short function, which gets the sum of the entries, of the
% difference between the true value of the Return (p) and the logarithmic
% function, for the logarithmic parameters (a), and the Rating input (h).
logreg = @(a,h,p) sum((p-(1+exp(-a(1)*h-a(2))).^(-1)).^2);

% Find the parameters (a) which minimise the sum difference of logreg,
% given the data of Rating and Return.
a = fminsearch(@(a) logreg(a, Rating, Return), [0 0]);  % Output: -15.4074   13.7003
a % Print the value.

%%  Make a graph, to visually see if the the model is correct.
% Create vector of 1 to 5 integers.
x = linspace(1, 5, 5)
% Create vector using regression function with found parameters, and pass
% in ratings from x.
y = (1+exp(-(x*a(1)+a(2)))).^-1
% Plot the raw data and logistic function.
plot(Rating, Return, '*', x, y)
% Add legend to graph.
lg = legend('Raw Data', 'Logistic Regression');
% Label x and y axis.
xlabel('Rating');
ylabel('Probability of return')

%% Simply checks
% Print the number of rows where the Rating column is greater than or equal
% to 2, and has a return.
height(dataTable((dataTable.Rating >= 2) & (dataTable.Return == "Y"), :))
% Get the subtable from dataTable with a rating of 1.
oneRating = dataTable(dataTable.Rating == 1, :);
% Print the percentage of those who returned the product against all the
% purchases from the oneRating table.
height(oneRating(oneRating.Return == "Y", :))/height(oneRating)

