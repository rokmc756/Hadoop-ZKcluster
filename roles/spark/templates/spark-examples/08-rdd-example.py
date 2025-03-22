
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


# Spark RDD Example
# The Spark RDD APIs are suitable for unstructured data
# The Spark DataFrame API is easier and more performant for structured data
# Suppose you have a text file called some_text.txt with the following three lines of data

# Compute the count of each word in the text file. Here is how to perform this computation with Spark RDDs
text_file = spark.sparkContext.textFile("some_words.txt")

counts = (
    text_file.flatMap(lambda line: line.split(" "))
    .map(lambda word: (word, 1))
    .reduceByKey(lambda a, b: a + b)
)

# Take a look at the result
counts.collect()

# Spark allows for efficient execution of the query because it parallelizes this computation.
# Many other query engines aren’t capable of parallelizing computations.

