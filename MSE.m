function E = MSE(ans)

teste = table2array(ans)

T = size(teste,1);

Mdl = arima(4,1,8);

preidx = 1:Mdl.P;

estidx = (Mdl.P + 1):T;

EstMdl = estimate(Mdl,ans{estidx,"SourceIP"},...
    'Y0', ans{preidx,"SourceIP"},'Display','off');

resid = infer(EstMdl,ans{estidx,"SourceIP"},...
    'Y0',ans{preidx,"SourceIP"});
 
yhat = ans{estidx,"SourceIP"} - resid;

plot(ans.Timestamp(estidx),ans{estidx,"SourceIP"},'r',ans.Timestamp(estidx),yhat,'b--','LineWidth',2)

mse = mean(resid.^2)
end