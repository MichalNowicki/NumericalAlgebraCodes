function [ y ] = myf( x )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

y = x.^2 + sin(x) + 1./x + cos(x).^5 + log(x);
%y = tanh(20*sin(12*x)) + .02*exp(3*x).*sin(300*x);
end

