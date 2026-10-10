# Divestment Announcements and Stock Returns

An event study of exclusions by Norway's Government Pension Fund Global (GPFG), completed as a graduate coursework research project at Friedrich-Alexander-Universität Erlangen-Nürnberg (FAU).

Author: Nils Kuhfuß

Programme: M.Sc. Industrial Engineering and Management

Chair: Finance and Banking

Supervision: Prof. Dr. Hendrik Scholz and Anja Stiller

Submitted: 31 March 2025

Project duration: Three months

Paper language: German; this README provides an English research summary.

Research question

How do stock prices respond around public announcements that companies have been excluded from the GPFG's investment universe on ethical grounds?
The paper examines whether abnormal returns occur before, on or after the announcement date, and whether the patterns differ across geographic markets and two types of exclusion:
- Product-based exclusions: decisions related to a company's products or business activities.
- Conduct-based exclusions: decisions related to corporate behaviour, such as serious environmental damage, corruption or human-rights violations.
The study considers whether observed return patterns are consistent with temporary selling pressure or the arrival of new information. Announcement dates are the events under investigation; the fund's actual transaction dates are not observed.

Data and sample
The starting sample consists of 59 company exclusions between 2019 and 2023. Seven Israeli companies are removed because they could not be assigned to the regional factor datasets used in the study, leaving 52 firms in the main analysis.

Component	Source and treatment
Exclusion announcements	Norges Bank Investment Management: company names, dates, headquarters and exclusion reasons
Daily equity prices:	LSEG Workspace
Risk factors:	Kenneth French Data Library
Currency alignment:	Equity prices converted to US dollars to match the factor data


The main sample spans North America, Europe, Asia Pacific excluding Japan, Japan and emerging markets. The three- and five-factor robustness analyses exclude emerging-market firms because suitable daily factor data were unavailable in the data sources used for this project.

Methodology

1. Construct the event dataset: match exclusion announcements to company price histories and classify firms by region and exclusion type.
2. Estimate normal returns: fit a one-factor excess-return model over a pre-event estimation period.
3. Measure abnormal performance: calculate abnormal returns (AR), average abnormal returns (AAR) and cumulative abnormal returns (CAR) around the announcement date.
4. Examine event windows: analyse an eleven-trading-day window, [-5, +5], with separate pre-announcement, announcement-day and post-announcement intervals.
5. Compare specifications: use Fama–French three- and five-factor models as robustness checks on the eligible sample, and compare regional and exclusion-type subsamples.
The submitted paper reports t-tests, Patell tests and Boehmer tests. The analysis was conducted using R / RStudio and Microsoft Excel.

Main findings reported in the paper

- Negative announcement-day returns: the baseline one-factor analysis reports an average abnormal return of −1.19% on the event day for the 52-firm sample, with statistical significance under the reported tests (Table 4, p. 18).
- Limited evidence over the wider window: average CAR is −0.91% over [-5, +5] and −0.12% over [0, +5]; neither is statistically significant under the reported tests.
- Different timing by exclusion type: product-based exclusions exhibit negative pre-announcement returns, whereas the negative response for conduct-based exclusions is concentrated on the announcement day. These patterns suggest possible differences in anticipation and information content, but do not identify the underlying mechanism.
- Sensitivity to model choice: the positive post-announcement result in the developed-market one-factor sample weakens when additional Fama–French factors are included. Regional comparisons are exploratory because several subsamples are small.
These findings concern short-term price responses around announcements. They do not establish a permanent effect on company value, a causal effect of the fund's sales or an exploitable trading strategy.

Limitations and replication status

The small sample limits statistical power, particularly in regional comparisons. Announcement times within the trading day are unknown, so an observed response may fall on the following trading day. Actual GPFG sales are not observed, and coinciding company or market news may also influence returns.
The paper identifies incomplete inferential checks and an unresolved similarity between the reported Patell and Boehmer statistics. The reported results have not yet been revalidated through a documented repository replication workflow; the statistical-test implementation should be reviewed as part of that process.
Repository contents and data availability
Publication status: The coursework paper is complete; the PDF and supporting analysis files are being prepared for upload.

Intended location	Contents

paper/gpfg_event_study.pdf	Full coursework paper in German
code/	R analysis scripts and any accompanying source files
README.md	English research summary


Commercial LSEG source data are not distributed here. Reproducing the analysis requires appropriate data access and the input-file preparation documented for the project. Package versions, execution order and any required Excel steps will be added when the analysis files have been organised for publication.

Citation: Kuhfuß, N. (2025). Divestment und Unternehmenswerte: Eine exemplarische Eventstudie anhand des norwegischen Staatsfonds. Graduate coursework paper, Friedrich-Alexander-Universität Erlangen-Nürnberg, Chair of Finance and Banking.
