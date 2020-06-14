% Read file and format into table.
dataTable = readtable('purchasing_order.csv');
% Get a new subtable of dataTable, where we filter for all rows who have
% returned a product.
filDataTable = dataTable(dataTable.Return == "Y", :);
% Get the unique customer ids from the filtered table, using the first
% customer id found in case of duplicate purchases.
[ID,index] = unique(filDataTable.Customer_ID);
uniTable = filDataTable(index,:);
% For each customer in uniTable, find the total sum of there bough products 
% cost, before there first returned product, and after. Note we ignore any
% purchases that have been returned by the customer.
for ind = 1:height(uniTable)
    % Get associated customer id and subtable of all purchases by that
    % customer.
    customer = uniTable.Customer_ID(ind);
    table = dataTable(dataTable.Customer_ID == customer, :);
    % Remove all refunded purchases.
    table(ismember(table.Return, "Y"), :) = [];
    % Add two new columns to uniTable, for there prepurchases and
    % postpurchases.
    uniTable.prePurchases(ind) = sum(table.Product_Value( ...
                    uniTable.Date(uniTable.Customer_ID == customer) > table.Date));
    uniTable.postPurchases(ind) = sum(table.Product_Value(...
                    uniTable.Date(uniTable.Customer_ID == customer) < table.Date));
end

% For each customer in uniTable find out there likelihood that they will
% return, given by postPurchases/(prePurchases+postPurchases)%.
uniTable.likelihood = uniTable.postPurchases.* ...
                      (uniTable.prePurchases+uniTable.postPurchases).^-1;

% Find the mean and median of the likelihood column in table uniTable.
likeMean = mean(uniTable.likelihood)
likeMedian = median(uniTable.likelihood)

% Draw boxplot using likelihood column data from uniTable.
boxplot(uniTable.likelihood);
% Label the x and y axis.
xlabel("Customers who have returned a product");
ylabel("Likelihood of a returning customer for all returned customers");
% Save box plot as file.
print -depsc boxFig;
