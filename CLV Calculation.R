
#................................monthly active customer.......................

monthly_cust<-sales%>%
  mutate(order_date=as.Date(order_date))%>%
  mutate(monthy=format(order_date, "%Y-%m"))%>%
  group_by(monthy)%>%
  summarise(month_cus=n_distinct(cust_id))%>%
  arrange(monthy)
View(monthly_cust)

#.....................................................................................
#.................................churn rate................................................
#.....................................................................................

#Count of new customers per month
fminrank <- sales %>%
  mutate(order_date=as.Date(order_date))%>%
  mutate(monthy=format(order_date, "%Y-%m"))%>%
  group_by(cust_id) %>%
  mutate(minrnk = min_rank((order_date)))%>%
  ungroup()%>%
  group_by(monthy)%>%
  filter(minrnk==1)%>%
  summarise(new_cust=n_distinct(cust_id))
View(fminrank)


fminrank$monthy=as.Date(paste0(fminrank$monthy,"-01"))
class(df$monthy)

#merging two data_frame on same column
df = merge(x=monthly_cust,y=fminrank,by="monthy")

df=mutate(df,prev_month_cust=lag(month_cus))
View(df)

#calculation of retention_rate and churn_rate....................
df=mutate(df,retention_rate=(month_cus-new_cust)/prev_month_cust)
df=mutate(df,churn_rate=1-retention_rate)
View(df)

#>>>>>>>>>>>>>>>>>>>>>>>>>> >>><<::Customer Life Time Value::<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#average purchase frequency................#

avg_purchase_frequency<-sales%>%
  mutate(order_date=as.Date(order_date))%>%
  mutate(monthy=format(order_date, "%Y-%m"))%>%
  group_by(monthy,cust_id)%>%
  summarise(n_transaction = n_distinct(order_id))%>%
  ungroup()%>%
  group_by(monthy)%>%
  summarise(avg_purchase_freq = mean(n_transaction))

View(avg_purchase_frequency)

#...............................................................

#purchase value..............#

avg_purchase_value<-sales %>%
  mutate(order_date=as.Date(order_date))%>%
  mutate(monthy=format(order_date, "%Y-%m"))%>%
  mutate(subtotal = qty_ordered * price) %>%
  group_by(monthy)%>%
  summarise(avg_purchase_values = as.integer(mean(subtotal)))
View(avg_purchase_value)


#df is calculated in churn rate portion
profy <- df
View(profy)

#average per month lifespan

profy2<-profy%>%mutate(profy,life_span=(1/churn_rate))
View(profy2)

#we did this in below step to make one column of same type with same syntax to apply join on them 
avg_purchase_frequency$monthy=as.Date(paste0(avg_purchase_frequency$monthy,"-01"))
avg_purchase_value$monthy=as.Date(paste0(avg_purchase_value$monthy,"-01"))

library(plyr)
joined_data<-join_all(list(avg_purchase_frequency,avg_purchase_value,profy2), by = 'monthy', type = 'full')
View(joined_data)

joined_data2<-select(joined_data,monthy,avg_purchase_freq,avg_purchase_values,life_span)
View(joined_data2)

#CLV <- avg_purchase_frequency * avg_purchase_value * cus_lifespan * (0.3)

joined_data2=mutate(joined_data2,Life_Time_Value=avg_purchase_freq*avg_purchase_values*life_span*0.4)
View(joined_data2)


