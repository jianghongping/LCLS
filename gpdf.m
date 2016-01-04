% gaussian probability density function

function pdf = pdf(Rnow,Ro,sigRo)
        pdf = 1/(sigRo*sqrt(2*pi))*exp(-1*(Rnow-Ro).^2./(2*sigRo^2));
    end
    
    