# How to create a Spark DataFrame and run simple operations. The examples are on a small DataFrame, so you can easily see the functionality
# Start by creating a Spark Session
from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("demo").getOrCreate()
# Some Spark runtime environments come with pre-instantiated Spark Sessions.
# The getOrCreate() method will use an existing Spark Session or create a new Spark Session if one does not already exist

# Create a Spark DataFrame
# Start by creating a DataFrame with first_name and age columns and four rows of data
df = spark.createDataFrame(
    [
        ("sue", 32),
        ("li", 3),
        ("bob", 75),
        ("heo", 13),
    ],
    ["first_name", "age"],
)

# Use the show() method to view the contents of the DataFrame
df.show()

