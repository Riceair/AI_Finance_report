function the_predict = knmPredict(label_1,label_2,test_data)
%   �ϥΦ�function�ݶǤJ knm�o�쪺label_1(�Ѽ�1) knm�o�쪺label_2(�Ѽ�2) ���ո��(�Ѽ�3)
%   �^��the_predict
to_predict=zeros(length(test_data),1); %�x�s�w�������

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

