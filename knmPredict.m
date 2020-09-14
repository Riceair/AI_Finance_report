function the_predict = knmPredict(label_1,label_2,test_data)
%   ㄏノfunction惠肚 knm眔label_1(把计1) knm眔label_2(把计2) 代刚戈(把计3)
%   肚the_predict
to_predict=zeros(length(test_data),1); %纗箇代戈

for i = 1 : length(test_data)
    dist_label_1=dist(label_1,test_data(i,:)');
    dist_label_2=dist(label_2,test_data(i,:)');
    if dist_label_1 < dist_label_2
        to_predict(i)=1;
    else
        to_predict(i)=-1;
    end
end
the_predict=to_predict;

