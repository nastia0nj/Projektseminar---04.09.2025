#library(dplyr)
#library(ggplot2)
#library(scales)
#library(patchwork)

# --- PLOT CONVENTIONAL PARTICIPATION ---

poltrig_colors <- c(
  "Voted" = "#1B9E77",          
  "Did not vote" = "#D95F02"    
)

# --- PLOT A: BARPLOT ---

df_vote_clean <- d %>%
  filter(vote %in% c(0, 1), labcon2 %in% c(0, 1), !is.na(anweight)) %>%
  mutate(
    vote_fac = factor(vote, levels = c(1, 0), labels = c("Voted", "Did not vote")),
    labcon2_fac = factor(labcon2, levels = c(0, 1),
                         labels = c("Unlimited Contract", "Temporary Contract"))
  )

df_plot_a <- df_vote_clean %>%
  group_by(labcon2_fac, vote_fac) %>%
  summarise(weight = sum(anweight, na.rm = TRUE), .groups = "drop") %>%
  group_by(labcon2_fac) %>%
  mutate(
    percentage = weight / sum(weight),
    label = paste0(round(percentage * 100, 1), "%")
  ) %>%
  ungroup()

plot_a <- ggplot(df_plot_a, aes(x = labcon2_fac, y = percentage, fill = vote_fac)) +
  geom_col(position = "fill", width = 0.55, color = "white") +
  geom_text(aes(label = label),
            position = position_fill(vjust = 0.5),
            size = 5, color = "white", fontface = "bold") +
  coord_flip() +
  scale_y_continuous(labels = percent_format(accuracy = 1), expand = c(0, 0)) +
  scale_fill_manual(values = poltrig_colors) +
  labs(
    title = "A. Voting Participation by Contract Type",
    x = "Type of Employment Contract",
    y = "Share (%)",
    fill = "Conventional Participation"
  ) +
  theme_minimal(base_size = 15) +
  theme(
    legend.position = "bottom",
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(size = 13),
    axis.text = element_text(size = 12)
  ) +
  theme_minimal(base_size = 15) +
  theme(
    legend.position = "bottom",
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(size = 13),
    axis.text = element_text(size = 12),
    axis.title.y = element_text(margin = margin(r = 15), size = 13),
    axis.title.x = element_text(margin = margin(t = 10), size = 13)
  )


# --- PLOT B: VIOLINPLOT ---

df_violin <- d %>%
  filter(!is.na(lmv), vote %in% c(0, 1), !is.na(anweight)) %>%
  mutate(
    vote_fac = factor(vote, levels = c(1, 0), labels = c("Voted", "Did not vote"))
  )

plot_b <- ggplot(df_violin, aes(x = vote_fac, y = lmv, fill = vote_fac, weight = anweight)) +
  geom_violin(trim = FALSE, scale = "area", color = "white", alpha = 0.9) +
  geom_boxplot(width = 0.1, outlier.shape = NA, color = "white", fill = "white", alpha = 0.5, coef = 0) +
  stat_summary(fun = median, geom = "point", shape = 21, size = 3, fill = "black") +
  scale_fill_manual(values = poltrig_colors) +
  labs(
    title = "B. Voting Participation by Risk of Labor Market Vulnerability",
    x = "Conventional Participation",
    y = "LMV"
  ) +
  theme_minimal(base_size = 15) +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(size = 13),
    axis.text = element_text(size = 12), 
    axis.title.y = element_text(margin = margin(r = 15), size = 13),
    axis.title.x = element_text(margin = margin(t = 10), size = 13)
  ) 

# --- Combine plots
combined_plot <- plot_a + plot_b +
  plot_layout(ncol = 2, widths = c(1.2, 1)) & 
  theme(
    plot.margin = margin(10, 30, 10, 30)  # mehr Abstand außen
  )

combined_plot <- combined_plot +
  plot_annotation(
    caption = paste0(
      "Note: Own calculations based on ESS Waves 6–8 (2014–2018), N = ",
      format(nrow(df_violin), big.mark = " "),
      "All estimates weighted. The violin plot displays the kernel density distribution of the LMV, split by voting status. Wider sections indicate a higher concentration of individuals at that LMV level. The black dot represents the group mean, while the white bar depicts the median, the thick bar the interquartile range."
    ),
    theme = theme(
      plot.caption = element_text(hjust = 0.5, size = 11, margin = margin(t = 16))
    )
  )



# Bar Plot Vote by Lab Contract

poltrig_colors <- c(
  "Voted" = "#1B9E77",         
  "Did not vote" = "#D95F02"    
)

# Daten vorbereiten
df_vote_clean <- d %>%
  filter(vote %in% c(0, 1), labcon2 %in% c(0, 1), !is.na(anweight)) %>%
  mutate(
    vote_fac = factor(vote, levels = c(1, 0), labels = c("Voted", "Did not vote")),
    labcon2_fac = factor(labcon2, levels = c(0, 1),
                         labels = c("Unlimited Contract", "Temporary Contract"))
  )

# Gewichtete Prozentwerte berechnen
df_plot_a <- df_vote_clean %>%
  group_by(labcon2_fac, vote_fac) %>%
  summarise(weight = sum(anweight, na.rm = TRUE), .groups = "drop") %>%
  group_by(labcon2_fac) %>%
  mutate(
    percentage = weight / sum(weight),
    label = paste0(round(percentage * 100, 1), "%")
  ) %>%
  ungroup()

# Plot erstellen
plot_a <- ggplot(df_plot_a, aes(x = labcon2_fac, y = percentage, fill = vote_fac)) +
  geom_col(position = "fill", width = 0.55, color = "white") +
  geom_text(aes(label = label),
            position = position_fill(vjust = 0.5),
            size = 5, color = "white", fontface = "bold") +
  coord_flip() +
  scale_y_continuous(labels = percent_format(accuracy = 1), expand = c(0, 0)) +
  scale_fill_manual(values = poltrig_colors, name = "Conventional Participation") +
  labs(
    title = "A. Voting Participation by Contract Type",
    subtitle = "Weighted distribution by employment contract (ESS 2014–2018)",
    x = "Type of Employment Contract",
    y = "Share of Respondents (%)",
    caption = "Note: Based on ESS Waves 7–9 (2014–2018), weighted by anweight."
  ) +
  theme_minimal(base_size = 15) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(size = 13),
    plot.caption = element_text(size = 10, hjust = 0.5),
    legend.position = "bottom",
    legend.title = element_text(face = "bold"),
    axis.title.x = element_text(margin = margin(t = 10), size = 13),
    axis.title.y = element_text(margin = margin(r = 15), size = 13),
    axis.text = element_text(size = 12)
  )

# Plot anzeigen
print(plot_a)
print(plot_b)

# T-Test für Voting-Raten nach Vertragsart
t_test_contract <- t.test(vote ~ labcon2, data = df2)
print(t_test_contract)

# T-Test für LMV nach Wahlverhalten
t_test_lmv <- t.test(lmv ~ vote, data = df2)
print(t_test_lmv)

