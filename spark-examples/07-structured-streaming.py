
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

# {"student_name":"someXXperson", "graduation_year":"2023", "major":"math"}
# {"student_name":"liXXyao", "graduation_year":"2025", "major":"physics"}



# Spark Structured Streaming Example
# Spark also has Structured Streaming APIs that allow you to create batch or real-time streaming applications
# Let’s see how to use Spark Structured Streaming to read data from Kafka and write it to a Parquet table hourly
# Suppose you have a Kafka stream that’s continuously populated with the following data
#
# {"student_name":"someXXperson", "graduation_year":"2023", "major":"math"}
# {"student_name":"liXXyao", "graduation_year":"2025", "major":"physics"}



# Read the Kafka source into a Spark DataFrame
df = (
    spark.readStream.format("kafka")
    .option("kafka.bootstrap.servers", "host1:port1,host2:port2")
    .option("subscribe", subscribeTopic)
    .load()
)


# Create a function that cleans the input data
schema = StructType([
 StructField("student_name", StringType()),
 StructField("graduation_year", StringType()),
 StructField("major", StringType()),
])


def with_normalized_names(df, schema):
    parsed_df = (
        df.withColumn("json_data", from_json(col("value").cast("string"), schema))
        .withColumn("student_name", col("json_data.student_name"))
        .withColumn("graduation_year", col("json_data.graduation_year"))
        .withColumn("major", col("json_data.major"))
        .drop(col("json_data"))
        .drop(col("value"))
    )
    split_col = split(parsed_df["student_name"], "XX")
    return (
        parsed_df.withColumn("first_name", split_col.getItem(0))
        .withColumn("last_name", split_col.getItem(1))
        .drop("student_name")
    )


# Create a function that will read all of the new data in Kafka whenever it’s run
def perform_available_now_update():
    checkpointPath = "data/tmp_students_checkpoint/"
    path = "data/tmp_students"
    return df.transform(lambda df: with_normalized_names(df)).writeStream.trigger(
        availableNow=True
    ).format("parquet").option("checkpointLocation", checkpointPath).start(path)


# Invoke the perform_available_now_update() function and see the contents of the Parquet table
# You can set up a cron job to run the perform_available_now_update() function every hour so your Parquet table is regularly updated

