clc;
close all;
clear;
% 證券代碼1    年月2   市值(百萬元)3	收盤價(元)_年4	本益比5	股價淨值比6	
% 股價營收比7	M淨值報酬率─稅後8	資產報酬率ROA9	營業利益率OPM10	利潤邊際NPM11 負債/淨值比12	
% M流動比率13	M速動比率14	M存貨週轉率 (次)15	M應收帳款週轉次16	M營業利益成長率17	
% M稅後淨利成長率18	Return19	ReturnMean_year_Label20
labelname= {'證券代碼1  ' ,'年月2 ' , '市值(百萬元)3'	,'收盤價(元)_年4	','本益比5','股價淨值比6','股價營收比7',	'M淨值報酬率─稅後8','資產報酬率ROA9'	,'營業利益率OPM10'	,'利潤邊際NPM11' ,'負債/淨值比12'	,'M流動比率13',	'M速動比率14',	'M存貨週轉率 (次)15'	,'M應收帳款週轉次16'	,'M營業利益成長率17'	,'M稅後淨利成長率18',	'Return19',	'ReturnMean_year_Label20'};
datalist=dir('top200.xls');
stockreturn =[];
the_return =[];
the_stock=[];
current_return=[];
current_length=1;
data=xlsread(datalist(1,1).name); %讀進xls檔案並去掉第一列
data(:,2)=[]; %去掉第二行中文名稱
label=[7,9,10,12,15]; %9 10 12  %本益比有99999

%%
%日期切割
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

%%
for j = 1 : length(set_num)
    for i = 1 : length(label)
        X(:,i)=data(set_num(j,1):set_num(j,2),label(i)); %set_num(j,1) set_num(j,2)
    end
    stockreturn(:,1) = data(set_num(j,1):set_num(j,2),1);  %column 1 股票代碼
    stockreturn(:,2) = data(set_num(j,1):set_num(j,2),19); %column 2 19行的return
    opts = statset('Display','iter');
    
    %% 計算該年的總return
    real_returnsum=0;
    real_returncount=0;
    for i = 1 : length(stockreturn)
        if stockreturn(i,2)~=-100
            real_returnsum = real_returnsum + stockreturn(i,2);
            real_returncount = real_returncount+1;
        end
    end
    the_return(j,1)= real_returnsum/real_returncount;
    
    %% 歸一化
    datalength = length(X);
    minValue = min(X);
    maxValue = max(X);
    ranges = maxValue - minValue;
    X = (X- repmat(minValue,datalength,1))./repmat(ranges,datalength,1);
    %%
    %呼叫Kmeans函式
    %X N*P的資料矩陣
    %Idx N*1的向量,儲存的是每個點的聚類標號
    %Ctrs K*P的矩陣,儲存的是K個聚類質心位置
    %SumD 1*K的和向量,儲存的是類間所有點與該類質心點距離之和
    %D N*K的矩陣，儲存的是每個點與所有質心的距離;
    %eva=evalclusters(X,'kmeans','CalinskiHarabasz','KList',[1:10])  %測試最佳幾群
    %plot(eva)  %顯示明顯的分群數字
    
    K=5;
    [Idx,Ctrs,SumD,D] = kmeans(X,K,'Start','cluster','Replicates',3);
    stockreturn(:,3) = Idx;  %column 3 儲存分類
    
    for i=1:K
    sumreturn = 0;
    countreturn = 0;
        for k = 1:length(stockreturn)
            if stockreturn(k,3)==i
                sumreturn = sumreturn + stockreturn(k,2);
                countreturn = countreturn + 1;
            end
        end
        current_return(i,1)=sumreturn;  %總return
        current_return(i,2)=countreturn;
        current_return(i,3)=sumreturn/countreturn;
    end
    [the_max,index]=max(current_return(:,3)); %the_max為
    
    for i = 1 : length(stockreturn)
        if stockreturn(i,3)==index;
            the_stock(current_length,1:2)=data(set_num(j,1)+i,1:2);
            current_length=current_length+1;
        end
    end
    
    the_return(j,2)=the_max;
end

%% 畫圖
figure(1); %印出return
the_year=[1:length(set_num)];
plot(the_year,the_return(:,1),'b.-','MarkerSize',12);
hold on;
xlabel ('year');
ylabel('return');
plot(the_year,the_return(:,2),'r.-','MarkerSize',12)
hold on
grid on %劃出格線
title ([labelname(label(:,:))]);
legend('realreturn' ,'prediction' ,'Location','NW')