#Path
setwd("~/Documents/data_science_for_social_impact/dssi_final_project/20160213_data")
library(tidyverse)

#Import data with renamed variables
col_names <- c('host_response', 
               'response_date',
               'number_of_messages',
               'automated_coding',
               'latitude',
               'longitude',
               'bed_type',
               'property_type',
               'cancellation_policy',
               'number_guests', 
               'bedrooms',
               'bathrooms',
               'cleaning_fee',
               'price',
               'apt_rating',
               'property_setup',
               'city',
               'date_sent',
               'listing_down',
               'number_of_listings',
               'number_of_reviews',
               'member_since',
               'verified_id',
               'host_race',
               'super_host',
               'host_gender',
               'host_age',
               'host_gender_1',
               'host_gender_2',
               'host_gender_3',
               'host_race_1',
               'host_race_2',
               'host_race_3',
               'guest_first_name',
               'guest_last_name',
               'guest_race',
               'guest_gender',
               'guest_id',
               'population',
               'whites',
               'blacks',
               'asians',
               'hispanics',
               'available_september',
               'up_not_available_september',
               'september_price',
               'census_tract',
               'host_id',
               'new_number_of_listings')
# Also, change all variables to a character format (col_types argument). 
# This makes it easier to clean everything up.
main_data <- read_csv('main_data.csv', col_names = col_names, col_types = cols(.default = "c"))

# Now change \N, Null, and -1 to "." We want missing values to be consistently coded.
main_data <- main_data %>% 
  mutate_at(vars(response_date:september_price), #select variables
            function(x) recode(x, `\\N` = ".", #recode them
                               `Null` = ".",
                               `-1` = "."))

# Now destring as many variables as makes sense
main_data %>% mutate_at(vars(c(host_response, 
                               number_of_messages, 
                               automated_coding, 
                               latitude,
                               longitude, 
                               number_guests,
                               bedrooms,
                               bathrooms,
                               cleaning_fee,
                               price,
                               apt_rating,
                               listing_down, 
                               number_of_listings,
                               number_of_reviews,
                               verified_id,
                               super_host,
                               guest_id,
                               population,
                               whites,
                               blacks,
                               hispanics,
                               asians,
                               available_september, 
                               up_not_available_september,
                               september_price,
                               host_id,
                               new_number_of_listings)),
                        as.numeric)
                        


library(lubridate)
main_data <- main_data %>% mutate(
  # Change dates to lubridate format
  response_date_R = ymd_hms(response_date),
  date_sent_R = ymd_hms(date_sent),
  
  # Make binary variables for the guests' race and gender
  guest_black = guest_race == "black",
  guest_white = guest_black == 0,
  guest_female = guest_gender == "female",
  guest_male = guest_gender == "male",
  
  #Make a guest_name * city variable for clustered standard errors
  name_by_city = interaction(guest_first_name, city)
)
