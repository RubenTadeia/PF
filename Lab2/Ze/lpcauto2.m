function [ar,xi,e,m] = lpcauto2(x,M,win,Olap)

Nx = length(x);
N = length(win);
if (N == 1)
    N = win;
    win = ones(N,1);
end
F = fix((Nx-Olap)/(N-Olap));
ar = zeros(M+1,F);
xi = zeros(M+1,F);
e = zeros(Nx,1);
m = zeros(F,1);

n = 1:N;
n1 = 1:Olap;
n2 = N-Olap+1:N;
n3 = Olap+1:N;

win1 = win(n1)./(win(n1)+win(n2)+eps);
win2 = win(n2)./(win(n1)+win(n2)+eps);

for f=1:F
    [r,eta] = xcorr(x(n).*win,M,'biased');
    [a,xi(:,f),kappa] = durbin(r(M+1:2*M+1),M);
    ar(:,f) = [1; -a];
    ehat = filter(ar(:,f),1,x(n));
    e(n) = [e(n(n1)).*win2 + ehat(n1).*win1; ehat(n3)];
    m(f) = n(N);
    n = n + (N-Olap);
end
end