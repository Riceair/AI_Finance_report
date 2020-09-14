clc;
close all;
clear;
% 證券代碼1    年月2   市值(百萬元)3	收盤價(元)_年4	本益比5	股價淨值比6	
% 股價營收比7	M淨值報酬率─稅後8	資產報酬率ROA9	營業利益率OPM10	利潤邊際NPM11 負債/淨值比12	
% M流動比率13	M速動比率14	M存貨週轉率 (次)15	M應收帳款週轉次16	M營業利益成長率17	
% M稅後淨利成長率18	Return19	ReturnMean_year_Label 20
labelname= {'證券代碼1  '  ,'年月2 ' , '市值(百萬元)3'	,'收盤價(元)_年4	','本益比5','股價淨值比6','股價營收比7',	'M淨值報酬率─稅後8',	'資產報酬率ROA9'	,'營業利益率OPM10'	,'利潤邊際NPM11' ,'負債/淨值比12'	,'M流動比率13',	'M速動比率14',	'M存貨週轉率 (次)15'	,'M應收帳款週轉次16'	,'M營業利益成長率17'	,'M稅後淨利成長率18',	'Return19',	'ReturnMean_year_Label20'};
datalist = dir('top200.xls');
data = xlsread(datalist(1,1).name);
data(:,2)=[]; %去掉中文名稱
the_data=[]; %選擇使用的data
the_stock=[]; %儲存選的股票
the_accuracy=[]; %儲存TV的正確率
the_return=[]; %儲存return值 1為總(實際)return 2為預測return 
label=[6,7,9,14,15]; %6,7,9,12

%% 日期切割
set_num=[]; %儲存每200比資料的range ex.1到200 201到400....
count_set=1; %儲存現在切到第幾年
for i = 1 : length(data)
    if mod(i,200)==1
        set_num(count_set,1) = i;
    elseif mod(i,200)==0
        set_num(count_set,2) = i;
        count_set=count_set+1;
    end
end

%% 將選擇的attribute放入the_data
for i=1:length(label)
    the_data(:,i)=data(:,label(i));
end

%% 歸一化
datalength = length(the_data);
minValue = min(the_data);
maxValue = max(the_data);
ranges = maxValue - minValue;
the_data = (the_data- repmat(minValue,datalength,1))./repmat(ranges,datalength,1);

%% 開始KnM
train_data=[]; %儲存訓練的資料
train_ans=[]; %儲存訓練資料的答案
test_data=[]; %儲存測試的資料
test_ans=[]; %儲存測試的答案
TV = count_set-2;
for i=1:TV-1
    train_num = set_num(i,2);  %訓練到第幾筆資料
    test_num = set_num(i+1,1);  %從第幾筆資料開始測試
    train_data = the_data(1:train_num,1:end); %訓練資料
    train_ans = data(1:train_num,20); %訓練答案
    test_data = the_data(test_num:end,1:end); %測試資料
    test_ans = data(test_num:end,20); %測試答案
    [result_1,result_2]=knmTrain(train_data,train_ans);
    the_predict=knmPredict(result_1,result_2,test_data);  %result_1 result_2為訓練結果 test_data為訓練資料
    KnM_accuracy=length(find(the_predict == test_ans))/length(test_ans)*100; %算正確率
    the_accuracy(i,1)=KnM_accuracy;
    
    origin_return=0; %測試資料所有的return
    origin_count=0; %測試資料統計return總數
    predict_return=0; %預測資料預測為1的return
    predict_count=0;  %預測資料為1的return總數
    for k=1:length(the_predict) %統計return值
        if data(test_num-1+k,19)~=-100
            origin_return=origin_return + data(test_num-1+k,19);
            origin_count = origin_count+1;

            if the_predict(k)==1
                predict_return = predict_return + data(test_num-1+k,19); %預測的return
                predict_count = predict_count + 1;
                the_stock(predict_count,1:2)=data(test_num-1+k,1:2);
            end
        end
    end
    the_return(i,1)=origin_return./origin_count;
    the_return(i,2)=predict_return./predict_count;
end

%% 畫資料
TV=[1:length(the_return)];
figure(1); %印出return
plot(TV,the_return(:,1),'b.-','MarkerSize',12);
hold on;
xlabel ('TV');
ylabel('return');
plot(TV,the_return(:,2),'r.-','MarkerSize',12)
hold on
grid on %劃出格線
title ([labelname(label(:,:))]);
legend('realreturn' ,'prediction' ,'Location','NW')
print(gcf,'-dpng','final.png'); 

figure(2); %印出正確率
plot(TV,the_accuracy,'mo-','MarkerSize',12);
hold on;
xlabel ('TV');
ylabel('Accuracy');
grid on %劃出格線
title ([labelname(label(:,:))]);
legend('accuracy' ,'Location','NW')
print(gcf,'-dpng','Accuracy.png'); 