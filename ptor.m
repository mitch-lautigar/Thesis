function z = ptor(mag,delta1)
[a,~] = size(mag);
z = [];
for i = 1:a
    delta = delta1(i,1)*pi/180;
    x = sqrt( (mag(i,1)*mag(i,1)) / (1+(tan(delta))^2) );
    y = x*tan(delta);

    z = [z;x+y*1j];
end
end