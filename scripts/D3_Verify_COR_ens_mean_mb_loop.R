
rm(list = ls())
graphics.off()
gc()

library(ncdf4)
library(sp)
library(maptools) # loads sp library too
library(RColorBrewer) # creates nice color schemes
library(classInt) # finds class intervals for continuous variables
library(fields)
library(s2dverification)
library(maps)
library(pracma)
library(verification)
library(psych)

source("~/Dropbox/4DROP/script/Common/CorrMIO.R")
source("~/Dropbox/4DROP/script/Common/ColorBarM.R")
source("~/Dropbox/4DROP/script/Common/mioplot_global.R")

dir_drop = '~/Dropbox/4DROP/DROP/'
dir_4drop = '~/Dropbox/4DROP/Data/'
dir_spi= '~/Dropbox/4DROP/Data/spi/'
dir_out2= '~/Dropbox/4DROP/Correlaciones/231006_correlation/corre1/'


anni = 1981:2020
mesi = rep(1:12, length(anni))

#SON 36 ANNI
anniok = 36 # 33/37 ?? circa il 90%

load(file.path(dir_drop, "lon_GPCP_1981_2017.RData"))
load(file.path(dir_drop, "lat_GPCP_1981_2017.RData"))
lonGPCP = lon
latGPCP = lat

#mesi= 1:40
datasets = c(
  'MSWEP', 'ERA5', 'CHIRPS', 'NCEP','MERRA2', 'CPC',
  'PRECL', 'CAMS_OPI', 'GPCC',   'GPCP','JRA55',
  'ENS' )

time_scale = c(6)
start_dates = c(01, 02, 04, 05, 07, 08, 10, 11)
pd= c("S5")

for (isc in 1:length(time_scale)) {
  sc = time_scale[isc]
  
  for (idata in 1:length(datasets)) {
    dataset = datasets[idata]
    
    for (istart_date in 1:length(start_dates)) {
      start_date = start_dates[istart_date]
      
      # dates = seq(start_date, start_date + 3)
      if (start_date == 5) {
        target_season = 'JJA'
      } else if (start_date == 7) {
        target_season = 'JJA'
      } else if (start_date == 8) {
        target_season = 'SON'
      } else if (start_date == 10) {
        target_season = 'SON'
      } else if (start_date == 2) {
        target_season = 'MAM'
      } else if (start_date == 4) {
        target_season = 'MAM'
      } else if (start_date == 1) {
        target_season = 'DJF'
      } else if (start_date == 11) {
        target_season = 'DJF'
      }
      
      
      if (target_season == 'MAM') {
        mesi_8 = which(mesi== 05)
      } else if (target_season == 'JJA') {
        mesi_8 = which(mesi == 08)
      } else if (target_season == 'SON') {
        mesi_8 = which(mesi == 11)
      } else if (target_season == 'DJF') {
        mesi_8 = which(mesi == 02)
      }
      
      
      # Leemos  LOS ONCE MIEMBROS DE DROP
      nam <- paste("spi", sep = "")
      print(nam)
      
      if (dataset != "ENS") {
        load(file.path(dir_drop,paste("SPI", sc, "_",dataset,"_1981_2020.RData", sep = "")))
        data = spi6[,,mesi_8]
      } else if (dataset == "ENS") {
        load(file.path(dir_drop,paste("SPI", sc, "_",dataset,"_1981_2020.RData", sep = "")))
        data = spi[,,mesi_8]
      }
      # Leemos las predicciones de 4Drop
      nam <- paste("spi",sc,"pred", sep = "")
      print(nam)
      load(file.path(dir_spi, paste("S5_SPI", sc,"_",sprintf("%02d", start_date),  "_",  target_season, "_ENS.RData", sep = "" )))
      ens = spi6pred
      
      
      
      data[is.infinite(data)]=NA
      
      ni = dim(data)[1]
      nj = dim(data)[2]
      nt = dim(data)[3]
      
      corre <- matrix(data = NA,nrow = ni, ncol = nj)
      pvalue <- matrix(data = NA, nrow = ni, ncol = nj)
      
      corre_det <- matrix(data = NA,nrow = ni, ncol = nj)
      pvalue_det <- matrix(data = NA, nrow = ni, ncol = nj)
      
      
      for (i in 1:ni) {
        for (j in 1:nj) {
          
          OK <- complete.cases(ens[i, j,], data[i, j,])
          x <- ens[i, j, OK]
          y <- data[i, j, OK]
          n <- length(x)
          #if (n >= anniok * 12) {
          #if (n >= nt*0.9) {
            
            dum = CorrMIO((x), (y), method = 'pearson', pval = TRUE)
            corre[i, j] = as.numeric(dum)[1]
            pvalue[i, j] <- as.numeric(dum)[4]
            rm(dum)
            
          #}
          
          
          OK1 <- complete.cases(ens[i, j,], data[i, j,])
          x1 <- ens[i, j, OK1]
          y1 <- data[i, j, OK1]
          n1 <- length(x1)
          #if (n >= anniok * 12) {
          #if (n1 >= nt*0.9) {
            
            x1d = as.vector(detrend(x1, tt = 'linear', bp = c()))
            y1d = as.vector(detrend(y1, tt = 'linear', bp = c()))
            
            dum = CorrMIO((x1d), (y1d), method = 'pearson', pval = TRUE)
            corre_det[i, j] = as.numeric(dum)[1]
            pvalue_det[i, j] <- as.numeric(dum)[4]
            rm(dum)
          #}
          
          rm(OK, n, x, y, x1d, y1d, x1, y1, n1)
        }
      }
      pvalue_adj = p.adjust(pvalue, method = "fdr", n = length(pvalue[!is.na(pvalue)]))
      pvalue_adj = matrix(pvalue_adj, nrow = ni, ncol = nj)
      # 
      lat2 = lat[which(lat > -60 & lat < 85)]
      corre2 = corre[, which(lat > -60 & lat < 85)]
      pvalue2 = pvalue[, which(lat > -60 & lat < 85)]
      pvalue_adj2 = pvalue_adj[, which(lat > -60 & lat < 85)]
      
    
      save(corre2, file = file.path(dir_out2, paste("COR_",pd,"_spi",sc,"_",sprintf("%02d", start_date),"_",target_season,"_",dataset,"_original.RData", sep = "") ))
      save(pvalue_adj2, file = file.path(dir_out2, paste("pvalue_",pd,"_spi",sc,"_",sprintf("%02d", start_date),"_",target_season,"_",dataset,"_original.RData", sep = "") ))
    }
  }
}


