
from pyspark.sql import SparkSession
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

from pyspark.sql.functions import col, when

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


# Group by aggregation on Spark DataFrame
# Compute the average age for everyone in the dataset
df1.select(avg("age")).show()
df1.groupBy("life_stage").avg().show()

