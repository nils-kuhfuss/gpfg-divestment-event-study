# Die Basis dieses Codes wurde zu 100% mit ChatGPT erstellt, einzelne Namen und Betrachtungszeiträume wurden händisch ergänzt.

# 1. Notwendige Pakete installieren und laden
install.packages(c("tseries", "readxl"))
library(tseries)
library(readxl)

# 2. Daten einlesen (CSV/XLSX-Datei laden)
df <- read_excel(file.choose(), sheet = 45)

# Sicherstellen, dass der DataFrame numerisch ist
df <- data.frame(lapply(df, function(x) as.numeric(as.character(x))))

# Definiere Schätzperiode 
SCH_BEGINN <- 249   # Anfang der Schätzperiode
SCH_ENDE <-6    # Ende der Schätzperiode

# 3. Funktion zur Berechnung des Cumulative Abnormal Return (CAR)
CAR_function <- function(data, start_day, end_day) {
  # Sicherstellen, dass start_day und end_day numerisch sind
  if (!is.numeric(start_day) | !is.numeric(end_day)) {
    stop("start_day und end_day müssen numerische Werte sein")
  }
  
  # Sicherstellen, dass die Indizes innerhalb des gültigen Bereichs liegen
  if (start_day < 1 | end_day > nrow(data)) {
    stop("start_day oder end_day liegen außerhalb des gültigen Bereichs")
  }
  
  # CAR berechnen (Spaltensummen der Abnormal Returns über das Zeitfenster)
  return(colSums(data[start_day:end_day, , drop = FALSE], na.rm = TRUE))
}

# 4. Berechnung des CAR für verschiedene Zeitfenster
CAR_values <- list(
  "Pre-Event (-5,-1)" = CAR_function(df, 1, 5),
  "Pre-Event (-2,-1)" = CAR_function(df, 4, 5),
  "Pre-Event (-1,-1)" = CAR_function(df, 5, 5),
  "Event-Tag (0,0)"   = CAR_function(df, 6, 6),
  "Post-Event (1,1)"  = CAR_function(df, 7, 7),
  "Post-Event (2,2)"  = CAR_function(df, 8, 8),
  "Post-Event (3,3)"  = CAR_function(df, 9, 9),
  "Post-Event (4,4)"  = CAR_function(df, 10, 10),
  "Post-Event (5,5)"  = CAR_function(df, 11, 11),
  "Entwicklung (0,5)" = CAR_function(df, 6, 11),
  "Gesamter Zeitraum (-5,5)" = CAR_function(df, 1, 11)
)

# 5. Ergebnistabelle mit Spalten für die Tests und Signifikanzniveaus erstellen
results <- data.frame(
  Zeitraum = names(CAR_values),
  CAR = unlist(lapply(CAR_values, mean, na.rm = TRUE)),  # Mittelwert des CARs
  T_Test = NA,
  T_Test_Signifikanz = "",  # Spalte für Sternchen
  Boehmer = NA,
  Boehmer_Signifikanz = "",
  Patell = NA,
  Patell_Signifikanz = ""
)

# Funktion für den Boehmer-Test
boehmer_test <- function(CAR_data, estimation_data) {
  if (length(CAR_data) < 2 || nrow(estimation_data) < 2) {
    return(c(NA, NA))  # Falls zu wenige Werte vorhanden sind
  }
  
  # Berechnung der Standardabweichung der Residuen aus der Schätzperiode
  S_e <- apply(estimation_data, 2, sd, na.rm = TRUE)
  
  # Standardisierte Residuen berechnen (ARs / Standardabweichung)
  std_resid <- CAR_data / S_e
  
  # Berechnung der Boehmer-Teststatistik
  t_boehmer <- mean(std_resid, na.rm = TRUE) / (sd(std_resid, na.rm = TRUE) / sqrt(length(std_resid)))
  
  # Berechnung des p-Werts (zweiseitiger Test)
  p_value <- 2 * (1 - pt(abs(t_boehmer), df = length(std_resid) - 1))
  
  return(c(t_boehmer, p_value))
}

# Funktion zur Bestimmung der Signifikanzsterne
significance_stars <- function(p_value) {
  if (is.na(p_value)) {
    return("")
  } else if (p_value < 0.01) {
    return("***")  # Hoch signifikant (p < 0.01)
  } else if (p_value < 0.05) {
    return("**")   # Signifikant (p < 0.05)
  } else if (p_value < 0.1) {
    return("*")    # Schwach signifikant (p < 0.1)
  } else {
    return("")     # Nicht signifikant
  }
}

# Iteration über alle Zeiträume und Berechnung der Tests
for (i in seq_along(CAR_values)) {
  CAR_data <- CAR_values[[i]]
  CAR_data <- na.omit(CAR_data)  # Entfernt NA-Werte
  
  # T-Test
  if (length(CAR_data) > 1) {
    t_test <- t.test(CAR_data)
    results$T_Test[i] <- t_test$statistic
    results$T_Test_Signifikanz[i] <- significance_stars(t_test$p.value)
  } else {
    results$T_Test[i] <- NA
    results$T_Test_Signifikanz[i] <- ""
  }
  
  # Boehmer-Test mit der Schätzperiode berechnen
  if (length(CAR_data) > 1) {
    boehmer_result <- boehmer_test(CAR_data, df[SCH_BEGINN:SCH_ENDE, ])
    results$Boehmer[i] <- boehmer_result[1]
    results$Boehmer_Signifikanz[i] <- significance_stars(boehmer_result[2])
  } else {
    results$Boehmer[i] <- NA
    results$Boehmer_Signifikanz[i] <- ""
  }
  
  # Patell-Test
  if (length(CAR_data) > 1) {
    # Standardabweichung der Schätzperiode berechnen
    sigma_hat <- apply(df[SCH_BEGINN:SCH_ENDE, ], 2, sd, na.rm = TRUE)
    # Standardisierte Residuen für den Patell-Test
    patell_test <- CAR_data / sigma_hat
    
    # Berechnung des Patell-Testwerts korrekt durchführen
    t_patell <- mean(patell_test, na.rm = TRUE) / (sd(patell_test, na.rm = TRUE) / sqrt(length(patell_test)))
    
    # Berechnung des p-Werts für den Patell-Test
    p_patell <- 2 * pt(-abs(t_patell), df = length(CAR_data) - 1)
    
    results$Patell[i] <- t_patell
    results$Patell_Signifikanz[i] <- significance_stars(p_patell)  
  }
}

# 6. Ergebnisse anzeigen
print(results)
