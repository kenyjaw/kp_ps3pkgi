
# PS3 - No Pay Station Database -------------------------------------------

pacman::p_load(tidyverse)

type_map <- tibble(type_value, type_content)

db_colnames <-
  cols(`Title ID` = col_character(),
       Region = col_character(),
       Name = col_character(),
       `PKG direct link` = col_character(),
       RAP = col_character(),
       `Content ID` = col_character(),
       `Last Modification Date` = col_datetime(format = ""),
       `Download .RAP file` = col_logical(),
       `File Size` = col_double(),
       SHA256 = col_character()
  )

db_game <-
  read_tsv("https://nopaystation.com/tsv/PS3_GAMES.tsv", col_types = db_colnames) %>%
  mutate(type = 1, type_content = "game")

db_dlc <-
read_tsv("https://nopaystation.com/tsv/PS3_DLCS.tsv", col_types = db_colnames) %>%
  mutate(type = 2, type_content = "dlc")

db_full <-
  bind_rows(db_game, db_dlc) %>%
  mutate(description = "") %>%
  mutate(RAP = na_if(RAP, "MISSING"),
         RAP = na_if(RAP, "NOT REQUIRED"),
         Name = str_remove_all(Name, ",")) %>%
  filter(Region %in% c("US", "EU"),
         `PKG direct link` != "MISSING") %>%
  select(contentid = `Content ID`,
         type,
         name = Name,
         description,
         rap = RAP,
         url = `PKG direct link`,
         size = `File Size`,
         checksum = SHA256) %>%
  print()

db_full %>% write_csv("pkgi.txt", col_names = FALSE)

# db_full %>% filter(str_detect(name, "Persona")) %>% write_csv("pkgi.txt", col_names = FALSE)
