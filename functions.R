create_diff_view <- function(my_conn_path, table_name = "shares", var_name = "share"){
  
  my_conn <- dbConnect(SQLite(), my_conn_path)
  
  on.exit(dbDisconnect(my_conn)) # disconnect from db even if query fails
  
  new_table_name <- glue("{table_name}_with_differences")
  
  list_tables <- dbListTables(my_conn)

  if(new_table_name %in% list_tables) {
    
    dbExecute(my_conn, glue("DROP VIEW {new_table_name}"))
    
  }
  
  query <- glue("CREATE VIEW {new_table_name} AS
    WITH base_values AS (
    SELECT hb_name, MIN(target_year_start) AS target_year_start, care_programme,
    component, {var_name} AS base_{var_name}
    FROM {table_name} 
    GROUP BY hb_name, care_programme, component
    )
    
    SELECT s.hb, s.target_year_start, s.target_year_end, s.care_programme, s.hb_name, 
    s.component, s.{var_name}, b.base_{var_name}, (b.base_{var_name} - s.{var_name}) AS diff 
    FROM {table_name} s
    JOIN base_values b ON b.hb_name = s.hb_name 
    AND b.care_programme = s.care_programme
    AND b.component = s.component;"
                
  )

  dbExecute(my_conn, query)
}

# create_diff_view("app/data/nrac-db.sqlite")
# create_diff_view("app/data/nrac-db.sqlite",
#                  table_name = "indices",
#                  var_name = "nrac_index")
# 
# nracdb <- dbConnect(SQLite(), "app/data/nrac-db.sqlite")
# test <- dbGetQuery(nracdb, "select * from indices_with_differences")
