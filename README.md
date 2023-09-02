### **Probabilistic forecasts for monitoring: <a href="https://matv.shinyapps.io/app_4DROP/" target="_blank_">4DROP</a>**


4DROP are seasonal forecasts of meteorological drought with a probabilistic approach made several months in advance. They have been constructed using an empirical method inspired by the "Ensemble Streamflow Prediction system" (ESP, Twedt, 1977, Day 1985). 4DROP combines the datasets that make up DROP (Turco et al., 2020) as initial conditions with resampled data from the ESP method (see, for example, Torres-Vázquez et al., 2023; Turco et al., 2017). 4DROP offers the capability to visualize various predictions throughout the time series spanning from 1981 to 2022, on a monthly interval basis. Additionally, it enables the exploration of the diverse datasets that constitute 4DROP, and it provides multiple ways to represent the drought risk.

Before delving into the different buttons within the interface, it's essential to note that the application's central area presents two maps. The map on the left displays the monitoring of meteorological drought through the Standardized Precipitation Index accumulated over six months (SPI6; Mckee et al., 1993). In simpler terms, it shows the SPI6 of DROP. On the other hand, by default, the map on the right presents the SPI6 of 4DROP. However, in this case, you have the option to visualize the predictions corresponding to each of the individual members that constitute 4DROP. Below, we describe the functions of the five tabs available in the interface:

**Choose information type**: This option allows you to view different representations of meteorological drought information:
<br/>
- *MEAN (Average)*: Displays the values of the SPI index, which help identify wet periods (positive values) and dry periods (negative values) in comparison to long-term climatic conditions in different regions. This is useful for quantifying drought conditions and providing a response during drought episodes.
- *SPREAD (Dispersion)*: Provides an estimate of uncertainty. High dispersion values indicate significant uncertainty, suggesting that both normal and drought conditions may be equally probable. This highlights the challenge faced by monitoring and alert systems.
- *PROB (Probability)*: Shows the total probability of experiencing (at least) moderate drought (SPI ≤ -0.8; Svoboda et al., 2002), offering a more detailed representation of uncertainty and being useful for experienced users.
- *TRAF_LIG (SPI Warning Level)*: This map is designed to allow users to distinguish between severe droughts with a high probability and mild droughts with a low probability. In other words, the colors indicate a combination of probability and severity, as explained in the table below:
<br/>
<br/>
<p align="center">
  <img src="https://github.com/MTAV26/4DROP/blob/main/WarningLevels.png" width="450" title="hover text">
</p>
<br/>
For instance, the color yellow could reflect both a high probability of abnormally dry conditions and a low probability of severe drought. This approach is based on the disaster management guidelines of the European Commission (EC, 2010).


**Choose a dataset**: This option allows you to view the predictions of the eleven members that compose 4DROP and compare them with DROP. In other words, the left panel consistently displays the monitoring of DROP, while the right panel defaults to displaying 4DROP. Nevertheless, you have the option to view the predictions corresponding to each of the individual members that make up 4DROP.

**Choose a month**: Allows you to change the prediction month you wish to visualize.

**Choose a year**: Enables you to change the year you intend to represent.


### Source data and code
**A. General instructions** 


This project is designed to be executed with R scripts. 
Execute script files in the order they are listed.

Data sources:

The "observed" precipitation data as collected by DROP members are available in the data section of this repository "https://github.com/MTAV26/thesis/tree/main/Chapter4-4DROP/Data". However, it is important to note that the GPCP dataset, identified as "gpcp_cdr_v23rB1_1981_2021.nc," exceeds the maximum 25 MB limit allowed for downloads on this website. To access this data, we recommend downloading it through the following web link: https://psl.noaa.gov/data/gridded/data.gpcp.html, or alternatively, establishing direct contact with the responsible author.

The following reference shows the data applied as predictors of 4DROP. 

| Dataset  | Source |
| :------------ |:---------------|
| CAMS\_OPI | http://www.cpc.ncep.noaa.gov/products/global_precip/html/wpage.cams_opi.html       |
| CHIRPS  (v2)    | http://chg.geog.ucsb.edu/data/chirps/        |
| CPC | https://www.esrl.noaa.gov/psd/data/gridded/data.cpc.globalprecip.html        |
| ERA5 (Ensemble mean) | https://www.ecmwf.int/en/forecasts/datasets/archive-datasets/reanalysis-datasets/era5      |
| GPCC  | https://www.dwd.de/EN/ourservices/gpcc/gpcc.html      |
| GPCP (V2.3)      | http://eagle1.umd.edu/GPCP_ICDR/Data/ |
| JRA-55  | http://jra.kishou.go.jp/JRA-55/index_en.html      |
| MERRA2  | https://www.esrl.noaa.gov/psd/data/gridded/data.ncep.reanalysis2.html      |
| MSWEP | https://www.gloh2o.org/mswep/       |
| NCEP  | https://www.esrl.noaa.gov/psd/data/gridded/data.ncep.reanalysis2.html     |
| PREC/L | https://www.esrl.noaa.gov/psd/data/gridded/data.precl.html       |
<br/>
<br/>

The script files have been organized with the goal of facilitating reproducibility. They are first sorted alphabetically and then numerically. However, it's important to note that due to the absence of GPCP data, these scripts will not run unless you download the data or contact the corresponding author, as mentioned earlier. If you choose to download them from the website, you will need to adjust the resolution to 2.5°x2.5° and select only the period between 1981 and 2020. If you have any questions or wish to provide feedback to the authors, we encourage you to get in touch with Miguel Ángel Torres-Vázquez via the email address provided above.


In the case of the SEAS5-related data, they are available through the Copernicus Climate Data Store. To obtain this data, access can be gained through the following web link: [https://cds.climate.copernicus.eu/cdsapp#!/search?type=dataset](https://cds.climate.copernicus.eu/cdsapp#!/search?type=dataset).  If you have any questions or wish to provide feedback to the authors, we encourage you to get in touch with Miguel Ángel Torres-Vázquez via the email address provided above.


# 
**B. Description of script files**
Scripts for data preparation and cleaning.

**Development**
- A1_Loop_load_SPI.R: Reads precipitation data and calculates SPI6 for the eleven members of DROP.
- A1_load_DROP.R: Calculates the mean, spread, probability of moderate drought, and alert level for DROP.
- B1_Forecast_ESP_loop.R: Calculates ESP predictions for December-January-February (DJF), March-April-May (MAM), June-July-August (JJA), September-October-November (SON).
- B2_load_ESP.R: Calculates the mean, spread, probability of moderate drought, and alert level for 4DROP.
- C1_Load_S5_raw_all_members.R: Combines all SEAS5 predictions.
- C2_Load_S5_raw_ens.R: Same as above (this was a test).
- C3_bias_adj_all_members.R: Adjusts bias in predictions for each of the DROP sets.
- C4_Verify_S5_pre.R: Verifies that there are no errors with bias and correlation.
- C5_Forecast_S5_loop.R: Calculates S5 predictions for DJF, MAM, JJA, SON.
- C6_load_SEAS5.R: Calculates the mean, spread, probability of moderate drought, and alert level for S5.

**Deterministic validation**
- D1_Verify_COR_ESP_loop.R: Calculates the correlation of 4DROP for DJF, MAM, JJA, SON.
- D2_Verify_COR_SEAS5_loop.R: Calculates the correlation of S5 for DJF, MAM, JJA, SON.
- D3_Verify_COR_ens_mean_mb_loop.R: Calculates the correlation of 4DROP and S5 members for DJF, MAM, JJA, SON.
- D4_Boxplot_COR_detrended.R: Represents spatial correlation without trend in boxplot for 4DROP and S5 for DJF, MAM, JJA, SON.
- D4_Boxplot_COR_original.R: Represents spatial correlation with trend in boxplot for 4DROP and S5 for DJF, MAM, JJA, SON.
- D5_PLOT_COR.R: Represents spatial correlation maps of ESP(4DROP) and S5 for DJF, MAM, JJA, SON.

**Probabilistic verification**
- E1_Verify_Reliability_loop.R: Calculates the reliability of predictions for 4DROP and S5 for DJF, MAM, JJA, SON and represents the attribute diagram plot.
- E2_Boxplot_reliability.R: Represents reliability of predictions in boxplot for 4DROP and S5 for DJF, MAM, JJA, SON.
- F1_Verify_ROC_loop.R: Calculates the skill of predictions for 4DROP and S5 for DJF, MAM, JJA, SON and represents the ROC plot.
- F2_Boxplot_ROC.R: Represents the ROC of predictions in boxplot for 4DROP and S5 for DJF, MAM, JJA, SON.
- G1_BS.R: Calculates the Brier Score of predictions for 4DROP and S5 for DJF, MAM, JJA, SON.
- G2_BS_mb.R: Calculates the Brier Score of predictions for the members of 4DROP and S5 for DJF, MAM, JJA, SON.
- G3_BS_plot.R: Represents the BS maps of 4DROP and S5 for DJF, MAM, JJA, SON.

**Study case**
- H1_Caso_Estudio.R: Represents the maps of SPI6 mean, spread, probability of moderate drought, and alert level for DROP, 4DROP, and S5.
- H2_Caso_Estudio_Boxplot.R: Represents boxplots of SPI6 mean for DROP, 4DROP, and S5. In a grid over South America, with a lead time of two months for the entire time series 1981-2020 in JJA. Location: longitude = -63.75, latitude = -33.75.

In the "cammon" folder, you will find additional script files that are useful for the execution of the main script files described above. This folder corresponds to the .R files for DROP (Turco et al., 2020).

### Citation
Torres-Vázquez, M. Á., Di Giuseppe. F., Dutra. E., Halifa-Marín, A., Jérez. S., Ramón, J., Montávez, J. P., Doblas-Reyes. F., & Turco, M. (Under Review). Probabilistic predictions for meteorological droughts based on multi initial conditions.Journal of Hydrology.

### Acknowledgments
A.H-M thanks his predoctoral contract FPU18/00824 to the Ministerio de Ciencia, Innovación y Universidades of Spain.

M.T. acknowledges funding bythe Spanish Ministry of Science, Innovation and Universities through the Ramón y Cajal Grant Reference RYC2019-027115-I and through the projectONFIRE, grant
PID2021-123193OB-I00, funded by MCIN/AEI/10.13039/501100011033 and by "ERDF Away ofmaking Europe". 

### References
EC, 2010. Commission staff working paper: Risk assessment and mapping guide-lines for disaster management. EC Rep. SEC (2010) 1626, 43 pp

McKee, T. B., Doesken, N. J., & Kleist, J. (1993, January). The relationship of drought frequency and duration to time scales. In Proceedings of the 8th Conference on Applied Climatology (Vol. 17, No. 22, pp. 179-183).

Svoboda, M., LeComte, D., Hayes, M., Heim, R., Gleason, K., Angel, J., ... & Stephens, S. (2002). The drought monitor. Bulletin of the American Meteorological Society, 83(8), 1181-1190.

Torres-Vázquez, M. Á., Halifa-Marín, A., Montávez, J. P., & Turco, M. (2023). High resolution monitoring and probabilistic prediction of meteorological drought in a Mediterranean environment. Weather and Climate Extremes, 40, 100558.

Turco, M., Jerez, S., Donat, M. G., Toreti, A., Vicente-Serrano, S. M., & Doblas-Reyes, F. J. (2020). A global probabilistic dataset for monitoring meteorological droughts. Bulletin of the American Meteorological Society, 101(10), E1628-E1644.

Turco, M., Marcos-Matamoros, R., Castro, X., Canyameras, E., & Llasat, M. C. (2019). Seasonal prediction of climate-driven fire risk for decision-making and operational applications in a Mediterranean region. Science of the total environment, 676, 577-583.

<br/>

<a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/"><img alt="Licencia de Creative Commons" style="border-width:0" src="https://i.creativecommons.org/l/by-nc/4.0/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" property="dct:title">Probabilistic forecasts for monitoring</span> by <a xmlns:cc="http://creativecommons.org/ns#" href="https://matv.shinyapps.io/app_4DROP/" property="cc:attributionName" rel="cc:attributionURL">4DROP</a> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">Creative Commons Reconocimiento-NoComercial 4.0 Internacional License</a>.

<a href="http://cran.r-project.org/web/packages/shiny" target="_blank_">shiny</a>: Chang, W., Cheng J., Allaire, J.J., Xie, Y. & McPherson, J. (2013). shiny: Web Application Framework for R. R package version 1.7.5

<a href="http://cran.r-project.org/web/packages/shinydashboard" target="_blank_">shinydashboard</a>: Chang, W. (2015). shinydashboard: Create Dashboards with Shiny. R package version 0.7.2


