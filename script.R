library(RColorBrewer)
library(rworldmap)

df_probes <- read.csv("probes.csv")
df_results <- read.csv("RESULTS-1300.csv")

df_probes1 <- df_probes[which(df_probes$probe_status==1),] 

df <- merge(x=df_results,y=df_probes1,all.x=TRUE,all.y=FALSE,by="probe_id")

df_cc <- split(df, df$probe_cc)

t_bad_perc <- sapply(df_cc, function (x) { sum(x$ok==0)/nrow(x)*100} )
t_ok0 <- sapply(df_cc, function (x) { sum(x$ok==0)} )
t_all <- sapply(df_cc, function (x) { nrow(x)} )

df_stat <- data.frame(cc=names(t_all),all=t_all,hijacked=t_ok0,perc=t_bad_perc)
df_stat[which(df_stat$all==0),]$hijacked <- NA

sPDF <- joinCountryData2Map(df_stat,nameJoinColumn="cc", joinCode = "ISO2", verbose=FALSE)

colourPalette <- c(
"#409040",
"#fee8c8",
"#fdd49e",
"#fdbb84",
"#fc8d59",
"#ef6548",
"#d7301f",
"#b30000",
"#7f0000")

png(width = 1400, height = 800,filename="hijacked.png")
mapParams <- mapCountryData(
  sPDF,
  addLegend=FALSE,
  nameColumnToPlot="hijacked",
  mapTitle="Hijack",
  colourPalette=colourPalette,
  catMethod=c(0,0.0000001,1,2,5,10,20,30,40),
  missingCountryCol = gray(.8)
)

mapParams$legendText <- c('no hijack','1','2','5','10','20','30','40','no data')    
do.call( addMapLegendBoxes, c(mapParams,
                              title='number of probes',
                              bg=NA,
                              col=NA,
                              x='left'
)
)
dev.off()


png(width = 1400, height = 800,filename="perc.png")
mapParams <- mapCountryData(
  sPDF,
  addLegend=FALSE,
  nameColumnToPlot="perc",
  mapTitle="Hijack",
  colourPalette=colourPalette,
  catMethod=c(0,0.0000001,1,2,5,10,20,30,40,100),
  missingCountryCol = gray(.8)
)

mapParams$legendText <- c('no hijack','<1%','1%','2%','5%','10%','20%','30%','40%','no data')    
do.call( addMapLegendBoxes, c(mapParams,
                              title='% of probes',
                              bg=NA,
                              col=NA,
                              x='left'
)
)

dev.off()

write.csv(df_stat,file ="df_stat.csv",row.names = FALSE)

df_stat$perc_str <- sprintf("%.1f %%", df_stat$perc)
names(df_stat) <- c("cc","total_probes","hijacked","perc_hijacked_num","perc_hijacked")
row.names(df_stat) <- NULL


library('knitr')
n<-20

kable(
  cbind(data.frame(no=c(1:n),
    subset(
      head(
        df_stat[order(df_stat$hijacked,decreasing=TRUE),],
          n=n
      ), select=c("cc","total_probes","hijacked","perc_hijacked")
    )
  )),
  format = "markdown",
  row.names = FALSE
)


kable(
  cbind(data.frame(no=c(1:n),
                   subset(
                     head(
                       df_stat[order(df_stat$perc_hijacked_num,decreasing=TRUE),],
                       n=n
                     ), select=c("cc","total_probes","hijacked","perc_hijacked")
                   )
  )),
  format = "markdown",
  row.names = FALSE
)

