#' read_excel_data
#'
#' @param file_name name of the Excel file to read
#' @param sheet_name name of the sheet which contains the data
#' @param row_index list of the start rows and end rows for each NRAC programme
#' @param programme name of the NRAC programme to pull data from
#' @param ... 
#'
#' @returns reads in NRAC data published in Excel format
#' @export
#'
#' @examples
read_excel_data <- function(file_name, sheet_name, row_index, programme, ...){
  
  openxlsx::read.xlsx(here("data-pack", file_name), sheet = sheet_name, 
                      rows = row_index[[programme]], ...) %>% 
    mutate(target_year_end = 
             2000 + as.numeric(str_extract(file_name, "(\\d{2})(?=\\D*$)"))) %>% 
    mutate(target_year_start = target_year_end - 1) %>% 
    clean_names()
  
}



#' create_diff_view
#'
#' @param my_conn_path SQL connection
#' @param table_name Name of the view with the shares/indices data
#' @param var_name Name of the share/indices variable
#'
#' @returns creates a view of the absolute difference in shares/indices since the earliest year
#' @export
#'
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

#' @examples
# create_diff_view("app/data/nrac-db.sqlite")
# create_diff_view("app/data/nrac-db.sqlite",
#                  table_name = "indices",
#                  var_name = "nrac_index")
# 
# nracdb <- dbConnect(SQLite(), "app/data/nrac-db.sqlite")
# test <- dbGetQuery(nracdb, "select * from indices_with_differences")
