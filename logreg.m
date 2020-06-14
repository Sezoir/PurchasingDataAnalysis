function S = logreg(a,h,p)  % a = [a , b]

S = sum((p-(1+exp(-a(1)*h-a(2))).^(-1)).^2);

% S = 0;
% for k = 1:length(h)
%     S = S + (p(k)-1/(1+exp(-a(1)*h(k)-a(2))))^2;
% end
