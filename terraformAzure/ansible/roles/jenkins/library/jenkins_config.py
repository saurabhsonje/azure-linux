#!/usr/bin/python
import json
from ansible.module_utils.basic import AnsibleModule 
import sys, requests, json

#### Read a jenkins initial password from default location 
def read_password():
    try: 
        file = open('/var/lib/jenkins/secrets/initialAdminPassword') 
        jenkins_init_password = file.readline()
        jenkins_init_password = jenkins_init_password.strip()
        file.close()
        return jenkins_init_password
    except Exception as error:
        return error 
######### 

def setup_jenkins(user,old_pass,new_pass):
    session = requests.Session()
    try:
        session.post('http://localhost:8080/j_acegi_security_check',data={'j_username': 'admin', 'j_password': old_pass})
        get_crumb = session.get('http://localhost:8080/crumbIssuer/api/json')
        crumb = get_crumb.json()['crumb']
        default_plugins = {'dynamicLoad':'true',
                           'plugins':["cloudbees-folder","antisamy-markup-formatter","build-timeout","credentials-binding","timestamper",
                                      "ws-cleanup","ant","gradle","workflow-aggregator","github-branch-source","pipeline-github-lib",
                                      "pipeline-stage-view","git","subversion","ssh-slaves","matrix-auth","pam-auth","ldap","email-ext","mailer"],
                           'Jenkins-Crumb': crumb}
        session.post("http://localhost:8080/pluginManager/installPlugins", json=default_plugins, headers={'Jenkins-Crumb': crumb})
        param_data = {"username": user, "password1": new_pass, "password2": new_pass, "fullname": user, "email": "","Jenkins-Crumb":crumb}
        session.post("http://localhost:8080/setupWizard/createAdminUser", params=param_data)
        get_crumb = session.get('http://localhost:8080/crumbIssuer/api/json')
        crumb = get_crumb.json()['crumb']
        url_config = session.post("http://localhost:8080/setupWizard/configureInstance", data={"rootUrl":"http://localhost:8080/", "Jenkins-Crumb":crumb})
        data = session.post("http://localhost:8080/setupWizard/completeInstall", params={"Jenkins-Crumb":crumb})
    except Exception as e:
        return e
def main():
    argument = dict (
        user_name = dict(required=True, type='str'),
        password = dict(required=True, type='str'),
    )
    module = AnsibleModule( argument_spec = argument )
    user_name = module.params['user_name']
    new_password = module.params['password']
    try: 
        jenkins_password=read_password()
        setup_jenkins(user_name,jenkins_password,new_password)
        j_pass = "Jenkins setuped successfuly "
        data= dict (output=j_pass,)
        module.exit_json(changed=True, success="Setup Installed", msg=data)
    except Exception as e: 
        module.fail_json(msg=e)

if __name__ == '__main__':
    main()

