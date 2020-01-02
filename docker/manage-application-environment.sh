#!/bin/ash
source string-utils.sh
readonly app_ready_url="https://localhost:8888/actuator/health"
readonly app_ready_response='"status":"UP"'
readonly host_properties_path="/home/config-server/host/host.properties"
# Path to template file, which contains tokens which will be replaced with actual secrets.
readonly app_properties_template_path="/home/config-server/app-conf/config-server-vault-application.yml.tpl"
readonly app_properties_path="/home/config-server/app-conf/config-server-vault-application.yml"

setup_container_environment_properties() {
    echo "Setting up default container properties build from host properties file $host_properties_path"
    app_environment=$(ltrim $(grep "env" $host_properties_path | cut -d '=' -f2))
    export env=$app_environment
}

build_app_properties() {
    echo "Trying to build application properties"
    cp $app_properties_template_path $app_properties_path
    for filepath in /home/config-server/secrets/*; do
        filename=$(basename $filepath)
        content=$(echo $(cat $filepath))
        placeholder="<$filename>"
        sed -i -e "s/$placeholder/$content/g" $app_properties_path
    done
    echo "Application properties were build into $app_properties_path"
}

remove_app_properties_after_app_is_ready() {
    # For security reasons properties files used to startup app will be removed, as it contains sensitive data, and is no more required.
    echo "Trying to remove application files with sensitive information which are no more required."
    files_removed_flag=0
    i=0
    while [ "$i" -le 20 ]; do
        app_info=$(curl -k $app_ready_url | grep $app_ready_response)
        if [[ -z "$app_info" ]]; then
            echo "Going to sleep for 2 seconds, As application is not ready yet"
            sleep 2
        else
            rm -f $app_properties_path $app_properties_template_path
            echo "Startup Files containing secret information e.g. passwords and so on have been removed, Because application is ready now, And it does not need those files any more."
            files_removed_flag=1
            break
        fi
        i=$(( i + 1 ))
    done
    if [[ $files_removed_flag -eq 0 ]]; then
        echo "Could not remove files with sensitive information, As application did not seems to be ready after waiting for 40 seconds"
    fi
}

keep_only_environment_specific_keystores(){
    # Docker image has all keystores for all environments. But running container need keystores specific to environment, So removing all others
    cp /home/config-server/app-conf/$env/* /home/config-server/app-conf/
    rm -rf /home/config-server/app-conf/dev /home/config-server/app-conf/test
    echo "Keeping keystores for $env environment only, all others have been removed."
}