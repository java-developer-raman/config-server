#!/bin/ash
source ./manage-application-environment.sh
# To trap the signals e.g. ctrl + c or SIGTERM initiated by docker container stop command, It will interrupt the
# current waiting process, and then stop will be invoked at last.
trap 'true' SIGINT SIGTERM

start_app() {
 echo "Starting the application"
 java -Dspring.config.location=file:/home/config-server/app-conf/config-server-vault-application.yml -Dlogging.config=/home/config-server/app-conf/logback.xml -jar /home/config-server/config-server.jar &
}

setup_container_environment_properties
build_app_properties
keep_only_environment_specific_keystores
start_app
remove_app_properties_after_app_is_ready

# "${@}", In case if we need to execute the commands passed

# $! means Most recent background process, Wait for most recently background process, i.e. java process, and when
# trap signal will come, it will be interrupted and control will go to next instruction i.e java process
wait $!