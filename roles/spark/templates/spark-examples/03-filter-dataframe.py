
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, when


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

df.show()



df1 = df.withColumn(
    "life_stage",
    when(col("age") < 13, "child")
    .when(col("age").between(13, 19), "teenager")
    .otherwise("adult"),
)


df1.show()


df.show()

# Filter a Spark DataFrame
# filter the DataFrame so it only includes teenagers and adults
df1.where(col("life_stage").isin(["teenager", "adult"])).show()

