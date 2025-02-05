export HIVE_HOME={{ _hadoop.base_path }}/{{ hive_file_name }}
export PATH=$HIVE_HOME/bin:$PATH
export CLASSPATH=$CLASSPATH.:$HIVE_HOME/lib
export HIVE_CONF_DIR={{ _hadoop.base_path }}/{{ hive_file_name }}/conf
