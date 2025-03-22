
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


# Query the DataFrame with SQL
# Compute the average age for everyone with SQL:
spark.sql("select avg(age) from {df1}", df1=df1).show()

# Compute the average age by life_stage with SQL
spark.sql("select life_stage, avg(age) from {df1} group by life_stage", df1=df1).show()

