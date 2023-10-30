# Time Series Filters

This repository cover some basics in time series filters, shows code in `R`, `Stata` and `Python` to apply the X-12-ARIMA filter to remove the seasonal component from a series and the HP Filter to remove trend from a series. This README file contains a short explanation of what are the different components and how filters works.
For now is based on some of the activities I have created as a teaching assistant in my undergraduate and masters career in Economics at Universidad de Chile, it includes material from the courses:  
- Quantitative Methods II and Quantitative Methods II/III (previous version of the actual II), where time series topics are covered. This course is an obligatory course in the Bachelor of Economics program at Universidad de Chile.
- Time Series Econometrics, an elective course of the Masters in Economics program at Universidad Alberto Hurtado, Chile.
- Time Series, an elective course of the Civil Engineering program at Universidad de Los Andes, Chile.

The first two courses were taught by Professor Andrés Sagner (PhD in Economics, Boston University) and the last one by Professor Mauricio Carrasco (MA in Economics, Pontificia Universidad Católica de Chile), so part of the material is extracted from their lecture notes and I'm thankful of their lessons.  

In a future I pretend to update this material with new methodologies and newer studies in time series components.  

## Time Series Components

Let $y_t$ be a time series, this series can be decomposed in 3 main components that are:  
- $\tau_t$: the trend component. This component can be either a deterministic or stochastic (stationary or non-stationary) process and usually it can be seen as the long-run movement of the time series.
- $s_t$: the seasonal component. This component can be either a deterministic or stochastic (stationary or non-stationary) process and usually it can be seen as a repetitive move of the time series associated to a seasonal period within a year as quarters, months or even weeks.
- $c_t$: the cycle component. This component is a stationary stochastic process that reflects the economic conditions or business cycles. Usually is seen as the remanent after extract the previous components.

### Seasonal Component

The seasonal component, also known as seasonality, is the component that is associated to a seasonal period within a year and has a known (at least in sign) effect over the series. An example is the positive effect that has the end of year celebrations such as christmas or new year in retail sales or the negative effect over productivity in holidays time. As a visual example consider the next graph of Chile's Real Gross Domestic Product in quarterly frequency from the first quarter of 1996 to the second quarter of 2023: ![Chile's Real GDP Full Period]([Graphs/GDPFull.png](https://github.com/NLeivaD/TSFilters/blob/main/Graphs/GDPFull.png "Chile's Real GDP 1996 - 2023") 
This seasonal component $s_t$ can be either a deterministic process or a stochastic process. In the first case it can be represented as a linear regression with a dummy variable associated to each seasonal period: $$s_t = \sum_{i=1}^{S}\beta_jd_t^j + \eta_t$$ Where $S$ is the frequency of the seasonal period in a year, for example if the time series is in monthly frequency $S = 12$ or in quarterly frequency $S = 4$. $d_t^j = 1$ if the observation at $t$ is from seasonal period $j$ (month, quarter, etc...) and 0 otherwise, and $\eta_t$ is a stationary stochastic process.  

In the stochastic case the seasonal component can be represented as an autorregresive process: $$s_t = \phi s_{t-h} + \varepsilon_t$$ Where $h$ is the frequency of the last seasonal period, as an example for monthly data $h = 12$ and for quarterly data $h = 4$. $\varepsilon_t$ a white noise process and this process can be either stationary ($|\phi| < 1$) or non-stationary.  

### Trend Component  

The trend component, also known just as trend, is the component that reflects the long-run movement of the time series. An example is the Consumer's Price Index (CPI) that in the long-run it clearly growths. This trend component $\tau_t$ can be either a deterministic process or a stochastic process. In the first case it can be represented as a linear regression $$$$
