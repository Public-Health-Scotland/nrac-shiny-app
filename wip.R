nracdb <- dbConnect(SQLite(), "app/data/nrac-db.sqlite")

diff_query <- "CREATE VIEW shares_with_differences AS
    WITH base_values AS (
    SELECT hb_name, MIN(target_year_start) AS target_year_start, care_programme,
    component, share AS base_share 
    FROM shares 
    GROUP BY hb_name, care_programme, component
    )
    
    SELECT s.hb, s.target_year_start, s.target_year_end, s.care_programme, s.hb_name, 
    s.component, s.share, b.base_share, (b.base_share - s.share) AS diff 
    FROM shares s
    JOIN base_values b ON b.hb_name = s.hb_name 
    AND b.care_programme = s.care_programme
    AND b.component = s.component;"

dbExecute(nracdb, diff_query )

test <- dbGetQuery(nracdb, "select * from shares_with_differences")
test_slice <- test |> 
  filter(care_programme == "all", component == "pop_share") |> 
  mutate(diff = round(diff * 100, 3))

ggplot(test_slice , aes(x = target_year_start, y = diff, color = hb_name)) +
  geom_line()
