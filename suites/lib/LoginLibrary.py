# author: nathanael wettstein
# date: 2019-09-20
# 
# inspired by robotframework quickstart and docker getting-started

import requests

JAVAWEBSERVICE_URL = "http://web:80"


class LoginLibrary(object):

    def __init__(self):
        self._status = ''

    def create_user(self, username, password):
        self._run_command('create_user', username=username, password=password)

    def change_password(self, username, old_pwd, new_pwd):
        self._run_command('change_password', username=username, 
                old_pwd=old_pwd, new_pwd=new_pwd)

    def attempt_to_login_with_credentials(self, username, password):
        self._run_command('login', username=username, password=password)

    def status_should_be(self, expected_status):
        if expected_status != self._status:
            raise AssertionError("Expected status to be '%s' but was '%s'."
                                 % (expected_status, self._status))

    def _run_command(self, command, **args):
        url = "{url}/{command}".format(url=JAVAWEBSERVICE_URL, command=command)
        print(url)
        r = requests.get(url, params=args)
        self._status = r.text

