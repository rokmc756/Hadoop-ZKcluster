
[ Word Count ]

$ vi test-word.txt
```
sdkfjads
adfjksdfj
adfkjsdfkj
```


$ hdfs dfs -put ./test-word.txt /user/hive/warehouse/


$ vi wordcount.py
```
# wordcount.py

from pyspark.sql import SparkSession
from pyspark.sql.functions import explode, split, col, count

# PySpark 세션 생성
spark = SparkSession.builder.appName("WordCount").getOrCreate()

# HDFS에서 텍스트 파일 읽기
df = spark.read.text("hdfs://192.168.2.191:9000/user/hive/warehouse/test-word.txt")

# 각 줄을 단어로 분리하여 "word" 컬럼 생성
words_df = df.select(explode(split(col("value"), " ")).alias("word"))

# 각 단어의 발생 횟수 계산
word_counts_df = words_df.groupBy("word").agg(count("word").alias("count"))

# 결과 출력
word_counts_df.show(truncate=False)

# Spark 세션 종료
# spark.stop()
```

$ spark-submit --master local[1] ./wordcount.py

```
~~ snip
25/03/02 18:54:00 INFO CodeGenerator: Code generated in 6.557352 ms
+----------+-----+
|word      |count|
+----------+-----+
|sdkfjads  |1    |
|adfjksdfj |1    |
|adfkjsdfkj|1    |
+----------+-----+
~~ snip
```


[ Run PySpark from Remote ]

$ export SPARK_LOCAL_IP="192.168.2.191"

$ spark-submit --master local ./spark-session.py


```
$ pip install "numpy>=1.16.5,<1.23.0"


$ pip3 install "numpy>=1.26.4,<1.27.0"

```


$ sudo dnf install -y python3-distutils-extra


# https://wikidocs.net/26134

