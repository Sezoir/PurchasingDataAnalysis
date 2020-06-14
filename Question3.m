% Read file and format into table.
dataTable = readtable('purchasing_order.csv');
% Get a new subtable of dataTable, where we filter for all rows who have
% bought a product from category 'C'.
filDataTable = dataTable(dataTable.Product_Category == "C", :);
% Get the unique customer ids from the filtered table, using the first
% customer id found in case of duplicates.
[ID,index] = unique(filDataTable.Customer_ID);
uniTable = filDataTable(index, {'Customer_ID'});
% Find weights:
valueWeight = 1;
rateWeight = mean(filDataTable.Product_Value)/ ...
             mean(filDataTable.Rating(filDataTable.Rating~=0));
% Loop through each customer in uniTable, and find there average product
% value, average rating and then the wieghted average.
for ind = 1:height(uniTable)
    % Get unique customer for current index.
    customer = uniTable.Customer_ID(ind);
    % Get subtable of all purchases of product 'C' by that customer.
    table = filDataTable(filDataTable.Customer_ID == customer, :);
    % Calculate the average value and rating for that customer.
    avrValue = mean(table.Product_Value);
    avrRating = mean(table.Rating(table.Rating~=0));
    % Check avrRating isn't NaN due to not having rated a product.
    if isnan(avrRating)
        avrRating = 0;
    end
    % Append the average value, rating, and then the weighted average to uniTable.
    uniTable.avrValue(ind) = avrValue;
    uniTable.avrRating(ind) = avrRating;
    uniTable.weightedAvr(ind) = (valueWeight*avrValue+rateWeight*avrRating)/ ...
                                (valueWeight+rateWeight);
end
% Sort rows according to there weightedAvr column, from highest to lowest.
uniTable = sortrows(uniTable, 'weightedAvr', 'descend');
% Add simple increasing id for each purchase.
uniTable.id = (1:height(uniTable)).';
% Get the first and last five rows from uniTable
uniTable([1:5,96:100],:)
% uniTable([1:100],:)

% (valueWeight*avrValue+rateWeight*avrRating)/(avrValue+avrRating);
