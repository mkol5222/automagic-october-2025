#!/usr/bin/python3
"""CPStat Monitoring module with Google docstrings.

Module:
    This module parses the output of an CPstat command that runs on
     Gaia machines
    and prepares the output for sending as a metrics for cloud provider.

This module demonstrates documentation as specified by the
`Google Python Style Guide`_.
it is part of an effort to refactor the current cloud code and to improve it's
readability and testing.

Example:
    Examples can be given using either the ``Example`` or ``Examples``
    sections. Sections support any reStructuredText formatting, including
    literal blocks::

        $ python azure_send_metrics.py

Section breaks are created by resuming unindented text. Section breaks
are also implicitly created anytime a new section starts.

Attributes:
    module_level_variable (int): Module level variables may be documented in
        either the ``Attributes`` section of the module docstring, or in an
        inline docstring immediately following the variable.

        Either form is acceptable, but the two should not be mixed. Choose
        one convention to document module level variables and be consistent
        with it.

Todo:
    * TODOs for this module
    * Deprecate the cloudwatch get_cpstat function

.. _Google Python Style Guide:
   http://google.github.io/styleguide/pyguide.html

   Copyright 2020 Check Point Software Technologies LTD
"""
import argparse
import http.client
import json
import logging
import logging.handlers
import os
import pathlib
import subprocess
import sys
from json import JSONDecodeError
from typing import Dict, List

try:
    from cge.azure.cloud_metrics_formatter_azure import format_cpstat_for_azure
    from cge.common.monitoring.cloud_cpstat_parser import \
        collect_cpstat_metrics
    from cge.azure.azure_conf import unprotect_secret, load_configuration
    from cloud_connectors.rest import Azure, request

except ModuleNotFoundError:
    from cloud_metrics_formatter_azure import format_cpstat_for_azure
    from cloud_cpstat_parser import collect_cpstat_metrics
    from azure_conf import unprotect_secret, load_configuration
    from rest import Azure, request

DEFAULT_INSTANCE_JSON = pathlib.Path(
    __file__).parent.absolute() / '../conf/instance.json'
DEFAULT_CLIENT_JSON = pathlib.Path(
    __file__).parent.absolute() / '../conf/cloud_azure_cred.json'

try:
    os.environ['FWDIR']
except KeyError:
    os.environ['FWDIR'] = str(pathlib.Path(__file__).parent.absolute())

OsCommand = List[str]
url = str

logger = logging.getLogger('send_metric')


def check_metadata(meta_file: str = DEFAULT_INSTANCE_JSON):
    if not pathlib.Path(meta_file).is_file():
        save_instance_data()


def save_instance_data(out_file: str = DEFAULT_INSTANCE_JSON):
    # TODO add -f option to force overwrite even if the file exist
    """ Call the Azure api-version=2019-06-01 to get the VM information and
    save it for future use

    Args:
        out_file: file name to store the instance data

    """
    command = ['curl_cli', '-H', 'Metadata:true', 'http://169.254.169.254'
                                                  '/metadata/instance?api'
                                                  '-version=2019-06-01',
               '|', 'jq', '.']
    save_json_data(command, out_file)


def save_json_data(get_command: OsCommand, out_file: str):
    res = subprocess.run(get_command, capture_output=True)
    with open(out_file, 'wb') as f:
        f.write(res.stdout)


def load_azure_configuration(instance_json_file=DEFAULT_INSTANCE_JSON):
    """ Load azure instance information and pack them for azure / rest usage

    This function is temporary for the time being till we will refactor the
    azure / rest file.
    In the future the azure / rest api will use the format that is returned
    from azure as the instance metadata.

    Args:
        instance_json_file: azure metadata as returned from Azure
        (can be created via save_instance_data)

    Returns:

    """
    logger.debug(f'Loading {instance_json_file}')
    with open(instance_json_file, 'r') as azure_file:
        instance = json.loads(azure_file.read())
    # logger.debug(f'Instance data: {instance}')
    return prepare_configuration(instance)


def prepare_configuration(instance: dict):
    """ Pack azure instance information format in a format valid for
    azure.py / rest.py usage

    This function is temporary for the time being till we will refactor the
    azure / rest file.
    In the future the azure / rest api will use the format that is returned
    from azure as the instance metadata.

    Args:
        instance: azure metadata as returned from Azure
        (can be created via save_instance_data)

    Returns:

    """
    vmss = instance['compute'].get('vmScaleSetName', "")
    if vmss == "":
        as_vm = True
    else:
        as_vm = False
    conf = {
        'subscriptionId': instance['compute']['subscriptionId'],
        'resourceGroup': instance['compute']['resourceGroupName'],
        'resourceId': instance['compute']['resourceId'],
        'region': instance['compute']['location'],
        'environment': instance['compute']['azEnvironment'],
        'name': instance['compute']['name'],
        'vmss': vmss,
        'sendAsVm': as_vm,
    }

    return conf


def load_client_data(client_json_file: str = DEFAULT_CLIENT_JSON):
    with open(client_json_file, 'r') as client_data:
        client = json.loads(client_data.read())
    logger.debug(client)
    return client


def load_client_secure(client_json_file: str = DEFAULT_CLIENT_JSON):
    conf = load_configuration(client_json_file)
    unprotect_secret(conf)
    logger.debug(conf)
    return conf


"""
The below code is using python standard libraries directly without the help of
the rest /azure.py.
It is WIP intended to replace sometime the rest.py / azure.py functionality
and can be used in the mean time to debug the code on Win PC
"""


class ValueError(Exception):
    """Base class for exceptions in this module."""
    pass


class DictError(ValueError):
    """Base class for exceptions in dictionary input to the function.

    Attributes:
        dict -- input credentials dictionary provided by user
        message -- explanation of the error
    """

    def __init__(self, dict, message):
        self.dict = dict
        self.message = message


class CredentialsError(DictError):
    """Exception raised for errors in the Credentials input."""
    pass


class ResourceError(DictError):
    """Exception raised for errors in the Resource input."""
    pass


class JsonError(RuntimeError):
    pass


# TODO decide if TokenError exception should inherit from
#  requests.exceptions.RequestException
# TODO see how the different exceptions print default messages

class TokenError(Exception):
    """Exception raised for errors in the Credentials input."""
    pass


class MetricsError(Exception):
    """Exception raised for errors send Metrics."""
    pass


class AzureApi:
    """
    AzureApi is a new api for working with Azure.
    It's aim is to provide rest api that will work both on WIN PC as well as on
    Gaia in the cloud.

    Currently it provides only partial functionality of the rest/azure.py lib,
    and can be used mainly as a utility
    for developing the code on PC.

    """

    def __init__(self, client_dict: Dict = None):
        """

        Args:
            client_dict:
        """
        self.token = None
        self.IAM = None
        if client_dict is None:
            self.IAM = 'IAM'
        else:
            try:
                self.tenant_id = client_dict['credentials']['tenant']
                self.client_id = client_dict['credentials']['client_id']
                self.client_secret = client_dict['credentials'][
                    'client_secret']
                self.grant_type = client_dict['credentials']['grant_type']
            except KeyError:
                raise CredentialsError(client_dict,
                                       "Client dictionary should have valid "
                                       "azure value, at least one of "
                                       "the values is missing from the input")

    def request_token(self):
        if self.IAM:
            conn = http.client.HTTPConnection("169.254.169.254")
            url = '/metadata/identity/oauth2/token?api-version=2018-02-01' \
                  '&resource=https://management.azure.com/ '
            payload = ''
            headers = {
                'Metadata': 'true',
            }
            conn.request("GET", url, payload, headers)
            res = conn.getresponse()

        else:
            conn = http.client.HTTPSConnection("login.microsoftonline.com")
            url = f'/{self.tenant_id}/oauth2/token'
            payload = f'grant_type={self.grant_type}&' \
                      f'client_id={self.client_id}&' \
                      f'client_secret={self.client_secret}&' \
                      'resource=https://monitoring.azure.com/'
            headers = {
                'Content-Type': 'application/x-www-form-urlencoded',
            }
            conn.request("POST", url, payload, headers)
            res = conn.getresponse()

        if res.status == 200:
            token = json.loads(res.read())
            return token
        else:
            error = json.loads(res.read())
            raise TokenError(error,
                             "Server returned error for the token request")

    def get_metrics_token(self):
        if self.token:
            return self.token
        else:
            return self.request_token()

    def get_metrics_token_value(self):
        return self.get_metrics_token()['access_token']

    def azure_vmss_send_metric(self, my_vmss: Dict, payload: Dict):
        region, resource_id = format_vmss_resource_id(my_vmss)
        return self.azure_send_resource_metric(region, resource_id, payload)

    def azure_vm_send_metric(self, my_vm: Dict, payload: Dict):
        region, resource_id = format_vm_resource_id(my_vm)
        return self.azure_send_resource_metric(region, resource_id, payload)

    def azure_send_resource_metric(self, region: str, metric_resource_id: url,
                                   payload: Dict):
        conn = http.client.HTTPSConnection(f'{region}.monitoring.azure.com')
        headers = {
            'Authorization': f'Bearer {self.get_metrics_token_value()}',
            'Content-Type': 'application/json',
        }
        conn.request("POST", "".join([metric_resource_id, "/metrics"]),
                     str(payload), headers)
        res = conn.getresponse()
        data = res.read()
        print(data.decode("utf-8"))
        if res.status == 200:
            return True
        else:
            raise MetricsError("Can't send metrics to Azure")


def format_resource_id(my_vm: Dict, force_as_vm: bool):
    """ Format the metrics resource id as VM or VMSS

    Args:
        my_vm: all data needed to format the metrics data
        force_as_vm: True for forcing formatting as VM even when part
                        of VMSS
                    False for normal VMSS metrics.
                    For normal VM is parameter  is ignored

    Returns: resource_id for the metrics

    """

    if my_vm["vmss"] == "":
        return format_vm_resource_id(my_vm)
    elif not force_as_vm:
        return format_vmss_resource_id(my_vm)
    else:
        return format_vmss_as_vm_resource_id(my_vm)


def format_vm_resource_id(my_vm: Dict):
    # TODO change the key name from resourceGroup to resourceGroups
    try:
        region = my_vm["region"]
        resource_id = f'/subscriptions/{my_vm["subscriptionId"]}' \
                      f'/resourceGroups/{my_vm["resourceGroup"]}' \
                      f'/providers/Microsoft.Compute/virtualMachines' \
                      f'/{my_vm["name"]}'
    except KeyError:
        raise ResourceError(my_vm,
                            "Resource dictionary should have valid Azure "
                            "values, at least one of the "
                            "values is missing from the input")
    return region, resource_id


def format_vmss_resource_id(my_vmss: Dict):
    try:
        region = my_vmss["region"]
        resource_id = f'/subscriptions/{my_vmss["subscriptionId"]}' \
                      f'/resourceGroups/{my_vmss["resourceGroup"]}' \
                      '/providers/Microsoft.Compute/virtualMachineScaleSets' \
                      f'/{my_vmss["vmss"]}'
    except KeyError:
        raise ResourceError(my_vmss,
                            "Resource dictionary should have valid Azure "
                            "values, at least one of the "
                            "values is missing from the input")
    return region, resource_id


def format_vmss_as_vm_resource_id(my_vmss: Dict):
    try:
        region = my_vmss["region"]
        instance = my_vmss["name"].split("_")[-1]
        resource_id = f'/subscriptions/{my_vmss["subscriptionId"]}' \
                      f'/resourceGroups/{my_vmss["resourceGroup"]}' \
                      '/providers/Microsoft.Compute/virtualMachineScaleSets' \
                      f'/{my_vmss["vmss"]}/virtualMachines/{instance}'
    except KeyError:
        raise ResourceError(my_vmss,
                            "Resource dictionary should have valid Azure "
                            "values, at least one of the "
                            "values is missing from the input")
    return region, resource_id


def send_cpstat_metrics(raw_metrics, conf=None):
    logger.debug('loading conf')
    if conf is None:
        conf = load_azure_configuration()
    logger.debug(f'Configuration loaded {conf}')
    for metric in map(format_cpstat_for_azure, raw_metrics):
        logger.debug(f'Sending {metric}')
        headers, document = send_metric(my_vm=conf, payload=metric)
        logger.debug(f'response {headers}, {document}')
        logger.info(f"Metric sent successfully - {metric}")


def send_metric2(my_vmss, payload, client_data=None):
    # using rest request This function is not in use currently it is more as
    # an example of using the request API The actual send is done vi the
    # metric API
    if client_data is None:
        client_data = load_client_secure()
    azure = Azure(credentials=client_data['credentials'])
    with azure.get_token(resource="https://monitoring.azure.com/") as token:
        method = 'POST'
        body = json.dumps(payload)
        headers = [
            f'Authorization: Bearer {token}',
            'Content-Type: application/json',
        ]

        region, resource_id = format_vmss_resource_id(my_vmss)
        host = f'https://{region}.monitoring.azure.com'
        url = host + resource_id + '/metrics'
        return request(method, url, body=body, headers=headers)


def send_metric(my_vm, payload, client_data=None):
    # using rest monitoring
    if client_data is None:
        client_data = load_client_secure()
    azure = Azure(credentials=client_data['credentials'])
    send_as_vm = client_data.get('sendAsVm', False)
    region, resource_id = format_resource_id(my_vm, send_as_vm)
    metrics_data = json.dumps(payload)
    headers, body = azure.monitoring('POST', region, resource_id, metrics_data)
    return headers, body


def validate_options(options):
    # TODO add check for json file content (and name?)
    try:
        with open(options.credentials_file, 'r') as cred_file:
            json.loads(cred_file.read())
    except FileNotFoundError as e:
        logger.error(f"Credentials_file no file error: {e}")
        raise
    except JSONDecodeError as e:
        msg = f"Credentials_file error - probably {options.credentials_file}" \
              "is not a json file, or formatted " \
              f"incorrectly. The following error was reported: {e.msg}"
        raise JSONDecodeError(msg, doc=e.doc, pos=e.pos)


def setup_log(filename, level=logging.INFO):
    # TODO enable different logging level for console and file,
    logger.setLevel(level)

    fh = logging.handlers.RotatingFileHandler(
        filename, maxBytes=1048576, backupCount=5)
    fh.setLevel(level)
    # create console handler with a higher log level
    ch = logging.StreamHandler()
    ch.setLevel(level)

    # create formatter and add it to the handlers
    formatter1 = logging.Formatter(
        '%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    formatter2 = logging.Formatter('%(name)s - %(levelname)s - %(message)s')
    fh.setFormatter(formatter1)
    ch.setFormatter(formatter2)
    # add the handlers to the logger
    logger.addHandler(fh)
    logger.addHandler(ch)


def parse_arguments(args):
    # define argparse helper meta
    parser = argparse.ArgumentParser(
        description='Send cpstat metrics to Azure.')

    # required = parser.add_argument_group('required arguments')
    optional = parser.add_argument_group()

    # Add arguments to argparse
    optional.add_argument('-d', '--doc', default=False, action='store_true',
                          help='Show module documentation and exit')
    optional.add_argument('-c', '--cred_file', type=str,
                          dest='credentials_file',
                          help='Azure credentials json file',
                          required=False,
                          default='../conf/cloud_azure_cred.json')
    optional.add_argument('-m', "--metrics_file", dest="metrics_file",
                          default='../conf/cloud_cpstat_parser.json',
                          help="Metrics definition json file.")
    optional.add_argument('-v', '--verbose', help="Be verbose",
                          action="store_const", dest="loglevel",
                          const=logging.DEBUG, default=logging.INFO)
    optional.add_argument('-l', '--log', default='/var/log/cloud_metrics.log',
                          help='%(prog)s log file name')
    optional.add_argument('-p', '--pc', default=False, action='store_true',
                          help='Simulate on pc [not using rest.py]')

    options = parser.parse_args(args)
    if options.doc:
        help(sys.modules['__main__'])
        exit(0)
    validate_options(options)
    return options


def main(args):
    parser = parse_arguments(args)
    setup_log(parser.log, parser.loglevel)

    logger.debug("Command line was {}".format(sys.argv))
    logger.debug("Derived options {}".format(parser))
    logger.info("Starting...")

    metrics = collect_cpstat_metrics()
    logger.debug(f'Collected the following metrics: {metrics}')

    check_metadata()
    send_cpstat_metrics(metrics)

    logger.info("Finish...")

    return 0


if __name__ == "__main__":
    status = main(sys.argv[1:])
    sys.exit(status)
