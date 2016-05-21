#!/usr/bin/env python

import os
import sys
import getpass
import time
from calendar import timegm
from datetime import datetime
from optparse import OptionParser
import pipes

# These two have to be installed via pip
from ConfigParser import SafeConfigParser, NoOptionError, NoSectionError
from boto.sts import STSConnection

# TODO: Move to configuration file
CONFIG = {
    'config_file': os.path.expanduser("~/.aws/config"),
    'creds_file': os.path.expanduser("~/.aws/credentials"),
    'master_accounts': ['default',
                        'profile ' + os.environ['PLATFORM'] + '-' + os.environ['ENVIRONMENT']],
    'envvars': [
        'AWS_DEFAULT_REGION',
        'AWS_REGION',
        'AWS_SESSION_NAME',
        'AWS_ACCESS_KEY_ID',
        'AWS_SECRET_ACCESS_KEY',
        'AWS_SESSION_TOKEN',
        'AWS_SESSION_EXPIRATION'
    ]
}



def get_option(config, section, option):
    try:
        opt = config.get('%s' % section, option)
    except (NoOptionError, NoSectionError):
        print("Couldn't find %s in profile %s" % (option, section))
        sys.exit(1)

    return opt


def cleanup_environment_vars():
    """Cleans up any AWS environment variables"""
    for envvar in CONFIG['envvars']:
        print("unset %s;" % envvar)


def set_environment_vars(variables):
    """Given a map of environment vars, sets them"""
    for k, v in variables.iteritems():
        print("export %s=%s;" % (k, v))

    print("echo Profile %s is setup for use;" % options.profile)
    try:
        print("echo Assumed role %s in account %s;" % (role, account_id))
    except NameError:
        pass
    print("echo Session expires in 1 hour;")
    print("echo Check AWS_* environment variables for details;")

parser = OptionParser(usage="usage: %prog [options]")

parser.add_option("--profile",
                  action="store",
                  dest="profile",
                  help="Profile to assume",)

(options, args) = parser.parse_args()

if options.profile is None:
    print("echo ERROR: --profile option must be specified;")
    sys.exit(1)

for f in [CONFIG['config_file'], CONFIG['creds_file']]:
    if os.path.isfile(f) is False:
        print("echo %s is required for this script;", f)
        sys.exit(1)

creds = SafeConfigParser()
creds.read(os.path.expanduser("~/.aws/credentials"))

config = SafeConfigParser()
config.read(os.path.expanduser("~/.aws/config"))

if options.profile == "default":
    profile = options.profile
else:
    profile = "profile %s" % options.profile

try:
    region = config.get(profile, 'region')
except NoOptionError:
    region = CONFIG['default_region']
except NoSectionError:
    print("echo ERROR: Profile %s not found in AWS configuration" %
          options.profile)
    sys.exit(1)

session_name = '%s-%s' % (getpass.getuser(), options.profile)

if profile in CONFIG['master_accounts']:
    variables = {
        'AWS_ACCESS_KEY_ID': pipes.quote(get_option(
            creds, options.profile, 'aws_access_key_id')),
        'AWS_SECRET_ACCESS_KEY': pipes.quote(get_option(
            creds, options.profile, 'aws_secret_access_key')),
        'AWS_DEFAULT_REGION': pipes.quote(str(region)),
        'AWS_REGION': pipes.quote(str(region)),
        'AWS_SESSION_NAME': pipes.quote(str(session_name))
    }

    set_environment_vars(variables)
    # Short circuit
    sys.exit(0)

source_profile = get_option(config, profile, 'source_profile')
aws_access_key = get_option(creds, source_profile, 'aws_access_key_id')
aws_secret_key = get_option(creds, source_profile, 'aws_secret_access_key')

role_arn = get_option(config, profile, 'role_arn')
account_id = role_arn.split(':')[4]
role = role_arn.split(':')[5].split('/')[1]

# Find any active session
if os.environ.get('AWS_SESSION_NAME') is not None:
    current_session = os.environ.get('AWS_SESSION_NAME')

    if current_session != session_name:
        print("echo WARNING: De-activating %s role from calling shell;" %
              current_session)
        for envvar in CONFIG['envvars']:
            try:
                del os.environ[envvar]
            except KeyError:
                # If it doesn't exist, doesn't matter
                pass

    if os.environ.get('AWS_SESSION_EXPIRATION') is not None:
        session_expiration = os.environ.get(
            'AWS_SESSION_EXPIRATION').replace('Z', 'GMT')
        expire_time = timegm(
            time.strptime(session_expiration, '%Y-%m-%dT%H:%M:%S%Z'))
        now = (datetime.utcnow() - datetime(1970, 1, 1)).total_seconds()

        if expire_time > now:
            print("echo Found active session for profile %s;" % options.profile)
            print("echo Assumed role %s in account %s;" % (role, account_id))
            print("echo Session expires in %d seconds;" % (expire_time - now))
            sys.exit(0)
        else:
            print("echo Session has expired, cleaning up environment;")
            cleanup_environment_vars()

sts_connection = STSConnection(aws_access_key, aws_secret_key)
aro = sts_connection.assume_role(role_arn=role_arn,
                                 role_session_name=session_name)

# Clean up existing environment
cleanup_environment_vars()

variables = {
    'AWS_ACCESS_KEY_ID': pipes.quote(str(aro.credentials.access_key)),
    'AWS_SECRET_ACCESS_KEY': pipes.quote(str(aro.credentials.secret_key)),
    'AWS_SESSION_TOKEN': pipes.quote(str(aro.credentials.session_token)),
    'AWS_DEFAULT_REGION': pipes.quote(str(region)),
    'AWS_REGION': pipes.quote(str(region)),
    'AWS_SESSION_NAME': pipes.quote(str(session_name)),
    'AWS_SESSION_EXPIRATION': pipes.quote(str(aro.credentials.expiration))
}

set_environment_vars(variables)
