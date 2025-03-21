
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, when
from pyspark.sql.functions import avg

spark = SparkSession.builder.appName("demo").getOrCreate()

df = spark.createDataFrame(
    [
        ("sue", 32),
        ("li", 3),
        ("bob", 75),
        ("heo", 13),
    ],
    ["first_name", "age"],
)


# df.show()


df1 = df.withColumn(
    "life_stage",
    when(col("age") < 13, "child")
    .when(col("age").between(13, 19), "teenager")
    .otherwise("adult"),
)


# df1.show()
# df.show()
# df1.where(col("life_stage").isin(["teenager", "adult"])).show()
# df1.select(avg("age")).show()
# df1.groupBy("life_stage").avg().show()
# spark.sql("select avg(age) from {df1}", df1=df1).show()
# spark.sql("select life_stage, avg(age) from {df1} group by life_stage", df1=df1).show()


# Spark SQL Example
# Persist the DataFrame in a named Parquet table that is easily accessible via the SQL API
df1.write.saveAsTable("some_people")

# Make sure that the table is accessible via the table name
spark.sql("select * from some_people").show()

# Use SQL to insert a few more rows of data into the table
spark.sql("INSERT INTO some_people VALUES ('frank', 4, 'child')")

# Inspect the table contents to confirm the row was inserted
spark.sql("select * from some_people").show()

# Run a query that returns the teenagers
spark.sql("select * from some_people where life_stage='teenager'").show()


# Spark makes it easy to register tables and query them with pure SQL.

