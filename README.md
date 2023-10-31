# Time Series Filters

This repository cover some basics in time series filters[^1], shows code in `R`, `Stata` and `Python` to apply the X-12-ARIMA filter in order to remove the seasonal component from a series and the Hodrick-Prescott Filter (HP) in order to remove the trend component from a series. This README file contains a short explanation of what are the different components and how filters works. For now is based on some of the activities I have created as a teaching assistant in my undergraduate and masters career in Economics at Universidad de Chile, it includes material from the courses:  
- Quantitative Methods II and Quantitative Methods II/III (previous version of the actual II), where time series topics are covered. This course is an obligatory course in the Bachelor of Economics program at Universidad de Chile.  
- Time Series Econometrics, an elective course of the Masters in Economics program at Universidad Alberto Hurtado, Chile.  
- Time Series, an elective course of the Civil Engineering program at Universidad de Los Andes, Chile.  

The first two courses were taught by Professor Andrés Sagner (PhD in Economics, Boston University) and the last one by Professor Mauricio Carrasco (MA in Economics, Pontificia Universidad Católica de Chile), so part of the material is extracted from their lecture notes and I'm very thankful of their lessons.  

In the very next this document is structured as follows: first I revise the main time series components along with give some definitions and examples, second two types of time series structure that can be found and third a review of the time series filters mentioned. All the data shown in this repository is obtained from the [Statistics Database (BDE)](https://si3.bcentral.cl/Siete/en) of the Central Bank of Chile, so is free and public available.  

## Time Series Components

Let $y_t$ be a time series, this series can be decomposed in 3 main components[^2] that are:  
- $\tau_t$: the trend component. This component can be either a deterministic or stochastic (stationary or non-stationary) process and usually it can be seen as the long-run movement of the time series.
- $s_t$: the seasonal component. This component can be either a deterministic or stochastic (stationary or non-stationary) process and usually it can be seen as a repetitive move of the time series associated to a seasonal period within a year as quarters, months or even weeks.
- $c_t$: the cycle component. This component is a stationary stochastic process that reflects the economic conditions or business cycles. Usually is seen as the remanent after extract the previous components.

An example of an economic time series that shows clearly all this components is Chile's Real Gross Domestic Product (GDP). In the next graph it can be seen the Real GDP in quarterly frequency for Chile from the first quarter of 1996 to the first quarter of 2023:  
<img src="https://github.com/NLeivaD/TSFilters/blob/main/Graphs/GDPFull.png" width="700" height="400">  
In this can be seen how the series has repetetive movements along the years, a long-run growth and some deviations from this patterns, in the respective subsections are revised in detail this aspects.  

### Seasonal Component

The seasonal component, also known as seasonality, is the component that is associated to a seasonal period within a year and has a known (at least in sign) effect over the series. An example is the positive effect that has the end of year celebrations such as christmas or new year in retail sales or the negative effect over productivity in holidays time. If you make a zoom to the Real GDP series and see fewer years you can see this clearly. As an example you can see in the next graph the same series for three years, from the first quarter of 2010 to the fourth quarter of 2012:  
<img src="https://github.com/NLeivaD/TSFilters/blob/main/Graphs/GDP20102013.png" width="700" height="400">  
In the previous graph you can see how each transition from the first quarter to the second quarter and from the third quarter to the fourth quarter shows an increase in the Real GDP while each transtition from the second quarter to the third quarter and from the fourth quarter of a year to the first quarter of the next year shows a decrease. This repetitive movement is the seasonality. There is many ways to identify seasonality using visual inspection, now I show one more example that is using a subseries plot. This type of plot shows one series for seasonal period and the mean of each subseries, a useful way to see if a seasonal period has different values respect to the others seasonal periods  
<img src="https://github.com/NLeivaD/TSFilters/blob/main/Graphs/GDP_Subseries.png" width="700" height="400">  
In this graph is seen how the fourth quarter starts and ends above the other series, also its mean is over the others.  

The seasonal component $s_t$ can be either a deterministic process or a stochastic process. In the first case it can be represented as a linear regression with a dummy variable associated to each seasonal period: $$s_t = \sum_{i=1}^{S}\beta_jd_t^j + \eta_t$$ Where $S$ is the frequency of the seasonal period in a year, for example if the time series is in monthly frequency $S = 12$ or in quarterly frequency $S = 4$. $d_t^j = 1$ if the observation at $t$ is from seasonal period $j$ (month, quarter, etc...) and 0 otherwise, and $\eta_t$ is a stationary stochastic process.  

In the stochastic case the seasonal component can be represented as an autorregresive process: $$s_t = \phi s_{t-h} + \varepsilon_t$$ Where $h$ is the frequency of the last seasonal period, as an example for monthly data $h = 12$ and for quarterly data $h = 4$. $\varepsilon_t$ a white noise process and this process can be either stationary ($|\phi| < 1$) or non-stationary.  

### Trend Component  

The trend component, also known just as trend, is the component that reflects the long-run movement of the time series. In Chile's Real GDP example is shown a clearly growth in the long-run, fact that is supported with the next graph that shows the seasonally adjusted[^3] Real GDP for Chile:  
<img src="https://github.com/NLeivaD/TSFilters/blob/main/Graphs/GDP_SA.png" width="700" height="400">  
In this series without seasonality it is clearly seen how the series tends to growth over time, with some deviations from this trend that are attributable to the cycle component. The trend component $\tau_t$ can be either a deterministic process or a stochastic process. In the first case it can be represented as a linear regression, simple or polynomial $$\tau_t = \alpha + \sum_{j=1}^{p}\beta_j\tau^j + \eta_t$$ Also this deterministic trend can be generated by an exponential process such as $$\tau_t = \alpha e^{\beta t}$$ In the stochastic case is usually represented by an integrated process of order $d$ $$(1-L)^{d}\tau_t = \varepsilon_t$$ Where $\varepsilon_t$ is a white noise process.

### Cycle Component  

The cycle component is a stationary stochastic process that reflects the economic conditions or business cycles, in the next graph is shown the cycle of the natural logarithm (latter I will explain why the natural logarithm instead the level) of the Real GDP SA series:  
<img src="https://github.com/NLeivaD/TSFilters/blob/main/Graphs/LogGDP_Cycle.png" width="700" height="400">  
This cycle component reflects the conditions in chilean economy such as the recessions (red shaded areas) due to subprime crisis (2008 - 2010), social outburst (2019) or COVID-19 (2020) as an example, and the boom periods like the recovery process (blue shaded areas) from recessions such as Asian Crisis (1997 - 1998) or COVID-19 (2021 - 2022) as an example.  

## Time Series Structure  

In the previous section when was seen the cycle component was used as an example the natural logarithm of the Real GDP instead the level of the series, in this section is the reason why was shown the logarithm. In a time series the three components mentioned can interact in more than one way between each other, in this repository I show two cases: (i) the additive time series and (ii) the multiplicative time series. In the additive case the time series can be decomposed as $$y_t = s_t + \tau_t + c_t$$ While in the multiplicative case the time series is decomposed as $$y_t = s_t \times \tau_t \times c_t$$ Is clearly that if the logarithm is applied to a multiplicative time series it results in an additive time series $$\ln{(y_t)} = \ln{(s_t \times \tau_t \times c_t)} = \ln{(s_t)} + \ln{(\tau_t)} + \ln{(c_t)}$$ Is important to know the difference because the time series filters studied in this repository, X-12-ARIMA for deseasonalizing and HP for detrending, assumes they are studying additive time series.  

A key to identify if a time series is additive or multiplicative is to see the magnitude of the seasonal component, for example in the first graph is seen how variations due to the seasonality in the 1990s is little in comparison to the variations due to seasonality 2010s. In contrast, next I show you the natural logarithm of the Real GDP:  
<img src="https://github.com/NLeivaD/TSFilters/blob/main/Graphs/LogGDP.png" width="700" height="400">  
In this graph you can see how the seasonal variations are reasonably constant in magnitude along the years. Other approach is that the series is in a measure unit that is not a rate. As an example in the next graph you can see the monthly inflation rate for Chile in the period from January, 2010 to September, 2023:  
<img src="https://github.com/NLeivaD/TSFilters/blob/main/Graphs/InflationRate.png" width="700" height="400">  
As seen this series have a key indicator that points its decomposition must be additive instead multiplicative and is that it has negative values, so it cannot be inputed to logarithm.  

## Time Series Filters  

In this last section I revise two time series filters:  
1. The X-12-ARIMA filter to deseasonalizing.
2. The Hodrick-Prescott filter to detrending.
The idea is to make a brief review of the logic of this filters, their applications are made in the different codes available on each program folder.

### X-12-ARIMA  

The X-12-ARIMA filter is a non-parametric filter to deseasonalize a time series in monthly or quarterly frequency, is a tool developed by the US Census Bureau but no longer mantained or available for the same institution, now the institution provides the X-13-ARIMA-SEATS that works with a very similar logic. The basic idea of the X-12-ARIMA filter is to estimate a SARIMA($p,d,q$)($p_s,d_s,q_s$) model for the time series $$\Phi(L)\Phi^s(L_s)(1-L)^d(1-L_s)^{d_s}y_t = \Theta(L)\Theta^s(L_s)\varepsilon_t$$ Where $\varepsilon_t$ is a white noise process, $\Phi(L)$ the autorregresive polynomial associated to the cycle component $c_t$, $\Phi^s(L_s)$ the autorregresive polynomial associated to the seasonal component $s_t$, $d$ the integration order of $\tau_t$, $d_s$ the integration order of $s_t$ and $\Theta(L)$ with $\Theta^s(L_s)$ the polynomials associated to the moving average part of $c_t$ and $s_t$ respectively. In the next graph you can see the result of apply this filter to the natural logarithm of the Chilean Real GDP:  
<img src="https://github.com/NLeivaD/TSFilters/blob/main/Graphs/LogGDPSAX12.png" width="700" height="400">  
Applying the exponential function $e$ it can be obtained the seasonally adjusted series in level:  
<img src="https://github.com/NLeivaD/TSFilters/blob/main/Graphs/GDPSAX12.png" width="700" height="400">  
As seen the filter is able to remove the seasonality from the series and returns the SA series.  

### HP Filter

Once the series has been deseasonalized, or if the series has no seasonality, the very next step is to detrending[^4] the time series. One of the most popular methods for detrending is the Hodrick-Prescott Filter, filter that allows to remove the trend component (either stochastic or deterministic) from a time series based on the next assumption of the series decomposition: $$y_t = \tau_t + c_t$$ Inmediately you can see the importance of have removed, if necessary, the seasonal component and work with an additive time series. The filter also assumes that $$\Delta^2\tau_t = \Delta(\Delta\tau_t) = \Delta\tau_t - \Delta\tau_{t-1} = (\tau_t - \tau_{t-1}) - (\tau_{t-1} - \tau_{t-2})$$ Is a stationary process and the cycle component $c_t$ is a stationary process. Under this assumptions solves the next problem: $$\min_{ \lbrace \tau_t \rbrace_{t=1}^{T} } \sum_{t=1}^{T}(y_t - \tau_t)^2 + \lambda \sum_{t=2}^{T-1}[(\tau_{t+1} - \tau_t) - (\tau_t - \tau_{t-1})]^2, \quad \lambda \geq 0$$ Where $\lambda$ is a smoothing parameter such that if $\lambda = 0$ it happens $\widehat{\tau_t} = y_t$ so the estimated trend equals the series (non smoothing at all) and if $\lambda \to \infty$ it happens $\widehat{\tau_t} = a + b t$ so the estimated trend is a linear equation (all the smooth it can be). The previous is simple to seen under the fact that the minimization problem has the next First Order Condition (FOC): $$y_t - \tau_t = \lambda(\Delta\tau_{t+2} - 3 \Delta\tau_{t-1} + 3 \Delta\tau_t - \Delta\tau_{t-1})$$ So when $\lambda = 0$ the right hand term equals 0 and the trend equals the series. Under $\lambda \to \infty$ if both sides of the equation are multiplied by $1 / \lambda$ then the left hand term goes to 0 and the right hand equals 0 when the trend is a linear equation.  

Hodrick & Prescott (1997)[^HP] establish that if $c_t \sim iid N(0, \sigma^2_c)$ and $\Delta^2\tau_t\sim iid N(0, \sigma^2_\tau)$ then $\sqrt{\lambda} = \sigma_c / \sigma_\tau$. The authors considers for quarterly data that $\sigma_c = 0.05$ and $\sigma_\tau = 0.00125$, so $\lambda = 1600$. Ravn & Uhlig (2002)[^RU] extends for monthly data $\lambda = 129600$ and for annual data $\lambda = 6.25$.

[^1]: In a future I pretend to update this material with more methodologies and studies in time series components, such as a more variety of filters and types of time series decompositions.  
[^2]: In some literature it can be found the distintion of a fourth component named the Irregular Component. In this basic introduction the irregular component is part of the cycle component.  
[^3]: Seasonally Adjusted, or SA, is the term that stands for the time series after removing the seasonal component.  
[^4]: A very important detail is to identify if a time series does have a trend component or has a unit root, this topic and its consequences are not covered in this repository but if assumed that if you are applying this is because you have identified correctly that the time series is trend-stationary.
[^HP]: Hodrick, R. J. and E. C. Prescott (1997), "Postwar U.S. Business Cycles: An Empirical Investigation", *Journal of Money, Credit and Banking* 29(1): 1–16.  
[^RU]: Ravn, M. O. and H. Uhlig (2002), “On Adjusting the Hodrick-Prescott Filter for the Frequency of Observations”, *The Review of Economics and Statistics* 84(2): 371–380.
