function [label_1,label_2] = knmTrain(train_data,train_ans)
%	使用此function需傳入 訓練資料(參數1) 訓練答案(參數2) 註:訓練答案必為 1 or -1
%   回傳label_1 為屬於 label 1 的中心點
%   回傳label_2 為屬於 label 2 的中心點
[row,column]=size(train_data); %取得train_data的矩陣大小

count_label_1=0; %算屬於label1的總數
count_label_2=0; %算屬於label2的總數
sum_label_1=zeros(1,column); %放屬於label1的加總
sum_label_2=zeros(1,column); %放屬於label2的加總

for i = 1 : length(train_data) %依照label分類並加總
    if train_ans(i)==1
        count_label_1 = count_label_1 + 1;
        sum_label_1 = sum_label_1 + train_data(i,:);
    elseif train_ans(i)==-1
        count_label_2 = count_label_2 + 1;
        sum_label_2 = sum_label_2 + train_data(i,:);
    end
end
label_1=sum_label_1./count_label_1; %將加總平均回傳
label_2=sum_label_2./count_label_2;
