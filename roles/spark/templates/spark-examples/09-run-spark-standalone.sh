spark-submit \
  --class org.apache.spark.examples.SparkPi \
  --master spark://192.168.2.191:7077 \
  --executor-memory 1G \
  --total-executor-cores 1 \
  --conf spark.dynamicAllocation.enabled=false \
  /home/hadoop/spark/examples/jars/spark-examples_2.12-3.5.4.jar \
  10

