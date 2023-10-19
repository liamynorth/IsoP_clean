#Title:CIAPM ACES ISOPROSTANE DATA IMPORT WRANGLING SCRIPT
#File Name: CIAPM ACES ISOPROSTANE DATA IMPORT WRANGLING SCRIPT 2023-10-13
#Authors: Liam North

#LOAD NECESSARY PACKAGES########################################################
pacman::p_load(pacman, tidyverse, readxl, car, stringr)

#DATA IMPORT####################################################################
#Import raw plasma isop csv named "2023-09-15 - Levitt plasma - FINAL"
df1 <- data.frame(read.csv(file.choose(), skip = 3))
head(df1)
tail(df1)
df1

#Import raw urine isop csv Box3 named "2023-09-15 - LEVITT CIAPM ACES URINE IsoP - FINAL Box3"
df2 <- data.frame(read.csv(file.choose(), skip = 2))
head(df2)
tail(df2)

#Import raw urine isop csv Box4 named "2023-09-15 - LEVITT CIAPM ACES URINE IsoP - FINAL Box4"
df3 <- data.frame(read.csv(file.choose(), skip = 2))
head(df3)
tail(df3)

#Import raw urine isop csv Box5 named "2023-09-15 - LEVITT CIAPM ACES URINE IsoP - FINAL Box5"
df4 <- data.frame(read.csv(file.choose(), skip = 2))
head(df4)
tail(df4)

#WRANGLE PLASMA CSV#############################################################
#Get rid of extraneous first row
df1 <- df1[-1,]
df1

#Get rid of empty rows
df1 <- df1[-(70:71),]
df1

#Get rid of empty column
df1 <-df1[,-7]
df1

#rename columns
df1 <- df1 %>%
  rename(
    subjectid = X,
    timepoint = X.1,
    bound.15F2tIsoP = X15.F2t.IsoP,
    bound.5epi5F2tIsoP = X5.epi.5.F2t.IsoP,
    bound.5epi5F2cIsoP = X5.epi.5.F2c.IsoP,
    bound.unknown5seriesF2IsoP = unknown.5.series.F2.IsoP,
    free.15F2tIsoP = X15.F2t.IsoP.1,
    free.5epi5F2tIsoP = X5.epi.5.F2t.IsoP.1,
    free.5epi5F2cIsoP = X5.epi.5.F2c.IsoP.1,
    free.unknown5seriesF2IsoP = unknown.5.series.F2.IsoP.1
  )

#Fix joint jpb2/aces participants to correct format for REDCap import
df1$subjectid[df1$subjectid == "AJ001"] <- "A004 / AJ001 / J104"
df1$subjectid[df1$subjectid == "AJ002"] <- "A005 / AJ002 / J107"
df1$subjectid[df1$subjectid == "AJ003"] <- "A011 / AJ003 / J108"
df1$subjectid[df1$subjectid == "A017"] <- "A017 / AJ004 / J109"
df1$subjectid[df1$subjectid == "A028"] <- "A028 / AJ005 / J110"
df1$subjectid[df1$subjectid == "A033"] <- "A033 / AJ006 / J111"
df1$subjectid[df1$subjectid == "A004"] <- "A004 / AJ001 / J104"
df1$subjectid[df1$subjectid == "A011"] <- "A011 / AJ003 / J108"
df1

#Omit string from timepoint field for correct format for REDCap import
df1$timepoint <- gsub("[A-Z]", "", df1$timepoint)
df1$timepoint <- str_trim(df1$timepoint, "right")
df1$timepoint
df1$timepoint <- as.integer(df1$timepoint)
class(df1$timepoint)

#final check
df1

#EXPORT PLASMA CSV##############################################################
write.csv(df1, "\\Users\\LevittLab\\Downloads\\CIAPMACES_PlasmaIsoPsImport_FINAL_20231013.csv", na = "", row.names=FALSE)

#WRANGLE + JOIN URINE CSVs######################################################
#Get rid of extraneous ending rows
df2 <- df2[-(22:24),]
df2

df3 <- df3[-(81:82),]
df3

df4 <- df4[-(55:56),]
df4

#rename columns
#note: I had to flip Isop variable names in the following manner: 15f2tIsop to Isop15f2t because R doesn't like variables that begin with integers
df2 <- df2 %>%
  rename(
    subjectid = Sample.ID,
    timepoint = Timepoint,
    sample.type = Sample.Type,
    Eppvolume = Eppendorf.volume..mL.,
    Creatine = mg.mL,
    IsoP15F2t = ng.mg.Cr,
    IsoP5epi5F2t = ng.mg.Cr.1,
    IsoP5epi5F2c = ng.mg.Cr.2,
    IsoPunknown5seriesF2 = ng.mg.Cr.3
  )

df3 <- df3 %>%
  rename(
    subjectid = Sample.ID,
    timepoint = Timepoint,
    sample.type = Sample.Type,
    Eppvolume = Eppendorf.volume..mL.,
    Creatine = mg.mL,
    IsoP15F2t = ng.mg.Cr,
    IsoP5epi5F2t = ng.mg.Cr.1,
    IsoP5epi5F2c = ng.mg.Cr.2,
    IsoPunknown5seriesF2 = ng.mg.Cr.3
  )

df4 <- df4 %>%
  rename(
    subjectid = Sample.ID,
    timepoint = Timepoint,
    sample.type = Sample.Type,
    Eppvolume = Eppendorf.volume..mL.,
    Creatine = mg.mL,
    IsoP15F2t = ng.mg.Cr,
    IsoP5epi5F2t = ng.mg.Cr.1,
    IsoP5epi5F2c = ng.mg.Cr.2,
    IsoPunknown5seriesF2 = ng.mg.Cr.3
  )

#Append the 3 urine dataframes
df5 <- rbind(df2,df3,df4)
df5

#Fix joint jpb2/aces participants to correct format for REDCap import
df5$subjectid[df5$subjectid == "AJ001"] <- "A004 / AJ001 / J104"
df5$subjectid[df5$subjectid == "AJ002"] <- "A005 / AJ002 / J107"
df5$subjectid[df5$subjectid == "AJ003"] <- "A011 / AJ003 / J108"
df5$subjectid[df5$subjectid == "AJ004"] <- "A017 / AJ004 / J109"
df5$subjectid[df5$subjectid == "A028"] <- "A028 / AJ005 / J110"
df5$subjectid[df5$subjectid == "A033"] <- "A033 / AJ006 / J111"
df5$subjectid[df5$subjectid == "A004"] <- "A004 / AJ001 / J104"
df5$subjectid[df5$subjectid == "A005"] <- "A005 / AJ002 / J107"
df5$subjectid[df5$subjectid == "A011"] <- "A011 / AJ003 / J108"
df5$subjectid[df5$subjectid == "A017"] <- "A017 / AJ004 / J109"
df5

#Omit string from timepoint field for correct format for REDCap import
df5$timepoint <- gsub("[a-z]", "", df5$timepoint)
df5$timepoint <- str_trim(df5$timepoint, "right")
df5$timepoint
df5$timepoint <- as.integer(df5$timepoint)
class(df5$timepoint)

#final check
df5

#EXPORT URINE CSV###############################################################
write.csv(df5, "\\Users\\LevittLab\\Downloads\\CIAPMACES_UrineIsoPsImport_20231013.csv", na = "", row.names=FALSE)

