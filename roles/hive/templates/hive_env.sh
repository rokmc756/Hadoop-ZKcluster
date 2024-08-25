export HIVE_HOME={{ hadoop.base_path }}/{{ hive_file_name }}
export PATH=$HIVE_HOME/bin:$PATH
export CLASSPATH=$CLASSPATH.:$HIVE_HOME/lib
export HIVE_CONF_DIR={{ hadoop.base_path }}/{{ hive_file_name }}/conf
