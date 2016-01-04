% loggaussian probability density function

function pdf = loggpdf(Rnow,mu,sg)
        pdf = (1./(Rnow*sg*sqrt(2*pi))).*exp(-1*(log(Rnow)-mu).^2./(2*sg^2));
    end
