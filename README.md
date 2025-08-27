# Bigtable Row Key Schema

Example of using row key schemas on Bigtable for some timeseries fun

## Prerequisites

[gcloud](https://cloud.google.com/sdk/docs/install)
[cbt](https://cloud.google.com/bigtable/docs/cbt-overview#installing)
make

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
SELECT DISTINCT(sensor_id) FROM mydata WHERE customer_id="customer7" AND site_id="site3" ORDER BY sensor_id DESC;
```

Convert some numbers get the the min/max/avg with [Aggregate Functions](https://cloud.google.com/bigtable/docs/reference/sql/aggregate_functions)

```sql
SELECT 
  AVG(SAFE_CAST(SAFE_CONVERT_BYTES_TO_STRING(data['temperature']) AS INT64) ) AS Average,
  MIN(SAFE_CAST(SAFE_CONVERT_BYTES_TO_STRING(data['temperature']) AS INT64) ) AS Minimum,
  MAX(SAFE_CAST(SAFE_CONVERT_BYTES_TO_STRING(data['temperature']) AS INT64) ) AS Maximum,
  FROM mydata WHERE customer_id="customer7" AND site_id="site3";
```

Show some time converstion

```sql
SELECT
    TIMESTAMP_FROM_UNIX_SECONDS(SAFE_CAST(SAFE_CONVERT_BYTES_TO_STRING(timestamp) AS INT64)) as ts,
    SAFE_CAST(SAFE_CONVERT_BYTES_TO_STRING((data['humidity'])) AS INT64) as humidity,
FROM mydata WHERE customer_id="customer2" AND site_id="site1" 
LIMIT 10
```
 

