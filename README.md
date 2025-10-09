# Bigtable Row Key Schema

Example of using row key schemas on Bigtable for some timeseries fun

## TLDR

By creating a [RowKey Schema](https://cloud.google.com/bigtable/docs/manage-row-key-schemas) it is then possible to query the row key more like a SQL table with many different indexes.

In this example we create a rowkey with the following format

```
customer_id#site_id#sensor_id#timestamp 
customer1#site1#122#1760047153  humidity=56,temperature=78
customer1#site1#124#1760047153  humidity=56,temperature=82
customer1#site1#122#1760048153  humidity=55,temperature=79
customer1#site1#124#1760048153  humidity=55,temperature=81
```


This allows us the equivalent of the following SQL table that we can query

| customer_id | site_id | sensor_id | timestamp | data |
|-----|-----|-----|-----|-----|
| customer1 | site1 | 122 | 1760047153 | humidity=56,temperature=78 |
| customer1 | site1 | 124 | 1760047153 | humidity=56,temperature=82 |
| customer1 | site1 | 122 | 1760048153 | humidity=55,temperature=79 |
| customer1 | site1 | 124 | 1760048153 | humidity=55,temperature=81 |

```sql
select sensor_id, data['humidity'] from mydata
    WHERE customer_id = "customer_1" AND site_id = "site1"
```


## Prerequisites

- [gcloud](https://cloud.google.com/sdk/docs/install)
- [cbt](https://cloud.google.com/bigtable/docs/cbt-overview#installing)
- make

## Setup Gcloud 

```bash
gcloud auth application-default login
```


## Run

```bash
export GCP_PROJECT=MYPROJECT
make btcreate
make btload
```

## Queries

View the data shapes

```sql
SELECT * FROM mydata LIMIT 10;
```

Find all of the sensors
```sql
SELECT DISTINCT(sensor_id)
FROM mydata 
WHERE customer_id="customer7" AND site_id="site3" 
ORDER BY sensor_id DESC;
```

Convert some numbers get the the min/max/avg with [Aggregate Functions](https://cloud.google.com/bigtable/docs/reference/sql/aggregate_functions)

```sql
SELECT 
  AVG(SAFE_CAST(SAFE_CONVERT_BYTES_TO_STRING(data['temperature']) AS INT64) ) AS Average,
  MIN(SAFE_CAST(SAFE_CONVERT_BYTES_TO_STRING(data['temperature']) AS INT64) ) AS Minimum,
  MAX(SAFE_CAST(SAFE_CONVERT_BYTES_TO_STRING(data['temperature']) AS INT64) ) AS Maximum,
  FROM mydata WHERE customer_id="customer7" AND site_id="site3";
```

Show some [time converstion](https://cloud.google.com/bigtable/docs/reference/sql/timestamp_functions#timestamp_from_unix_seconds)

```sql
SELECT
    TIMESTAMP_FROM_UNIX_SECONDS(SAFE_CAST(SAFE_CONVERT_BYTES_TO_STRING(timestamp) AS INT64)) as ts,
    SAFE_CAST(SAFE_CONVERT_BYTES_TO_STRING((data['humidity'])) AS INT64) as humidity,
FROM mydata WHERE customer_id="customer2" AND site_id="site1" 
LIMIT 10
```
 

