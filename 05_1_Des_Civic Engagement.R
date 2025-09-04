#library(ggplot2)
#library(dplyr)
#library(patchwork)
#library(ggridges)
#library(forcats)  

# --- PLOT UNCONVENTIONAL PARTICIPATION ---

# Farben definieren (Poltrig-Stil)
poltrig_colors <- c(
  "Permenant Contract" = "#1B9E77",   # Petrolgrün
  "Temporary Contract" = "#D95F02"    # Orange
)

poltrig_colors <- c("Permenant Contract" = "#66C2A5",     
                    "Temporary Contract" = "#8DA0CB") 


# --- Plot A: Violinplot politics ~ labcon2 ---
df_violin_politics <- df2 %>%
  filter(!is.na(politics), labcon2 %in% c(0, 1), !is.na(anweight)) %>%
  mutate(
    labcon2_fac = factor(labcon2, levels = c(0, 1),
                         labels = c("Permenant Contract", "Temporary Contract"))
  )

plot_a <- ggplot(df_violin_politics, aes(x = labcon2_fac, y = politics, fill = labcon2_fac, weight = anweight)) +
  geom_violin(trim = FALSE, scale = "area", color = "white", alpha = 0.9) +
  geom_boxplot(width = 0.1, outlier.shape = NA, color = "grey50", fill = "white", alpha = 0.5, coef = 0, show.legend = FALSE) +
  stat_summary(aes(shape = "Mean"), fun = mean, geom = "point", size = 3, stroke = 1.2,
               color = "grey50", fill = "grey50", show.legend = TRUE) +
  scale_shape_manual(name = "Statistic", values = c(Mean = 21)) +
  scale_fill_manual(values = poltrig_colors, , guide = "none") +
  labs(
    title = "A. Unconventional Participation by Contract Type",
    subtitle = "Distribution of Civic Engagement",
    x = "Employment Contract",
    y = "Civic Engagement"
  ) +
  theme_minimal(base_size = 15) +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold", size = 16),
    axis.text = element_text(size = 12), 
    axis.title.y = element_text(margin = margin(r = 15), size = 13),
    axis.title.x = element_text(margin = margin(t = 10), size = 13)
  )

# Nachbesserungen
plot_a <- plot_a +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "bottom",
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 11),
    plot.title = element_text(size = 19, hjust = 0, margin = margin(b = 10)),
    plot.subtitle = element_text(size = 16, color = "gray40", hjust = 0, margin = margin(b = 20)),
    axis.title.x = element_text(size = 16, margin = margin(t = 15)),
    axis.title.y = element_text(size = 16, margin = margin(r = 10)),
    axis.text = element_text(size = 14, color = "gray30"),
    plot.margin = margin(t = 20, r = 20, b = 20, l = 20)
  ) +
  labs(fill = "Contract Type")  


# --- Plot B: Ridge Plot politics ~ binned lmv ---
df_ridge <- df2 %>%
  filter(!is.na(politics), !is.na(lmv), !is.na(anweight)) %>%
  mutate(
    lmv = as.numeric(lmv),  # falls Stata-importiert
    lmv_band = cut(
      lmv,
      breaks = seq(-2.01, 2.01, length.out = 6),  # erzeugt 5 Intervalle
      include.lowest = TRUE,
      labels = c("Very Low Risk -3", "Low -1.5", "Moderate 0", "High 1.5", "Very High Risk 3")
    )
  ) %>%
  filter(!is.na(lmv_band))  # Sicherheitshalber


# LABOR MAKET RISK
plot_b <- ggplot(df_ridge, aes(x = politics, y = fct_rev(lmv_band), fill = ..x..)) +
  geom_density_ridges_gradient(scale = 2.5, rel_min_height = 0.01) +
  labs(
    title = "B. Unonventional Participation by Risk of Outsiderness",
    subtitle = "Distribution of Civic Engagement across Labor Market Risk",
    x = "Civic Engagement",
    y = "Labor Market Risk Level"
  ) +
  theme_minimal(base_size = 15) +
  theme(
    plot.title = element_text(face = "bold", size = 16, margin = margin(b = 15)),
    axis.text = element_text(size = 12),
    axis.title.y = element_text(margin = margin(r = 15), size = 13),
    axis.title.x = element_text(margin = margin(t = 10), size = 13),
    legend.position = "none"
  ) 

plot_b <- plot_b +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "bottom",
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 11),
    plot.title = element_text(size = 19, hjust = 0, margin = margin(b = 10)),
    plot.subtitle = element_text(size = 16, color = "gray40", hjust = 0, margin = margin(b = 20)),
    axis.title.x = element_text(size = 16, margin = margin(t = 15)),
    axis.title.y = element_text(size = 16, margin = margin(r = 10)),
    axis.text = element_text(size = 14, color = "gray30"),
    plot.margin = margin(t = 20, r = 20, b = 20, l = 20)
  ) +
  scale_fill_gradient(
    low = "#8DA0CB" , high = "#c6dbd5",
    name = "Political Engagement"
  )


# --- Combine Plots
combined_plot <- plot_a + plot_b +
  plot_layout(ncol = 2, widths = c(1.2, 1)) & 
  theme(
    plot.margin = margin(10, 20, 10, 20)
  )

# --- Add annotation
#combined_plot <- combined_plot +
  #plot_annotation(
    #caption = paste0(
      #"Note: Own calculations based on ESS Waves 7–9 (2014–2018). N = ",
      #format(nrow(df_ridge), big.mark = ""),
      #". All estimates weighted. Violin plot shows the kernel distribution of civic political engagement by contract type.\n",
      #"Ridge plot shows the distribution of engagement scores across LMR groups (0.5-width bands)."
   # ),
   # theme = theme(
    #  plot.caption = element_text(hjust = 0.5, size = 11, margin = margin(t = 16))
   # )
  #)

# --- Anzeigen
combined_plot


# T-Test für UnPP-Raten nach Vertragsart
t_test_contract <- t.test(politics ~ labcon2, data = df2)
print(t_test_contract)

# T-Test für LMV nach UnPP
t_test_lmv <- t.test(politics ~ vote, data = df2)
print(t_test_lmv)


# --- Sample Size nochaml anziechen

N_lmv <- df2 %>%
  filter(!is.na(lmv), !is.na(politics), !is.na(anweight)) %>%
  summarise(
    N_weighted = sum(anweight, na.rm = TRUE),
    N_unweighted = n()
  )

print(N_lmv)

N_labcon <- df_violin_politics %>%
  summarise(
    N_weighted = sum(anweight, na.rm = TRUE),
    N_unweighted = n()
  )

print(N_labcon)










